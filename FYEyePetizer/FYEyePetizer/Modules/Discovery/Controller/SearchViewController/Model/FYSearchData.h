//
//  FYSearchData.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/13.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYSearchData : FYBaseModel
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *total;
@property (nonatomic, retain) NSString *nextPageUrl;
@end
