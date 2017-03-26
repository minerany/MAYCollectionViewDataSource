//
//  UITableView+HeightCache.m
//  MAYCollectionViewDataSource
//
//  Created by miner on 2017/3/22.
//  Copyright © 2017年 miner. All rights reserved.
//

#import "UITableView+HeightCache.h"
#import "MAYUtilities.h"
#import "UIView+MAYDataSource.h"
#import <objc/runtime.h>
#import "MAYCellHeightCache.h"

@interface UITableView ()

@property(nonatomic, strong) NSMutableDictionary *cacheTemplateCell;

@end

@implementation UITableView (HeightCache)

MAYSynthesize(strong, NSMutableDictionary *, cacheTemplateCell, setCacheTemplateCell)

- (UITableViewCell *)may_dequeueReusableTemplateCellWithIdentifier:(NSString *)identifier {
    UITableViewCell *templateCell = self.cacheTemplateCell[identifier];
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithIdentifier:identifier];
        if (!self.cacheTemplateCell) {
            self.cacheTemplateCell = [NSMutableDictionary dictionary];
        }
        self.cacheTemplateCell[identifier] = templateCell;
    }
    return templateCell;
}

+ (void)load {
    SEL selectors[] = {
            @selector(reloadData),
            @selector(insertSections:withRowAnimation:),
            @selector(deleteSections:withRowAnimation:),
            @selector(reloadSections:withRowAnimation:),
            @selector(moveSection:toSection:),
            @selector(insertRowsAtIndexPaths:withRowAnimation:),
            @selector(deleteRowsAtIndexPaths:withRowAnimation:),
            @selector(reloadRowsAtIndexPaths:withRowAnimation:),
            @selector(moveRowAtIndexPath:toIndexPath:)
    };

    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); index++) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"may_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (MAYCellHeightCache *)__cellHeightCache {
    return self.may_dataSource.heightCache;
}

- (void)may_reloadData {
    [self.__cellHeightCache invalidateHeightCache];
    [self may_reloadData];
}

- (void)may_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self.__cellHeightCache insertSections:sections];
    [self may_insertSections:sections withRowAnimation:animation];
}

- (void)may_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self.__cellHeightCache deleteSections:sections];
    [self may_deleteSections:sections withRowAnimation:animation];
}

- (void)may_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self.__cellHeightCache[sections] reloadSections:sections];
    [self may_reloadSections:sections withRowAnimation:animation];
}

- (void)may_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [self.__cellHeightCache moveSection:section toSection:newSection];
    [self may_moveSection:section toSection:newSection];
}

- (void)may_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self.__cellHeightCache insertRowsAtIndexPaths:indexPaths];
    [self may_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)may_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self.__cellHeightCache deleteRowsAtIndexPaths:indexPaths];
    [self may_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)may_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self.__cellHeightCache reloadRowsAtIndexPaths:indexPaths];
    [self may_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)may_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self.__cellHeightCache moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self may_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

@end
