//
//  MAYCollectionViewDataSource.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource.h"
#import "MAYCollectionViewDataSource+UITableView.h"
#import "MAYCollectionViewDataSource+UICollectionView.h"
#import "MAYUtilities.h"

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_dataSource_serialQueue(block)\
dispatch_async(_dataSourceSerialQueue, ^{\
    block();\
});

#define dispatch_barrier_dataSource_serialQueue(block)\
dispatch_barrier_async(_dataSourceSerialQueue, ^{\
    dispatch_main_sync_safe(block);\
})

@interface UIView (DataSource)

@property(nonatomic, strong) MAYCollectionViewDataSource *may_dataSource;

@end

@implementation UIView (DataSource)

MAYSynthesize(strong, MAYCollectionViewDataSource *, may_dataSource, setMay_dataSource);

@end

@interface MAYCollectionViewDataSource ()

@property(nonatomic, weak) UIView *collectionView;
@property(nonatomic, strong) NSMutableArray<NSArray *> *headerSource;
@property(nonatomic, strong) NSMutableArray<NSArray *> *cellSource;
@property(nonatomic, strong) NSMutableArray<NSArray *> *footerSource;

@end

@implementation MAYCollectionViewDataSource {
    dispatch_queue_t _dataSourceSerialQueue;
}

- (instancetype)initWithView:(__kindof UIView *)view {
    self = [super init];
    if (self) {

        _headerSource = [NSMutableArray array];
        _cellSource = [NSMutableArray array];
        _footerSource = [NSMutableArray array];
        _dataSourceSerialQueue = dispatch_queue_create("com.uwozai.collectionViewDataSource", DISPATCH_QUEUE_SERIAL);

        self.collectionView = view;
        view.may_dataSource = self;

        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = view;
            tableView.dataSource = self;
            tableView.delegate = self;
        } else if ([view isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = view;
            collectionView.dataSource = self;
            collectionView.delegate = self;
        }

    }
    return self;
}

#pragma mark - getter

- (NSInteger)numberOfSections {
    return _headerSource.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (section < _headerSource.count) {
        return _cellSource[section].count;
    } else {
        return 0;
    }
}

@end

@implementation MAYCollectionViewDataSource (SourceMaker)

#pragma mark - add

- (void)addCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource {
    dispatch_dataSource_serialQueue(^{
        [self addCellSource:cellSource headerSource:nil footerSource:nil];
    });
}

- (void)addCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource headerSource:(MAYCollectionViewHeaderSource *)headerSource {
    dispatch_dataSource_serialQueue(^{
        [self addCellSource:cellSource headerSource:headerSource footerSource:nil];
    });
}

- (void)addCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource headerSource:(MAYCollectionViewHeaderSource *)headerSource footerSource:(MAYCollectionViewFooterSource *)footerSource {
    dispatch_dataSource_serialQueue(^{
        [self.headerSource addObject:headerSource ? @[headerSource] : @[]];
        [self.cellSource addObject:cellSource.count != 0 ? cellSource : @[]];
        [self.footerSource addObject:footerSource ? @[footerSource] : @[]];
    });
}

#pragma mark - insert

- (void)insertCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource atIndexPath:(NSIndexPath *)indexPath updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{
        if (cellSource.count > 0) {
            if (indexPath.section < [self numberOfSections]) {
                NSMutableArray *rawCell = [[NSMutableArray alloc] initWithArray:[self cellSourcesInSection:indexPath.section] ?: @[]];
                if (indexPath.row < rawCell.count) {
                    [rawCell insertObjects:cellSource atIndexes:[NSIndexSet indexSetWithIndex:indexPath.row]];
                } else {
                    [rawCell addObjectsFromArray:cellSource];
                }
                _cellSource[indexPath.section] = rawCell;
            } else {
                [self addCellSource:cellSource];
            }
            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

- (void)insertCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource headerSource:(MAYCollectionViewHeaderSource *)headerSource footerSource:(MAYCollectionViewFooterSource *)footerSource inSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{
        if (cellSource.count > 0) {
            if (section < [self numberOfSections]) {

                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
                [_headerSource insertObjects:headerSource ? @[headerSource] : @[] atIndexes:indexSet];
                [_cellSource insertObjects:cellSource.count > 0 ? cellSource : @[] atIndexes:indexSet];
                [_footerSource insertObjects:footerSource ? @[footerSource] : @[] atIndexes:indexSet];

            } else {
                [self addCellSource:cellSource headerSource:headerSource footerSource:footerSource];
            }
            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

#pragma mark - delete

- (void)deleteHeaderInSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{

        if (section < [self numberOfSections]) {
            _headerSource[section] = @[];
            if ([self __needDeleteSection:section]) {
                [self deleteSection:section updateHandler:nil];
            }
            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }

    });
}

- (void)deleteCellSourceAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{

        if (indexPaths.count > 0) {
            NSArray<NSIndexPath *> *copyIndexPaths = [indexPaths copy];
            NSMutableDictionary *deleteIndexDict = [NSMutableDictionary dictionary];
            [copyIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull indexPath, NSUInteger idx, BOOL *_Nonnull stop) {
                if (indexPath.section < [self numberOfSections] && indexPath.row < [self numberOfItemsInSection:indexPath.section]) {
                    NSMutableArray *deleteIndexArray = deleteIndexDict[@(indexPath.section)];
                    if (!deleteIndexArray) {
                        deleteIndexArray = [NSMutableArray array];
                        deleteIndexDict[@(indexPath.section)] = deleteIndexArray;
                    }
                    [deleteIndexArray addObject:@(indexPath.row)];
                }
            }];

            [deleteIndexDict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, NSMutableArray *rows, BOOL *_Nonnull stop) {
                NSInteger section = [key integerValue];
                NSMutableArray *mArrayCellSource = [[NSMutableArray alloc] initWithArray:_cellSource[section]];
                NSMutableArray *deleteObjs = [NSMutableArray array];
                [rows enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    NSInteger row = [obj integerValue];
                    if (row < _cellSource[section].count) {
                        [deleteObjs addObject:_cellSource[section][row]];
                    }
                }];
                [mArrayCellSource removeObjectsInArray:deleteObjs];
                _cellSource[section] = mArrayCellSource;
                if ([self __needDeleteSection:section]) {
                    [self deleteSection:section updateHandler:nil];
                }
            }];

            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }


    });
}

