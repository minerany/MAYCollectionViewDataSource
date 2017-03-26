//
//  MAYCollectionViewItemSource.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

@import UIKit;

#define _DeclareSelector(signature, itemClass, param1, itemSourceClass, param2)\
-(void)signature:(itemClass)param1 param2:(itemSourceClass)param2

#define MAYDeclareConfigCellSelector(signature, cellClass, cellSourceClass) _DeclareSelector(signature,cellClass,cell,cellSourceClass,cellSource);
#define MAYDeclareCellActionSelector(signature, cellClass, cellSourceClass) _DeclareSelector(signature,cellClass,cell,cellSourceClass,cellSource);
#define MAYDeclareConfigHeaderFooterSelector(signature, headerFooterClass, headerFooterSourceClass) _DeclareSelector(signature,headerFooterClass,headerFooterView,headerFooterSourceClass,headerFooterSource);

@interface MAYCollectionViewItemSource : NSObject

@property(nonatomic, copy, readonly) NSString *identifier;

+ (instancetype)sourceWithIdentifier:(NSString *)identifier;

@property(nonatomic, strong) id data;

@property(nonatomic, weak, readonly) id configTarget;
@property(nonatomic, assign, readonly) SEL configSelector;

- (void)setTarget:(id)target configSelector:(SEL)configSelector;

@end

@interface MAYCollectionViewCellSource : MAYCollectionViewItemSource

@property(nonatomic, weak, readonly) id actionTarget;
@property(nonatomic, assign, readonly) SEL actionSelector;

- (void)setTarget:(id)target actionSelector:(SEL)action;

@end

@interface MAYCollectionViewHeaderSource : MAYCollectionViewItemSource

@end

@interface MAYCollectionViewFooterSource : MAYCollectionViewItemSource

@end
