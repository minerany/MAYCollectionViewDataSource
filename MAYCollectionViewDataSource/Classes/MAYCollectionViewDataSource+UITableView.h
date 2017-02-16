//
//  MAYCollectionViewDataSource+UITableView.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource.h"
#import "MAYCollectionViewItemSource.h"

@interface MAYCollectionViewDataSource (UITableView) <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView interceptedTableViewDelegate:(id <UITableViewDelegate>)delegate;

@end

@interface MAYCollectionViewCellSource (UITableView)

@property(nonatomic, copy) CGFloat (^cellHeight)(NSIndexPath *indexPath, __kindof MAYCollectionViewCellSource *source);


@end

@interface MAYCollectionViewHeaderSource (UITableView)

@property(nonatomic, copy) CGFloat (^headerHeight)(NSInteger section, __kindof MAYCollectionViewHeaderSource *source);

@end

@interface MAYCollectionViewFooterSource (UITableView)

@property(nonatomic, copy) CGFloat (^footerHeight)(NSInteger section, __kindof MAYCollectionViewFooterSource *source);

@end
