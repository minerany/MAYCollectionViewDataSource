//
//  MAYUtilities.h
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/2/14.
//  Copyright © 2017年 miner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define MAYSynthesize(ownership, type, getter, setter) \
static const void *_MAYSynthesizeKey_##getter = &_MAYSynthesizeKey_##getter; \
- (type)getter \
{ \
return _MAYSynthesize_get_##ownership(type, getter); \
} \
- (void)setter:(type)getter \
{ \
_MAYSynthesize_set_##ownership(type, getter); \
}

#define _MAYSynthesize_get_assign(type, getter) \
({ \
typeof(type) _may_value[1] = {}; \
[(NSValue *)objc_getAssociatedObject(self, _MAYSynthesizeKey_##getter) getValue:_may_value]; \
_may_value[0]; \
})

#define _MAYSynthesize_get_strong(type, getter) \
objc_getAssociatedObject(self, _MAYSynthesizeKey_##getter);

#define _MAYSynthesize_get_copy      _MAYSynthesize_get_strong

#define _MAYSynthesize_get_weak(type, getter) \
((MAYWeakObjectWrapper *)objc_getAssociatedObject(self, _MAYSynthesizeKey_##getter)).weakObject

#define _MAYSynthesize_set_assign(type, getter) \
objc_setAssociatedObject(self, \
_MAYSynthesizeKey_##getter, \
[[NSValue alloc] initWithBytes:&getter objCType:@encode(type)], \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#define _MAYSynthesize_set_strong(type, getter) \
objc_setAssociatedObject(self, \
_MAYSynthesizeKey_##getter, \
getter, \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#define _MAYSynthesize_set_copy(type, getter) \
objc_setAssociatedObject(self, \
_MAYSynthesizeKey_##getter, \
getter, \
OBJC_ASSOCIATION_COPY_NONATOMIC);

#define _MAYSynthesize_set_weak(type, getter) \
objc_setAssociatedObject(self, \
_MAYSynthesizeKey_##getter, \
[[MAYWeakObjectWrapper alloc] initWithWeakObject:getter], \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@interface MAYWeakObjectWrapper : NSObject

@property(nonatomic, weak, readonly) id weakObject;

- (instancetype)initWithWeakObject:(id)weakObject;

@end

void PerformSelectorWithTarget(id target, SEL aSelector, id object1, id object2);