- (void)deleteFooterInSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{

        if (section < [self numberOfSections]) {
            _footerSource[section] = @[];
            if ([self __needDeleteSection:section]) {
                [self deleteSection:section updateHandler:nil];
            }
            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }

    });
}

- (BOOL)__needDeleteSection:(NSInteger)section {
    if (section < [self numberOfSections] && [self numberOfItemsInSection:section] == 0 && _headerSource[section].count == 0 && _footerSource[section].count == 0) {
        return YES;
    }
    return NO;
}

- (void)deleteSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{
        if (section < [self numberOfSections]) {
            [_headerSource removeObjectAtIndex:section];
            [_cellSource removeObjectAtIndex:section];
            [_footerSource removeObjectAtIndex:section];
            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

#pragma mark - reload

- (void)reloadHeader:(MAYCollectionViewHeaderSource *)headerSource inSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{
        if (section < [self numberOfSections]) {

            _headerSource[section] = @[headerSource];

            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

- (void)reloadCellSource:(MAYCollectionViewCellSource *)cellSource atIndexPath:(NSIndexPath *)indexPath updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{

        if (indexPath.section < [self numberOfSections] && indexPath.row < [self numberOfItemsInSection:indexPath.section]) {

            NSMutableArray *cells = [NSMutableArray arrayWithArray:_cellSource[indexPath.section]];
            cells[indexPath.row] = cellSource;
            _cellSource[indexPath.section] = cells;

            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

- (void)reloadFooter:(MAYCollectionViewFooterSource *)footerSource inSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{
        if (section < [self numberOfSections]) {

            _footerSource[section] = @[footerSource];

            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

- (void)reloadSection:(NSArray<MAYCollectionViewCellSource *> *)cellSource headerSource:(MAYCollectionViewHeaderSource *)headerSource footerSource:(MAYCollectionViewFooterSource *)footerSource inSection:(NSInteger)section updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{

        if (section < [self numberOfSections]) {

            _headerSource[section] = @[headerSource];
            _cellSource[section] = cellSource;
            _footerSource[section] = @[footerSource];

            if (handler) {
                dispatch_barrier_dataSource_serialQueue(^{
                    handler(self.collectionView);
                });
            }
        }
    });
}

- (void)performBatchUpdates:(void (^)(void))updates updateHandler:(void (^)(__kindof UIView *))handler {
    dispatch_dataSource_serialQueue(^{

        if (updates) {
            updates();
        }

        if (handler) {
            dispatch_barrier_dataSource_serialQueue(^{
                handler(self.collectionView);
            });
        }

    });
}

#pragma mark - get

- (MAYCollectionViewCellSource *)cellSourceAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [self numberOfSections] || indexPath.row >= [self numberOfItemsInSection:indexPath.section]) {
        return nil;
    } else {
        return self.cellSource[indexPath.section][indexPath.row];
    }
}

- (NSArray<MAYCollectionViewCellSource *> *)cellSourcesInSection:(NSInteger)section {
    if (section < [self numberOfSections]) {
        return _cellSource[section];
    } else {
        return nil;
    }
}

- (NSIndexPath *)indexPathForCellSource:(__kindof MAYCollectionViewCellSource *)cellSource {
    __block NSIndexPath *indexPath = nil;
    [[_cellSource copy] enumerateObjectsUsingBlock:^(NSArray *_Nonnull cells, NSUInteger section, BOOL *_Nonnull stop) {
        [cells enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger row, BOOL *_Nonnull canStop) {
            if ([obj isEqual:cellSource]) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                *stop = YES;
            }
        }];
        *stop = indexPath != nil;
    }];
    return indexPath;
}

- (MAYCollectionViewHeaderSource *)headerSourceInSection:(NSInteger)section {
    if (section < [self numberOfSections] && _headerSource[section].count > 0) {
        return _headerSource[section].firstObject;
    } else {
        return nil;
    }
}

- (NSInteger)sectionForHeaderSource:(__kindof MAYCollectionViewHeaderSource *)headerSource {
    __block NSInteger result = NSNotFound;
    [[_headerSource copy] enumerateObjectsUsingBlock:^(NSArray *_Nonnull sources, NSUInteger section, BOOL *_Nonnull stop) {
        if ([sources containsObject:headerSource]) {
            result = section;
            *stop = YES;
        }
    }];
    return result;
}

- (MAYCollectionViewFooterSource *)footerSourceInSection:(NSInteger)section {
    if (section < [self numberOfSections] && _footerSource[section].count > 0) {
        return _footerSource[section].firstObject;
    } else {
        return nil;
    }
}

- (NSInteger)sectionForFooterSource:(__kindof MAYCollectionViewFooterSource *)footerSource {
    __block NSInteger result = NSNotFound;
    [[_footerSource copy] enumerateObjectsUsingBlock:^(NSArray *_Nonnull sources, NSUInteger section, BOOL *_Nonnull stop) {
        if ([sources containsObject:footerSource]) {
            result = section;
            *stop = YES;
        }
    }];
    return result;
}

@end
