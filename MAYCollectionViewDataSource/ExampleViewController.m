//
//  ExampleViewController.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/15.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "ExampleViewController.h"
#import "MAYCollectionViewDataSource+UITableView.h"

@interface ExampleViewController () <UITableViewDelegate>

DECL_CONFIG_SEL(__configCustomCell, UITableViewCell *, MAYCollectionViewCellSource*)

DECL_ACTION_SEL(__performAction, UITableViewCell *, MAYCollectionViewCellSource*)

@end

@implementation ExampleViewController {

    UITableView *_tableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    MAYCollectionViewDataSource *dataSource = [MAYCollectionViewDataSource new];
    MAYCollectionViewCellSource *cellSource = [MAYCollectionViewCellSource sourceWithIdentifier:@"cell"];
    cellSource.data = @"hello miner";
    [cellSource setTarget:self configSelector:@selector(__configCustomCell:cellSource:)];
    [cellSource setTarget:self actionSelector:@selector(__performAction:cellSource:)];
    [dataSource addCellSource:@[cellSource]];

    [dataSource attachTableView:_tableView];
}

- (void)__configCustomCell:(UITableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
    cell.textLabel.text = cellSource.data;
}

- (void)__performAction:(UITableViewCell *)cell cellSource:(MAYCollectionViewCellSource *)cellSource {
    NSLog(@"%@", cellSource.data);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"interceptedTableViewDelegate scrollViewWillBeginDragging");
}

@end
