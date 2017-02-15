//
//  SecondViewController.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/15.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "SecondViewController.h"
#import "MACollectionViewDataSource+UITableView.h"

@implementation MACollectionViewDataSourceManager {
    NSMutableArray *_array;
}

+ (instancetype)defaultManager {
    static MACollectionViewDataSourceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MACollectionViewDataSourceManager new];
    });
    return manager;
}

- (void)addDataSource:(MACollectionViewDataSource *)dataSource {
    [_array addObject:dataSource];
}

- (void)removeDataSource:(MACollectionViewDataSource *)dataSource {
    [_array removeObject:dataSource];
}

@end

@interface SecondViewController () <UITableViewDelegate>

@end

@implementation SecondViewController {
    UITableView *_tableView;

}

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];


    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    MACollectionViewDataSource *dataSource = [[MACollectionViewDataSource alloc] initWithTableView:_tableView interceptedTableViewDelegate:self];
    MACollectionViewCellSource *cellSource = [MACollectionViewCellSource sourceWithIdentifier:@"cell"];
    cellSource.configTableViewCellBlock = ^(__kindof UITableViewCell *cell, __kindof MACollectionViewCellSource *source) {
        cell.textLabel.text = @"hello miner";
    };
    __weak typeof(self) weakSelf = self;
    cellSource.performTableViewCellActionBlock = ^(__kindof UITableViewCell *cell, __kindof MACollectionViewCellSource *source) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [dataSource addCellSource:@[cellSource]];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"interceptedTableViewDelegate scrollViewWillBeginDragging");
}

@end
