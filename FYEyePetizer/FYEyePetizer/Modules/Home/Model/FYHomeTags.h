//
//  FYHomeTags.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYHomeTags : FYBaseModel

@property (nonatomic, retain) NSNumber *tagId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *actionUrl;

@end
