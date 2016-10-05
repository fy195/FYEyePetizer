//
//  FYHomeItemList.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"
@class FYHomeItemData;

@interface FYHomeItemList : FYBaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) FYHomeItemData *data;

@end
