//
//  MAUtilities.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAUtilities.h"

@implementation _MAAssociatedObjectsWeakWrapper

- (instancetype)initWithWeakObject:(id)weakObject {
    self = [super init];
    if (self) {
        _weakObject = weakObject;
    }
    return self;
}

@end
