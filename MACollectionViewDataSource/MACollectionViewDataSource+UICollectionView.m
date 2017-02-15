//
//  MACollectionViewDataSource+UICollectionView.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MACollectionViewDataSource+UICollectionView.h"
#import "MACollectionViewProxy.h"
#import "MAUtilities.h"

@interface UICollectionView (TableViewProxy)

@property(nonatomic, strong) MACollectionViewProxy *ma_collectionViewProxy;

@end

@implementation UICollectionView (TableViewProxy)

- (void)setMa_collectionViewProxy:(MACollectionViewProxy *)ma_collectionViewProxy {
    self.delegate = (id <UICollectionViewDelegate>) ma_collectionViewProxy;
    objc_setAssociatedObject(self, @selector(ma_collectionViewProxy), ma_collectionViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MACollectionViewProxy *)ma_collectionViewProxy {
    return objc_getAssociatedObject(self, @selector(ma_collectionViewProxy));
}

@end

@implementation MACollectionViewDataSource (UICollectionView)

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView interceptedCollectionViewDelegate:(id <UICollectionViewDelegate>)delegate {
    self = [self initWithView:collectionView];
    if (self && delegate) {
        collectionView.ma_collectionViewProxy = [MACollectionViewProxy proxyWithDelegates:@[delegate, self]];
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
    MACollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellSource.identifier forIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.configTarget, cellSource.configSelector, cell, cellSource);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MACollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    if (cellSource.cellSize) {
        return cellSource.cellSize(indexPath, cellSource);
    }
    return CGSizeMake(60, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MACollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.actionTarget, cellSource.actionSelector, [collectionView cellForItemAtIndexPath:indexPath], cellSource);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        MACollectionViewHeaderSource *headerSource = [self headerSourceInSection:indexPath.section];
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerSource.identifier forIndexPath:indexPath];
        PerformSelectorWithTarget(headerSource.configTarget, headerSource.configSelector, headerView, headerSource);
        return headerView;

    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

        MACollectionViewFooterSource *footerSource = [self footerSourceInSection:indexPath.section];
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerSource.identifier forIndexPath:indexPath];
        PerformSelectorWithTarget(footerSource.configTarget, footerSource.configSelector, footerView, footerSource);
        return footerView;

    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    MACollectionViewHeaderSource *headerSource = [self headerSourceInSection:section];
    if (headerSource.headerSize) {
        return headerSource.headerSize(section, headerSource);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    MACollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    if (footerSource.footerSize) {
        return footerSource.footerSize(section, footerSource);
    }
    return CGSizeZero;
}

@end

@implementation MACollectionViewCellSource (UICollectionView)

MASynthesize(copy,
        CGSize(^)(NSIndexPath * indexPath,
        __kindof MACollectionViewCellSource *source),
        cellSize, setCellSize);

@end

@implementation MACollectionViewHeaderSource (UICollectionView)

MASynthesize(copy,
        CGSize(^)(NSInteger
        section,
        __kindof MACollectionViewHeaderSource *source),
        headerSize, setHeaderSize);

@end

@implementation MACollectionViewFooterSource (UICollectionView)

MASynthesize(copy,
        CGSize(^)(NSInteger
        section,
        __kindof MACollectionViewFooterSource *source),
        footerSize, setFooterSize);

@end
