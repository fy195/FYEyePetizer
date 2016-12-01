//
//  NSString+FYTime.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "NSString+FYTime.h"

@implementation NSString (FYTime)

+(NSString *)stringChangeWithTimeFormat:(NSNumber *)duration {
    NSInteger mer = [duration integerValue] / 60;
    NSInteger mod = [duration integerValue] % 60;
    NSString *min = @"";
    if (mer < 10) {
        min = [NSString stringWithFormat:@"0%ld", mer];
    }else {
        min = [NSString stringWithFormat:@"%ld", mer];
    }
    NSString *sec = @"";
    if (mod % 60 < 10) {
        sec = [NSString stringWithFormat:@"0%ld", mod];
    }else {
        sec = [NSString stringWithFormat:@"%ld", mod];
    }
    return [NSString stringWithFormat:@"%@'%@\"", min, sec];
}

@end
