//
//  MAYCollectionViewProxy.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAYCollectionViewProxy : NSProxy

+ (instancetype)proxyWithDelegates:(NSArray *)delegates;

@end
