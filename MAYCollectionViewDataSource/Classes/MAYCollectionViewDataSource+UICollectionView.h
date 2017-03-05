//
//  MAYCollectionViewDataSource+UICollectionView.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource.h"

@interface MAYCollectionViewDataSource (UICollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) id <UICollectionViewDataSource> interceptedCollectionViewDataSource;
@property(nonatomic, weak) id <UICollectionViewDelegate> interceptedCollectionViewDelegate;

- (void)attachCollectionView:(UICollectionView *)collectionView;

@property(nonatomic, weak, readonly) UICollectionView *attachedCollectionView;

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
