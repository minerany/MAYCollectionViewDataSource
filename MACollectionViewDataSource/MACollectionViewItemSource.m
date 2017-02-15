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

- (void)setTarget:(id)target configSelector:(SEL)configSelector {
    _configTarget = target;
    _configSelector = configSelector;
}

@end

@implementation MACollectionViewCellSource

- (void)setTarget:(id)target actionSelector:(SEL)action {
    _actionTarget = target;
    _actionSelector = action;
}

@end

@implementation MACollectionViewHeaderSource

@end

@implementation MACollectionViewFooterSource

@end
