//
//  FYTagSectionData.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"
@class FYHomeTags;

@interface FYTagSectionData : FYBaseModel
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *total;
@property (nonatomic, retain) NSString *nextPageUrl;
@property (nonatomic, retain) FYHomeTags *tag;
@end
