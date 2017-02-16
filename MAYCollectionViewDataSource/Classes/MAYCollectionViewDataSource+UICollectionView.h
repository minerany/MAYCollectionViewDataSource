//
//  MAYCollectionViewDataSource+UICollectionView.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource.h"

@interface MAYCollectionViewDataSource (UICollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView interceptedCollectionViewDelegate:(id <UICollectionViewDelegate>)delegate;

@end

@interface MAYCollectionViewCellSource (UICollectionView)

@property(nonatomic, copy) CGSize (^cellSize)(NSIndexPath *indexPath, __kindof MAYCollectionViewCellSource *source);


@end

@interface MAYCollectionViewHeaderSource (UICollectionView)

@property(nonatomic, copy) CGSize (^headerSize)(NSInteger section, __kindof MAYCollectionViewHeaderSource *source);

@end

@interface MAYCollectionViewFooterSource (UICollectionView)

@property(nonatomic, copy) CGSize (^footerSize)(NSInteger section, __kindof MAYCollectionViewFooterSource *source);

@end
