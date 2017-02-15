//
//  MACollectionViewDataSource+UITableView.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MACollectionViewDataSource.h"
#import "MACollectionViewItemSource.h"

@interface MACollectionViewDataSource (UITableView) <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView interceptedTableViewDelegate:(id <UITableViewDelegate>)delegate;

@end

@interface MACollectionViewCellSource (UITableView)

@property(nonatomic, copy) void (^configTableViewCellBlock)(__kindof UITableViewCell *cell, __kindof MACollectionViewCellSource *source);
@property(nonatomic, copy) CGFloat (^cellHeight)(NSIndexPath *indexPath, __kindof MACollectionViewCellSource *source);
@property(nonatomic, copy) void (^performTableViewCellActionBlock)(__kindof UITableViewCell *cell, __kindof MACollectionViewCellSource *source);


@end

@interface MACollectionViewHeaderSource (UITableView)

@property(nonatomic, copy) void (^configTableViewHeaderBlock)(__kindof UITableViewHeaderFooterView *headerView, __kindof MACollectionViewHeaderSource *source);
@property(nonatomic, copy) CGFloat (^headerHeight)(NSInteger section, __kindof MACollectionViewHeaderSource *source);

@end

@interface MACollectionViewFooterSource (UITableView)

@property(nonatomic, copy) void (^configTableViewFooterBlock)(__kindof UITableViewHeaderFooterView *footerView, __kindof MACollectionViewFooterSource *source);
@property(nonatomic, copy) CGFloat (^footerHeight)(NSInteger section, __kindof MACollectionViewFooterSource *source);

@end
