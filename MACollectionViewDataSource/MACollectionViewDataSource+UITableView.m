//
//  MACollectionViewDataSource+UITableView.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MACollectionViewDataSource+UITableView.h"
#import <objc/runtime.h>
#import "MACollectionViewProxy.h"
#import "MAUtilities.h"

@interface UITableView (TableViewProxy)

@property(nonatomic, strong) MACollectionViewProxy *ma_tableViewProxy;

@end

@implementation UITableView (TableViewProxy)

- (void)setMa_tableViewProxy:(MACollectionViewProxy *)ma_tableViewProxy {
    self.delegate = (id <UITableViewDelegate>) ma_tableViewProxy;
    objc_setAssociatedObject(self, @selector(ma_tableViewProxy), ma_tableViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MACollectionViewProxy *)ma_tableViewProxy {
    return objc_getAssociatedObject(self, @selector(ma_tableViewProxy));
}

@end

@implementation MACollectionViewDataSource (UITableView)

- (instancetype)initWithTableView:(UITableView *)tableView interceptedTableViewDelegate:(id <UITableViewDelegate>)delegate {
    self = [self initWithView:tableView];
    if (self && delegate) {
        tableView.ma_tableViewProxy = [MACollectionViewProxy proxyWithDelegates:@[delegate, self]];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MACollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSource.identifier forIndexPath:indexPath];
    PerformTarget(cellSource.configTarget, cellSource.configSelector, cell, cellSource);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MACollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    if (cellSource.cellHeight) {
        return cellSource.cellHeight(indexPath, cellSource);
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MACollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    PerformTarget(cellSource.actionTarget, cellSource.actionSelector, [tableView cellForRowAtIndexPath:indexPath], cellSource);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MACollectionViewHeaderSource *headerSource = [self headerSourceInSection:section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSource.identifier];
    PerformTarget(headerSource.configTarget, headerSource.configSelector, headerView, headerSource);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MACollectionViewHeaderSource *headerSource = [self headerSourceInSection:section];
    if (headerSource.headerHeight) {
        return headerSource.headerHeight(section, headerSource);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MACollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerSource.identifier];
    PerformTarget(footerSource.configTarget, footerSource.configSelector, footerView, footerSource);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    MACollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    if (footerSource.footerHeight) {
        return footerSource.footerHeight(section, footerSource);
    }
    return 0;
}

@end

@implementation MACollectionViewCellSource (UITableView)

MASynthesize(copy,
        CGFloat(^)(NSIndexPath * indexPath,
        __kindof MACollectionViewCellSource *source),
        cellHeight, setCellHeight);

@end

@implementation MACollectionViewHeaderSource (UITableView)

MASynthesize(copy,
        CGFloat(^)(NSInteger
        section,
        __kindof MACollectionViewHeaderSource *source),
        headerHeight, setHeaderHeight);

@end

@implementation MACollectionViewFooterSource (UITableView)

MASynthesize(copy,
        CGFloat(^)(NSInteger
        section,
        __kindof MACollectionViewFooterSource *source),
        footerHeight, setFooterHeight);

@end
