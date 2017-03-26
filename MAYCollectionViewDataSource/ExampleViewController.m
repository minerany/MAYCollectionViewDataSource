//
//  ExampleViewController.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/15.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "ExampleViewController.h"
#import "MAYCollectionViewDataSource+UITableView.h"
#import "CustomTableViewCell.h"
#import "MAYUtilities.h"

@interface ExampleViewController () <UITableViewDelegate>

MAYDeclareConfigCellSelector(__configCustomCell, CustomTableViewCell *, MAYCollectionViewCellSource*)

MAYDeclareCellActionSelector(__performAction, CustomTableViewCell *, MAYCollectionViewCellSource*)

@end

@implementation ExampleViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.rowHeight = UITableViewCellAutomaticHeight;
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"customCell"];

    MAYCollectionViewDataSource *dataSource = [MAYCollectionViewDataSource new];
    dataSource.interceptedTableViewDelegate = self;

    MAYCollectionViewCellSource *cellSource = [MAYCollectionViewCellSource sourceWithIdentifier:@"customCell"];
    cellSource.data = @" hello miner";
    [cellSource setTarget:self configSelector:@selector(__configCustomCell:cellSource:)];
    [cellSource setTarget:self actionSelector:@selector(__performAction:cellSource:)];
    [dataSource addCellSource:@[cellSource]];

    [dataSource attachTableView:_tableView];
}

- (void)__configCustomCell:(CustomTableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
    cell.textLabel.text = cellSource.data;
}

- (void)__performAction:(CustomTableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
    NSLog(@"%@", cellSource.data);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"interceptedTableViewDelegate scrollViewWillBeginDragging");
}

@end
