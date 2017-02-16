//
//  MAYCollectionViewDataSource.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

@import UIKit;
#import "MAYCollectionViewItemSource.h"

@interface MAYCollectionViewDataSource : NSObject

@property(nonatomic, readonly) NSInteger numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/// view isKindOfClass UITableView or UICollectionView
- (instancetype)initWithView:(__kindof UIView *)view NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

#define DECL_HANDLER(signature) signature updateHandler:(void(^)(__kindof UIView *view))handler;

@interface MAYCollectionViewDataSource (SourceMaker)

- (void)addCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource;

- (void)addCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource
         headerSource:(MAYCollectionViewHeaderSource *)headerSource;

- (void)addCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource
         headerSource:(MAYCollectionViewHeaderSource *)headerSource
         footerSource:(MAYCollectionViewFooterSource *)footerSource;

DECL_HANDLER(-(void) insertCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource
        headerSource:(MAYCollectionViewHeaderSource *)headerSource
        footerSource:(MAYCollectionViewFooterSource *)footerSource
        inSection:(NSInteger)section)

DECL_HANDLER(-(void) insertCellSource:(NSArray<MAYCollectionViewCellSource *> *)cellSource atIndexPath:(NSIndexPath *)indexPath)

DECL_HANDLER(-(void) deleteHeaderInSection:(NSInteger)section)

DECL_HANDLER(-(void) deleteCellSourceAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths)

DECL_HANDLER(-(void) deleteFooterInSection:(NSInteger)section)
/// delete all section elements source
DECL_HANDLER(-(void) deleteSection:(NSInteger)section)

DECL_HANDLER(-(void) reloadHeader:(MAYCollectionViewHeaderSource *)headerSource inSection:(NSInteger)section)

DECL_HANDLER(-(void) reloadCellSource:(MAYCollectionViewCellSource *)cellSource atIndexPath:(NSIndexPath *)indexPath)

DECL_HANDLER(-(void) reloadFooter:(MAYCollectionViewFooterSource *)footerSource inSection:(NSInteger)section)

DECL_HANDLER(-(void) reloadSection:(NSArray<MAYCollectionViewCellSource *> *)cellSource
        headerSource:(MAYCollectionViewHeaderSource *)headerSource
        footerSource:(MAYCollectionViewFooterSource *)footerSource
        inSection:(NSInteger)section)

- (__kindof MAYCollectionViewCellSource *)cellSourceAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<__kindof MAYCollectionViewCellSource *> *)cellSourcesInSection:(NSInteger)section;

- (NSIndexPath *)indexPathForCellSource:(__kindof MAYCollectionViewCellSource *)cellSource;

- (__kindof MAYCollectionViewHeaderSource *)headerSourceInSection:(NSInteger)section;

- (NSInteger)sectionForHeaderSource:(__kindof MAYCollectionViewHeaderSource *)headerSource;

- (__kindof MAYCollectionViewFooterSource *)footerSourceInSection:(NSInteger)section;

- (NSInteger)sectionForFooterSource:(__kindof MAYCollectionViewFooterSource *)footerSource;

DECL_HANDLER(-(void) performBatchUpdates:(void (^)(void))updates)

@end
