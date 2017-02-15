//
//  ExampleViewController.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/15.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "ExampleViewController.h"
#import "MACollectionViewDataSource+UITableView.h"

@interface ExampleViewController () <UITableViewDelegate>

DECL_CONFIG_SEL(__configCustomCell, UITableViewCell *, MACollectionViewCellSource*)

DECL_ACTION_SEL(__performAction, UITableViewCell *, MACollectionViewCellSource*)

@end

@implementation ExampleViewController {
    UITableView *_tableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    MACollectionViewDataSource *dataSource = [[MACollectionViewDataSource alloc] initWithTableView:_tableView interceptedTableViewDelegate:self];
    MACollectionViewCellSource *cellSource = [MACollectionViewCellSource sourceWithIdentifier:@"cell"];
    [cellSource setTarget:self configSelector:@selector(__configCustomCell:cellSource:)];
    [cellSource setTarget:self actionSelector:@selector(__performAction:cellSource:)];
    [dataSource addCellSource:@[cellSource]];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)__configCustomCell:(UITableViewCell *)cell cellSource:(MACollectionViewCellSource *)cellSource {
    cell.textLabel.text = @"hello miner";
}

- (void)__performAction:(UITableViewCell *)cell cellSource:(MACollectionViewCellSource *)cellSource {
    
    NSLog(@"__performAction");
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"interceptedTableViewDelegate scrollViewWillBeginDragging");
}

@end
