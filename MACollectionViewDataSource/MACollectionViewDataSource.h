//
//  MACollectionViewDataSource.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

@import UIKit;
#import "MACollectionViewItemSource.h"

@interface MACollectionViewDataSource : NSObject

@property(nonatomic, readonly) NSInteger numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/// view isKindOfClass UITableView or UICollectionView
- (instancetype)initWithView:(__kindof UIView *)view NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

#define DECL_HANDLER(signature) signature updateHandler:(void(^)(__kindof UIView *view))handler;

@interface MACollectionViewDataSource (SourceMaker)

- (void)addCellSource:(NSArray<MACollectionViewCellSource *> *)cellSource;

- (void)addCellSource:(NSArray<MACollectionViewCellSource *> *)cellSource
         headerSource:(MACollectionViewHeaderSource *)headerSource;

- (void)addCellSource:(NSArray<MACollectionViewCellSource *> *)cellSource
         headerSource:(MACollectionViewHeaderSource *)headerSource
         footerSource:(MACollectionViewFooterSource *)footerSource;

DECL_HANDLER(-(void) insertCellSource:(NSArray<MACollectionViewCellSource *> *)cellSource
        headerSource:(MACollectionViewHeaderSource *)headerSource
        footerSource:(MACollectionViewFooterSource *)footerSource
        inSection:(NSInteger)section)

DECL_HANDLER(-(void) insertCellSource:(NSArray<MACollectionViewCellSource *> *)cellSource atIndexPath:(NSIndexPath *)indexPath)

DECL_HANDLER(-(void) deleteHeaderInSection:(NSInteger)section)

DECL_HANDLER(-(void) deleteCellSourceAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths)

DECL_HANDLER(-(void) deleteFooterInSection:(NSInteger)section)
/// delete all section elements source
DECL_HANDLER(-(void) deleteSection:(NSInteger)section)

DECL_HANDLER(-(void) reloadHeader:(MACollectionViewHeaderSource *)headerSource inSection:(NSInteger)section)

DECL_HANDLER(-(void) reloadCellSource:(MACollectionViewCellSource *)cellSource atIndexPath:(NSIndexPath *)indexPath)

DECL_HANDLER(-(void) reloadFooter:(MACollectionViewFooterSource *)footerSource inSection:(NSInteger)section)

DECL_HANDLER(-(void) reloadSection:(NSArray<MACollectionViewCellSource *> *)cellSource
        headerSource:(MACollectionViewHeaderSource *)headerSource
        footerSource:(MACollectionViewFooterSource *)footerSource
        inSection:(NSInteger)section)

- (__kindof MACollectionViewCellSource *)cellSourceAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<__kindof MACollectionViewCellSource *> *)cellSourcesInSection:(NSInteger)section;

- (__kindof MACollectionViewHeaderSource *)headerSourceInSection:(NSInteger)section;

- (__kindof MACollectionViewFooterSource *)footerSourceInSection:(NSInteger)section;

DECL_HANDLER(-(void) performBatchUpdates:(void (^)(void))updates)

@end
