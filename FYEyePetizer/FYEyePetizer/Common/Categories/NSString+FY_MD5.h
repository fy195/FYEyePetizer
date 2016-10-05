//
//  NSString+FY_MD5.h
//  UI23_加密
//
//  Created by dllo on 16/9/9.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FY_MD5)

- (NSString *)fy_stringByMD5Bit32;

- (NSString *)fy_stringByMD5Bit32Uppercase;

- (NSString *)fy_stringByMD5Bit16;

- (NSString *)fy_stringByMD5Bit16Uppercase;

@end
