//
//  MACollectionViewDataSource+UICollectionView.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MACollectionViewDataSource.h"

@interface MACollectionViewDataSource (UICollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView interceptedCollectionViewDelegate:(id <UICollectionViewDelegate>)delegate;

@end

@interface MACollectionViewCellSource (UICollectionView)

@property(nonatomic, copy) void (^configCollectionViewCellBlock)(__kindof UICollectionViewCell *cell, __kindof MACollectionViewCellSource *source);
@property(nonatomic, copy) CGSize (^cellSize)(NSIndexPath *indexPath, __kindof MACollectionViewCellSource *source);
@property(nonatomic, copy) void (^performCollectionViewCellActionBlock)(__kindof UICollectionViewCell *cell, __kindof MACollectionViewCellSource *source);


@end

@interface MACollectionViewHeaderSource (UICollectionView)

@property(nonatomic, copy) void (^configCollectionViewHeaderBlock)(__kindof UICollectionReusableView *headerView, __kindof MACollectionViewHeaderSource *source);
@property(nonatomic, copy) CGSize (^headerSize)(NSInteger section, __kindof MACollectionViewHeaderSource *source);

@end

@interface MACollectionViewFooterSource (UICollectionView)

@property(nonatomic, copy) void (^configCollectionViewFooterBlock)(__kindof UICollectionReusableView *footerView, __kindof MACollectionViewFooterSource *source);
@property(nonatomic, copy) CGSize (^footerSize)(NSInteger section, __kindof MACollectionViewFooterSource *source);

@end
