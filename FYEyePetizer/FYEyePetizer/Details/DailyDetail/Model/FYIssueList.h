//
//  FYIssueList.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYIssueList : FYBaseModel
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSNumber *releaseTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSNumber *date;
@property (nonatomic, retain) NSNumber *publishTime;
@end
