//
//  SecondViewController.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/15.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MACollectionViewDataSource;

@interface SecondViewController : UIViewController

@end

@interface MACollectionViewDataSourceManager : NSObject

+ (instancetype)defaultManager;

- (void)addDataSource:(MACollectionViewDataSource *)dataSource;

- (void)removeDataSource:(MACollectionViewDataSource *)dataSource;

@end
