//
//  FYHomeSectionList.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHomeSectionList.h"
#import "FYHomeItemList.h"

@implementation FYHomeSectionList

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"itemList"]) {
        NSArray *dicArray = value;
        NSMutableArray *itemListArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FYHomeItemList *list = [FYHomeItemList modelWithDic:dic];
            [itemListArray addObject:list];
        }
        self.itemList = itemListArray;
        return;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.sectionId = value;
        return;
    }
    [super setValue:value forUndefinedKey:key];
}

@end
