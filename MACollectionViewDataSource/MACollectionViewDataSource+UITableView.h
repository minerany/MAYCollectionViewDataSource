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

@property(nonatomic, copy) CGFloat (^cellHeight)(NSIndexPath *indexPath, __kindof MACollectionViewCellSource *source);


@end

@interface MACollectionViewHeaderSource (UITableView)

@property(nonatomic, copy) CGFloat (^headerHeight)(NSInteger section, __kindof MACollectionViewHeaderSource *source);

@end

@interface MACollectionViewFooterSource (UITableView)

@property(nonatomic, copy) CGFloat (^footerHeight)(NSInteger section, __kindof MACollectionViewFooterSource *source);

@end
