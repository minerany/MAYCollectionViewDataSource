//
//  MAYCollectionViewDataSource+UICollectionView.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource+UICollectionView.h"
#import "MAYCollectionViewProxy.h"
#import "MAYUtilities.h"

@interface UICollectionView (CollectionViewProxy)

@property(nonatomic, strong) MAYCollectionViewProxy *may_collectionViewProxy;

@end

@implementation UICollectionView (CollectionViewProxy)

- (void)setMay_collectionViewProxy:(MAYCollectionViewProxy *)may_collectionViewProxy {
    self.delegate = (id <UICollectionViewDelegate>) may_collectionViewProxy;
    objc_setAssociatedObject(self, @selector(may_collectionViewProxy), may_collectionViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MAYCollectionViewProxy *)may_collectionViewProxy {
    return objc_getAssociatedObject(self, @selector(may_collectionViewProxy));
}

@end

@implementation MAYCollectionViewDataSource (UICollectionView)

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView interceptedCollectionViewDelegate:(id <UICollectionViewDelegate>)delegate {
    self = [self initWithView:collectionView];
    if (self && delegate) {
        collectionView.may_collectionViewProxy = [MAYCollectionViewProxy proxyWithDelegates:@[delegate, self]];
    }
    return self;
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
