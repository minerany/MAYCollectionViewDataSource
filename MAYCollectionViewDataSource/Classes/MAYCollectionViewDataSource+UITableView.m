//
//  MAYCollectionViewDataSource+UITableView.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource+UITableView.h"
#import "MAYCollectionViewProxy.h"
#import "MAYUtilities.h"

@interface UITableView (TableViewProxy)

@property(nonatomic, strong) MAYCollectionViewProxy *may_tableViewProxy;

@end

@implementation UITableView (TableViewProxy)

- (void)setMay_tableViewProxy:(MAYCollectionViewProxy *)may_tableViewProxy {
    self.delegate = (id <UITableViewDelegate>) may_tableViewProxy;
    objc_setAssociatedObject(self, @selector(may_tableViewProxy), may_tableViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MAYCollectionViewProxy *)may_tableViewProxy {
    return objc_getAssociatedObject(self, @selector(may_tableViewProxy));
}

@end

@implementation MAYCollectionViewDataSource (UITableView)

- (instancetype)initWithTableView:(UITableView *)tableView interceptedTableViewDelegate:(id <UITableViewDelegate>)delegate {
    self = [self initWithView:tableView];
    if (self && delegate) {
        tableView.may_tableViewProxy = [MAYCollectionViewProxy proxyWithDelegates:@[delegate, self]];
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
    return 0;
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
    return 0;
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
