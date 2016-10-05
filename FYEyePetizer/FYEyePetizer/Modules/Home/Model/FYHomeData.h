//
//  FYHomeData.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYHomeData : FYBaseModel

@property (nonatomic, retain) NSNumber *date;
@property (nonatomic, retain) NSNumber *nextPublishTime;
@property (nonatomic, copy) NSMutableArray *sectionList;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, copy) NSString *nextPageUrl;

@end
