//
//  FYDailyData.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYDailyData.h"
#import "FYIssueList.h"

@implementation FYDailyData
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"issueList"]) {
        NSArray *dicArray = value;
        NSMutableArray *listArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FYIssueList *list = [FYIssueList modelWithDic:dic];
            [listArray addObject:list];
        }
        self.issueList = listArray;
        return;
    }
    [super setValue:value forKey:key];
}
@end
