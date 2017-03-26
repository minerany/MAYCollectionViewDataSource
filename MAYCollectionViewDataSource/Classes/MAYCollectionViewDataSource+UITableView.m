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
#import "MAYCellHeightCache.h"
#import "UITableView+HeightCache.h"

CGFloat const UITableViewCellAutomaticHeight = CGFLOAT_MAX;

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

@property(nonatomic, strong) NSMutableDictionary *cacheHeight;

@end

@implementation MAYCollectionViewDataSource (UITableView)

MAYSynthesize(weak, UITableView *, attachedTableView, setAttachedTableView)

MAYSynthesize(strong, NSMutableDictionary *, cacheHeight, setCacheHeight)

- (void)setInterceptedTableViewDataSource:(id <UITableViewDataSource>)interceptedTableViewDataSource {
    if (![self.interceptedTableViewDataSource isEqual:interceptedTableViewDataSource]) {
        objc_setAssociatedObject(self, @selector(interceptedTableViewDataSource), interceptedTableViewDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self __setTableViewDataSource];
    }
}

- (id <UITableViewDataSource>)interceptedTableViewDataSource {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setInterceptedTableViewDelegate:(id <UITableViewDelegate>)interceptedTableViewDelegate {
    if (![self.interceptedTableViewDelegate isEqual:interceptedTableViewDelegate]) {
        objc_setAssociatedObject(self, @selector(interceptedTableViewDelegate), interceptedTableViewDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self __setTableViewDelegate];
    }
}

- (id <UITableViewDelegate>)interceptedTableViewDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)__setTableViewDelegate {
    if (self.interceptedTableViewDelegate) {
        self.attachedTableView.may_tableViewDelegateProxy = [MAYCollectionViewProxy proxyWithDelegates:@[self.interceptedTableViewDelegate, self]];
    } else {
        self.attachedTableView.delegate = self;
    }
}

- (void)__setTableViewDataSource {
    if (self.interceptedTableViewDataSource) {
        self.attachedTableView.may_tableViewDataSourceProxy = [MAYCollectionViewProxy proxyWithDelegates:@[self.interceptedTableViewDataSource, self]];
    } else {
        self.attachedTableView.dataSource = self;
    }
}

- (void)attachTableView:(UITableView *)tableView {
    tableView.may_dataSource = self;
    self.attachedTableView = tableView;
    [self __setTableViewDataSource];
    [self __setTableViewDelegate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
    UITableViewCell *cell = [self.attachedTableView dequeueReusableCellWithIdentifier:cellSource.identifier forIndexPath:indexPath];
    PerformSelectorWithTarget(cellSource.configTarget, cellSource.configSelector, cell, cellSource);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    BOOL hasSetRowHeight = FLT_GREATER_THAN(rowHeight, 0) && !(FLT_EQUAL_TO(rowHeight, UITableViewCellAutomaticHeight));
    if (!hasSetRowHeight) {
        MAYCollectionViewCellSource *cellSource = [self cellSourceAtIndexPath:indexPath];
        if (tableView.rowHeight == UITableViewCellAutomaticHeight) {
            if (!self.heightCache) {
                self.heightCache = [MAYCellHeightCache new];
            }
            id cacheHeight = self.heightCache[indexPath];
            if (FLT_GREATER_THAN([cacheHeight floatValue], 0)) {
                rowHeight = [cacheHeight floatValue];
            } else {
                UITableViewCell *cell = [tableView may_dequeueReusableTemplateCellWithIdentifier:cellSource.identifier];
                cell.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), UITableViewCellAutomaticHeight);
                PerformSelectorWithTarget(cellSource.configTarget, cellSource.configSelector, cell, cellSource);
                [cell layoutIfNeeded];
                CGFloat height = [cell sizeThatFits:cell.frame.size].height;
                rowHeight = roundf(height) == 0 ? 44 : height;
                self.heightCache[indexPath] = @(rowHeight);
            }
        } else {
            if (cellSource.tableViewCellHeight) {
                rowHeight = cellSource.tableViewCellHeight(indexPath, cellSource);
            } else {
                rowHeight = tableView.rowHeight;
            }
        }
    }
    return rowHeight;
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
    if (headerSource.tableViewHeaderHeight) {
        return headerSource.tableViewHeaderHeight(section, headerSource);
    }
    return tableView.sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MAYCollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerSource.identifier];
    PerformSelectorWithTarget(footerSource.configTarget, footerSource.configSelector, footerView, footerSource);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    MAYCollectionViewFooterSource *footerSource = [self footerSourceInSection:section];
    if (footerSource.tableViewFooterHeight) {
        return footerSource.tableViewFooterHeight(section, footerSource);
    }
    return tableView.sectionFooterHeight;
}

@end

@implementation MAYCollectionViewCellSource (UITableView)

MAYSynthesize(copy,
        CGFloat(^)(NSIndexPath * indexPath,
        __kindof MAYCollectionViewCellSource *source),
        tableViewCellHeight, setTableViewCellHeight);

@end

@implementation MAYCollectionViewHeaderSource (UITableView)

MAYSynthesize(copy,
        CGFloat(^)(NSInteger
        section,
        __kindof MAYCollectionViewHeaderSource *source),
        tableViewHeaderHeight, setTableViewHeaderHeight);

@end

@implementation MAYCollectionViewFooterSource (UITableView)

MAYSynthesize(copy,
        CGFloat(^)(NSInteger
        section,
        __kindof MAYCollectionViewFooterSource *source),
        tableViewFooterHeight, setTableViewFooterHeight);

@end
