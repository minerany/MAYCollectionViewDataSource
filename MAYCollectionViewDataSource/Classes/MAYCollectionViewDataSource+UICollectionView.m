//
//  MAYCollectionViewDataSource+UICollectionView.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource+UICollectionView.h"
#import "MAYCollectionViewProxy.h"
#import "UIView+MAYDataSource.h"
#import "MAYUtilities.h"

@interface UICollectionView (CollectionViewProxy)

@property(nonatomic, strong) MAYCollectionViewProxy *may_collectionViewDataSourceProxy;
@property(nonatomic, strong) MAYCollectionViewProxy *may_collectionViewDelegateProxy;

@end

@implementation UICollectionView (CollectionViewProxy)

- (void)setMay_collectionViewDataSourceProxy:(MAYCollectionViewProxy *)may_collectionViewDataSourceProxy {
    self.dataSource = (id <UICollectionViewDataSource>) may_collectionViewDataSourceProxy;
    objc_setAssociatedObject(self, @selector(may_collectionViewDataSourceProxy), may_collectionViewDataSourceProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MAYCollectionViewProxy *)may_collectionViewDataSourceProxy {
    return objc_getAssociatedObject(self, @selector(may_collectionViewDataSourceProxy));
}

- (void)setMay_collectionViewDelegateProxy:(MAYCollectionViewProxy *)may_collectionViewDelegateProxy {
    self.delegate = (id <UICollectionViewDelegate>) may_collectionViewDelegateProxy;
    objc_setAssociatedObject(self, @selector(may_collectionViewDelegateProxy), may_collectionViewDelegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MAYCollectionViewProxy *)may_collectionViewDelegateProxy {
    return objc_getAssociatedObject(self, @selector(may_collectionViewDelegateProxy));
}

@end

@interface MAYCollectionViewDataSource ()

@property(nonatomic, weak) UICollectionView *attachedCollectionView;

@end

@implementation MAYCollectionViewDataSource (UICollectionView)

MAYSynthesize(weak, UICollectionView *, attachedCollectionView, setAttachedCollectionView)

MAYSynthesize(weak, id < UICollectionViewDataSource >, interceptedCollectionViewDataSource, setInterceptedCollectionViewDataSource)

MAYSynthesize(weak, id < UICollectionViewDelegate >, interceptedCollectionViewDelegate, setInterceptedCollectionViewDelegate)

- (void)attachCollectionView:(UICollectionView *)collectionView {
    collectionView.may_dataSource = self;
    self.attachedCollectionView = collectionView;
    if (self.interceptedCollectionViewDelegate) {
        collectionView.may_collectionViewDelegateProxy = [MAYCollectionViewProxy proxyWithDelegates:@[self.interceptedCollectionViewDelegate, self]];
    } else {
        collectionView.delegate = self;
    }
    if (self.interceptedCollectionViewDataSource) {
        collectionView.may_collectionViewDataSourceProxy = [MAYCollectionViewProxy proxyWithDelegates:@[self.interceptedCollectionViewDataSource, self]];
    } else {
        collectionView.dataSource = self;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellSource.identifier forIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.configTarget, cellSource.configSelector, cell, cellSource);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    if (cellSource.cellSize) {
        return cellSource.cellSize(indexPath, cellSource);
    }
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *) collectionViewLayout;
        return flowLayout.itemSize;
    }
    return CGSizeMake(60, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.actionTarget, cellSource.actionSelector, [collectionView cellForItemAtIndexPath:indexPath], cellSource);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        MAYCollectionViewHeaderSource *headerSource = [self headerSourceInSection:indexPath.section];
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerSource.identifier forIndexPath:indexPath];
        PerformSelectorWithTarget(headerSource.configTarget, headerSource.configSelector, headerView, headerSource);
        return headerView;

    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

        MAYCollectionViewFooterSource *footerSource = [self footerSourceInSection:indexPath.section];
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerSource.identifier forIndexPath:indexPath];
        PerformSelectorWithTarget(footerSource.configTarget, footerSource.configSelector, footerView, footerSource);
        return footerView;

    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    MAYCollectionViewHeaderSource *headerSource = [self headerSourceInSection:section];
    if (headerSource.headerSize) {
        return headerSource.headerSize(section, headerSource);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    MAYCollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    if (footerSource.footerSize) {
        return footerSource.footerSize(section, footerSource);
    }
    return CGSizeZero;
}

@end

@implementation MAYCollectionViewCellSource (UICollectionView)

MAYSynthesize(copy,
        CGSize(^)(NSIndexPath * indexPath,
        __kindof MAYCollectionViewCellSource *source),
        cellSize, setCellSize);

@end

@implementation MAYCollectionViewHeaderSource (UICollectionView)

MAYSynthesize(copy,
        CGSize(^)(NSInteger
        section,
        __kindof MAYCollectionViewHeaderSource *source),
        headerSize, setHeaderSize);

@end

@implementation MAYCollectionViewFooterSource (UICollectionView)

MAYSynthesize(copy,
        CGSize(^)(NSInteger
        section,
        __kindof MAYCollectionViewFooterSource *source),
        footerSize, setFooterSize);

@end
