//
//  MAYCollectionViewItemSource.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAYCollectionViewItemSource.h"

@implementation MAYCollectionViewItemSource

+ (instancetype)sourceWithIdentifier:(NSString *)identifier {
    MAYCollectionViewItemSource *source = [[self class] new];
    source->_identifier = identifier;
    return source;
}

- (void)setTarget:(id)target configSelector:(SEL)configSelector {
    _configTarget = target;
    _configSelector = configSelector;
}

@end

@implementation MAYCollectionViewCellSource

- (void)setTarget:(id)target actionSelector:(SEL)action {
    _actionTarget = target;
    _actionSelector = action;
}

@end

@implementation MAYCollectionViewHeaderSource

@end

@implementation MAYCollectionViewFooterSource

@end
