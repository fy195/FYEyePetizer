//
//  FYHomeItemData.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHomeItemData.h"
#import "FYHomePlayInfo.h"
#import "FYHomeTags.h"
#import "FYHomeItemList.h"

@implementation FYHomeItemData

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"playInfo"]) {
        NSArray *dicArray = value;
        NSMutableArray *playInfoArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FYHomePlayInfo *playInfo = [FYHomePlayInfo modelWithDic:dic];
            [playInfoArray addObject:playInfo];
        }
        self.playInfo = playInfoArray;
        return;
    }
    if ([key isEqualToString:@"tags"]) {
        NSArray *dicArray = value;
        NSMutableArray *tagsArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FYHomeTags *tag = [FYHomeTags modelWithDic:dic];
            [tagsArray addObject:tag];
        }
        self.tags = tagsArray;
        return;
    }
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
        self.dataId = value;
        return;
    }
    if ([key isEqualToString:@"description"]) {
        self.dataDescription = value;
        return;
    }
    [super setValue:value forUndefinedKey:key];
}

@end
