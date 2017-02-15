//
//  MAUtilities.h
//  MACollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define MASynthesize(ownership, type, getter, setter) \
static const void *_MASynthesizeKey_##getter = &_MASynthesizeKey_##getter; \
- (type)getter \
{ \
return _MASynthesize_get_##ownership(type, getter); \
} \
- (void)setter:(type)getter \
{ \
_MASynthesize_set_##ownership(type, getter); \
}

#define _MASynthesize_get_assign(type, getter) \
({ \
typeof(type) _ma_value[1] = {}; \
[(NSValue *)objc_getAssociatedObject(self, _MASynthesizeKey_##getter) getValue:_ma_value]; \
_ma_value[0]; \
})

#define _MASynthesize_get_strong(type, getter) \
objc_getAssociatedObject(self, _MASynthesizeKey_##getter);

#define _MASynthesize_get_copy      _MASynthesize_get_strong

#define _MASynthesize_get_weak(type, getter) \
((MAWeakObjectWrapper *)objc_getAssociatedObject(self, _MASynthesizeKey_##getter)).weakObject

#define _MASynthesize_set_assign(type, getter) \
objc_setAssociatedObject(self, \
_MASynthesizeKey_##getter, \
[[NSValue alloc] initWithBytes:&getter objCType:@encode(type)], \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#define _MASynthesize_set_strong(type, getter) \
objc_setAssociatedObject(self, \
_MASynthesizeKey_##getter, \
getter, \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#define _MASynthesize_set_copy(type, getter) \
objc_setAssociatedObject(self, \
_MASynthesizeKey_##getter, \
getter, \
OBJC_ASSOCIATION_COPY_NONATOMIC);

#define _MASynthesize_set_weak(type, getter) \
objc_setAssociatedObject(self, \
_MASynthesizeKey_##getter, \
[[MAWeakObjectWrapper alloc] initWithWeakObject:getter], \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@interface MAWeakObjectWrapper : NSObject

@property(nonatomic, weak, readonly) id weakObject;

- (instancetype)initWithWeakObject:(id)weakObject;

@end

void PerformSelectorWithTarget(id target, SEL aSelector, id object1, id object2);
