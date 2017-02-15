//
//  MACollectionViewItemSource.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MACollectionViewItemSource.h"

@implementation MACollectionViewItemSource

+ (instancetype)sourceWithIdentifier:(NSString *)identifier {
    MACollectionViewItemSource *source = [[self class] new];
    source->_identifier = identifier;
    return source;
}

@end

@implementation MACollectionViewCellSource

@end

@implementation MACollectionViewHeaderSource

@end

@implementation MACollectionViewFooterSource

@end
