//
//  MAYCellHeightCache.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/3/22.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAYCollectionViewDataSource.h"

@interface MAYCellHeightCache : NSObject

- (id)objectForKeyedSubscript:(id <NSCopying, NSObject>)key;

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying, NSObject>)key;

- (void)invalidateHeightCache;

- (void)insertSections:(NSIndexSet *)sections;

- (void)deleteSections:(NSIndexSet *)sections;

- (void)reloadSections:(NSIndexSet *)sections;

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end

@interface MAYCollectionViewDataSource (HeightCache)

@property(nonatomic, strong) MAYCellHeightCache *heightCache;

@end
