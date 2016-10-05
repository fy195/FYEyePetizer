//
//  FYAuthorData.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYAuthorData.h"
#import "FYHomeItemList.h"

@implementation FYAuthorData
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"itemList"]) {
        NSArray *dicArray = value;
        NSMutableArray *listArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FYHomeItemList *list = [FYHomeItemList modelWithDic:dic];
            [listArray addObject:list];
        }
        self.itemList = listArray;
        return;
    }
    [super setValue:value forKey:key];

}
@end
