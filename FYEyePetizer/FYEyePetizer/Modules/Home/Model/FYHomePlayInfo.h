//
//  FYHomePlayInfo.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYHomePlayInfo : FYBaseModel

@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;

@end
