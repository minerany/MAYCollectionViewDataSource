//
//  MAYCollectionViewDataSource+UITableView.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewDataSource.h"
#import "MAYCollectionViewItemSource.h"

UIKIT_EXTERN const CGFloat UITableViewCellAutomaticHeight;

@interface MAYCollectionViewDataSource (UITableView) <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id <UITableViewDataSource> interceptedTableViewDataSource;
@property(nonatomic, weak) id <UITableViewDelegate> interceptedTableViewDelegate;

- (void)attachTableView:(UITableView *)tableView;

@property(nonatomic, weak, readonly) UITableView *attachedTableView;

@end

@interface MAYCollectionViewCellSource (UITableView)

@property(nonatomic, copy) CGFloat (^tableViewCellHeight)(NSIndexPath *indexPath, __kindof MAYCollectionViewCellSource *source);


@end

@interface MAYCollectionViewHeaderSource (UITableView)

@property(nonatomic, copy) CGFloat (^tableViewHeaderHeight)(NSInteger section, __kindof MAYCollectionViewHeaderSource *source);

@end

@interface MAYCollectionViewFooterSource (UITableView)

@property(nonatomic, copy) CGFloat (^tableViewFooterHeight)(NSInteger section, __kindof MAYCollectionViewFooterSource *source);

@end
