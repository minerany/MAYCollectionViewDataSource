//
//  MAYCollectionViewDataSource+UITableView.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource+UITableView.h"
#import "UIView+MAYDataSource.h"
#import "MAYCollectionViewProxy.h"
#import "MAYUtilities.h"

@interface UITableView (TableViewProxy)

@property(nonatomic, strong) MAYCollectionViewProxy *may_tableViewDelegateProxy;
@property(nonatomic, strong) MAYCollectionViewProxy *may_tableViewDataSourceProxy;

@end

@implementation UITableView (TableViewProxy)

- (void)setMay_tableViewDelegateProxy:(MAYCollectionViewProxy *)may_tableViewDelegateProxy {
    self.delegate = (id <UITableViewDelegate>) may_tableViewDelegateProxy;
    objc_setAssociatedObject(self, @selector(may_tableViewDelegateProxy), may_tableViewDelegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MAYCollectionViewProxy *)may_tableViewDelegateProxy {
    return objc_getAssociatedObject(self, @selector(may_tableViewDelegateProxy));
}

- (void)setMay_tableViewDataSourceProxy:(MAYCollectionViewProxy *)may_tableViewDataSourceProxy {
    self.dataSource = (id <UITableViewDataSource>) may_tableViewDataSourceProxy;
    objc_setAssociatedObject(self, @selector(may_tableViewDataSourceProxy), may_tableViewDataSourceProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MAYCollectionViewProxy *)may_tableViewDataSourceProxy {
    return objc_getAssociatedObject(self, @selector(may_tableViewDataSourceProxy));
}

@end

@interface MAYCollectionViewDataSource ()

@property(nonatomic, weak) UITableView *attachedTableView;

@end

@implementation MAYCollectionViewDataSource (UITableView)

MAYSynthesize(weak, UITableView *, attachedTableView, setAttachedTableView)

MAYSynthesize(weak, id < UITableViewDataSource >, interceptedTableViewDataSource, setInterceptedTableViewDataSource)

MAYSynthesize(weak, id < UITableViewDelegate >, interceptedTableViewDelegate, setInterceptedTableViewDelegate)

- (void)attachTableView:(UITableView *)tableView {
    tableView.may_dataSource = self;
    self.attachedTableView = tableView;
    if (self.interceptedTableViewDelegate) {
        tableView.may_tableViewDelegateProxy = [MAYCollectionViewProxy proxyWithDelegates:@[self.interceptedTableViewDelegate, self]];
    } else {
        tableView.delegate = self;
    }
    if (self.interceptedTableViewDataSource) {
        tableView.may_tableViewDataSourceProxy = [MAYCollectionViewProxy proxyWithDelegates:@[self.interceptedTableViewDataSource, self]];
    } else {
        tableView.dataSource = self;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSource.identifier forIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.configTarget, cellSource.configSelector, cell, cellSource);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    if (cellSource.cellHeight) {
        return cellSource.cellHeight(indexPath, cellSource);
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.actionTarget, cellSource.actionSelector, [tableView cellForRowAtIndexPath:indexPath], cellSource);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MAYCollectionViewHeaderSource *headerSource = [self headerSourceInSection:section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSource.identifier];
    PerformSelectorWithTarget(headerSource.configTarget, headerSource.configSelector, headerView, headerSource);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MAYCollectionViewHeaderSource *headerSource = [self headerSourceInSection:section];
    if (headerSource.headerHeight) {
        return headerSource.headerHeight(section, headerSource);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MAYCollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerSource.identifier];
    PerformSelectorWithTarget(footerSource.configTarget, footerSource.configSelector, footerView, footerSource);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    MAYCollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    if (footerSource.footerHeight) {
        return footerSource.footerHeight(section, footerSource);
    }
    return CGFLOAT_MIN;
}

@end

@implementation MAYCollectionViewCellSource (UITableView)

MAYSynthesize(copy,
        CGFloat(^)(NSIndexPath * indexPath,
        __kindof MAYCollectionViewCellSource *source),
        cellHeight, setCellHeight);

@end

@implementation MAYCollectionViewHeaderSource (UITableView)

MAYSynthesize(copy,
        CGFloat(^)(NSInteger
        section,
        __kindof MAYCollectionViewHeaderSource *source),
        headerHeight, setHeaderHeight);

@end

@implementation MAYCollectionViewFooterSource (UITableView)

MAYSynthesize(copy,
        CGFloat(^)(NSInteger
        section,
        __kindof MAYCollectionViewFooterSource *source),
        footerHeight, setFooterHeight);

@end
