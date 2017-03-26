//
//  CustomTableViewCell.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/3/22.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 100);
    
}

-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, CGRectGetMaxY(self.textLabel.frame));
}

@end
