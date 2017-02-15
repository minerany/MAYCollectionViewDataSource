//
//  MACollectionViewProxy.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MACollectionViewProxy : NSProxy

+ (instancetype)proxyWithDelegates:(NSArray *)delegates;

@end
