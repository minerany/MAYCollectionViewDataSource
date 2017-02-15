//
//  MACollectionViewProxy.m
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "MACollectionViewProxy.h"

@implementation MACollectionViewProxy {
    NSPointerArray *_delegates;
}

+ (instancetype)proxyWithDelegates:(NSArray *)delegates {
    MACollectionViewProxy *proxy = [[MACollectionViewProxy alloc] initWithDelegates:delegates];
    return proxy;
}

- (instancetype)initWithDelegates:(NSArray *)delegates {
    if (self) {
        _delegates = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        [delegates enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [_delegates addPointer:(__bridge void *_Nullable) (obj)];
        }];
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return delegate;
        }
    }
    return nil;
}


@end
