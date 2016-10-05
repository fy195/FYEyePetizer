//
//  FYHomeTags.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHomeTags.h"

@implementation FYHomeTags

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.tagId = value;
        return;
    }
    [super setValue:value forUndefinedKey:key];
}

@end
