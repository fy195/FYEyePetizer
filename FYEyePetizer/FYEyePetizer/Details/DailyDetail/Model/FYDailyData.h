//
//  FYDailyData.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYDailyData : FYBaseModel
@property (nonatomic, retain) NSNumber *nextPublishTime;
@property (nonatomic, copy) NSMutableArray *issueList;
@property (nonatomic, copy) NSString *nextPageUrl;
@property (nonatomic, retain) NSString *newestIssueType;
@end
