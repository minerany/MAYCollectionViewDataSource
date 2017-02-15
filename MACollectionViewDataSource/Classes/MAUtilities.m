//
//  MAUtilities.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MAUtilities.h"

void PerformSelectorWithTarget(id target, SEL aSelector, id object1, id object2) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:aSelector withObject:object1 withObject:object2];
#pragma clang diagnostic pop
}

@implementation MAWeakObjectWrapper

- (instancetype)initWithWeakObject:(id)weakObject {
    self = [super init];
    if (self) {
        _weakObject = weakObject;
    }
    return self;
}

@end

