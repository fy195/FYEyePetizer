//
//  FYCategoryData.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYCategoryData.h"
#import "FYHomeItemList.h"

@implementation FYCategoryData
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
@end
