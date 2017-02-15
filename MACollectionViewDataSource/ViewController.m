//
//  ViewController.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "MACollectionViewDataSource+UITableView.h"

@interface ViewController ()<UITableViewDelegate>

@end

@implementation ViewController
//{
//    UITableView *_tableView;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    
//    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    [self.view addSubview:_tableView];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    
//    
//    MACollectionViewDataSource *dataSource =  [[MACollectionViewDataSource alloc] initWithTableView:_tableView interceptedTableViewDelegate:self];
//    MACollectionViewCellSource *cellSource = [MACollectionViewCellSource sourceWithIdentifier:@"cell"];
//    cellSource.configTableViewCellBlock = ^(__kindof UITableViewCell *cell,__kindof MACollectionViewCellSource *source){
//        cell.textLabel.text = @"hello miner";
//    };
//    [dataSource addCellSource:@[cellSource]];
//    
//    
//}
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"interceptedTableViewDelegate scrollViewWillBeginDragging");
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SecondViewController *viewController = [SecondViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
