//
//  UITableView+HeightCache.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/3/22.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HeightCache)

- (UITableViewCell *)may_dequeueReusableTemplateCellWithIdentifier:(NSString *)identifier;

@end
