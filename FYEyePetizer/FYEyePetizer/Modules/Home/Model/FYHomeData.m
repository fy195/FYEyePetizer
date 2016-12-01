//
//  FYHomeData.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHomeData.h"
#import "FYHomeSectionList.h"

@implementation FYHomeData

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"sectionList"]) {
        NSArray *dicArray = value;
        NSMutableArray *listArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FYHomeSectionList *list = [FYHomeSectionList modelWithDic:dic];
            [listArray addObject:list];
        }
        self.sectionList = listArray;
        return;
    }
    [super setValue:value forKey:key];
}

@end
