//
//  FYHomeItemList.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
@implementation FYHomeItemList

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"data"]) {
        self.data = [FYHomeItemData modelWithDic:value];
        return;
    }
    [super setValue:value forKey:key];
}

@end
