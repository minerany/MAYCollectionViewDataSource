//
//  MACollectionViewItemSource.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

@import UIKit;

@interface MACollectionViewItemSource : NSObject

@property(nonatomic, copy, readonly) NSString *identifier;

+ (instancetype)sourceWithIdentifier:(NSString *)identifier;

@end

@interface MACollectionViewCellSource : MACollectionViewItemSource

@end

@interface MACollectionViewHeaderSource : MACollectionViewItemSource

@end

@interface MACollectionViewFooterSource : MACollectionViewItemSource

@end
