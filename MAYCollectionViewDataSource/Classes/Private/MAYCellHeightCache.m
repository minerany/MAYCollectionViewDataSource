//
//  MAYCellHeightCache.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/3/22.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCellHeightCache.h"
#import "MAYUtilities.h"
#import <objc/runtime.h>

@implementation MAYCellHeightCache {
    NSMutableArray<NSMutableArray<NSNumber *> *> *_heightCache;
}

- (id)objectForKeyedSubscript:(id <NSCopying, NSObject>)key {
    BOOL isIndexPath = [key isKindOfClass:[NSIndexPath class]];
    NSIndexPath *indexPath = isIndexPath ? (NSIndexPath *) key : nil;
    BOOL isIndexSet = [key isKindOfClass:[NSIndexSet class]];
    NSIndexSet *indexSet = isIndexSet ? (NSIndexSet *) key : nil;
    if (isIndexPath) {
        if (indexPath.section < _heightCache.count) {
            NSMutableArray *rowArray = _heightCache[indexPath.section];
            if (indexPath.row < rowArray.count) {
                return rowArray[indexPath.row];
            }
        }
    } else if (isIndexSet) {
        if (indexSet.firstIndex < _heightCache.count) {
            return _heightCache[indexSet.firstIndex];
        }
    }
    return nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying, NSObject>)key {
    BOOL isIndexPath = [key isKindOfClass:[NSIndexPath class]];
    NSIndexPath *indexPath = isIndexPath ? (NSIndexPath *) key : nil;
    BOOL isIndexSet = [key isKindOfClass:[NSIndexSet class]];
    NSIndexSet *indexSet = isIndexSet ? (NSIndexSet *) key : nil;
    if (isIndexPath) {
        [self __buildCacheAtIndexPath:indexPath];
    } else if (isIndexSet) {
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
            [self __buildCacheAtSection:idx];
        }];
    }

    if (obj) {
        if (isIndexPath) {
            _heightCache[indexPath.section][indexPath.row] = obj;
        }
    } else {
        if (isIndexPath) {
            _heightCache[indexPath.section][indexPath.row] = @-1;
        } else if (isIndexSet) {
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
                _heightCache[idx] = [NSMutableArray array];
            }];
        }
    }
}

- (void)__buildCacheAtSection:(NSInteger)section {
    [self __buildCacheAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:section]];
}

- (void)__buildCacheAtIndexPath:(NSIndexPath *)indexPath {
    if (!_heightCache) {
        _heightCache = [NSMutableArray array];
    }
    if (indexPath.section < _heightCache.count) {
        NSMutableArray *rowArray = _heightCache[indexPath.section];
        for (NSInteger row = rowArray.count; row <= indexPath.row; row++) {
            @autoreleasepool {
                [rowArray addObject:@-1];
            }
        }
    } else {
        for (NSInteger section = _heightCache.count; section <= indexPath.section; section++) {
            @autoreleasepool {
                NSMutableArray *rowArray = [NSMutableArray array];
                [_heightCache addObject:rowArray];
                if (section == indexPath.section) {
                    for (NSInteger row = 0; row <= indexPath.row; row++) {
                        [rowArray addObject:@-1];
                    }
                }
            }
        }
    }
}

- (void)invalidateHeightCache {
    [_heightCache removeAllObjects];
}

- (void)insertSections:(NSIndexSet *)sections {
    for (NSInteger section = _heightCache.count; section < sections.firstIndex; section++) {
        [self __buildCacheAtSection:section];
    }
    [_heightCache insertObjects:[NSMutableArray array] atIndexes:sections];
}

- (void)deleteSections:(NSIndexSet *)sections {
    NSMutableArray *removeSection = [NSMutableArray array];
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *_Nonnull stop) {
        if (section < _heightCache.count) {
            [removeSection addObject:_heightCache[section]];
        }
    }];
    [_heightCache removeObjectsInArray:removeSection];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *_Nonnull stop) {
        if (section < _heightCache.count) {
            _heightCache[section] = [NSMutableArray array];
        }
    }];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [self __buildCacheAtSection:MAX(section, newSection)];
    id tmpSection = _heightCache[section];
    _heightCache[section] = _heightCache[newSection];
    _heightCache[newSection] = tmpSection;
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull indexPath, NSUInteger idx, BOOL *_Nonnull stop) {
        [self __buildCacheAtIndexPath:indexPath];
        [_heightCache[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
    }];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    __block NSMutableDictionary *removeSection = [NSMutableDictionary dictionary];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull indexPath, NSUInteger idx, BOOL *_Nonnull stop) {
        if (indexPath.section < _heightCache.count && indexPath.row < _heightCache[indexPath.section].count) {
            NSMutableIndexSet *removeRows = removeSection[@(indexPath.section)];
            if (!removeRows) {
                removeRows = [NSMutableIndexSet indexSet];
                removeSection[@(indexPath.section)] = removeRows;
            }
            [removeRows addIndex:indexPath.row];
        }
    }];
    [removeSection enumerateKeysAndObjectsUsingBlock:^(id _Nonnull section, NSIndexSet *rows, BOOL *_Nonnull stop) {
        [_heightCache[[section integerValue]] removeObjectsAtIndexes:rows];
    }];
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull indexPath, NSUInteger idx, BOOL *_Nonnull stop) {
        if (indexPath.section < _heightCache.count && indexPath.row < _heightCache[indexPath.section].count) {
            _heightCache[indexPath.section][indexPath.row] = @-1;
        }
    }];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    NSIndexPath *maxIndexPath;
    if (indexPath.section == newIndexPath.section) {
        maxIndexPath = indexPath.row < newIndexPath.row ? newIndexPath : indexPath;
    } else {
        maxIndexPath = indexPath.section < newIndexPath.section ? newIndexPath : indexPath;
    }
    [self __buildCacheAtIndexPath:maxIndexPath];
    id tmpIndexPath = _heightCache[indexPath.section][indexPath.row];
    _heightCache[indexPath.section][indexPath.row] = _heightCache[newIndexPath.section][newIndexPath.row];
    _heightCache[newIndexPath.section][newIndexPath.row] = tmpIndexPath;
}

@end

@implementation MAYCollectionViewDataSource (HeightCache)

MAYSynthesize(strong, MAYCellHeightCache*, heightCache, setHeightCache)

@end
