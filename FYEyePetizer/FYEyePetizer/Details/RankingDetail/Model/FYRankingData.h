//
//  FYRankingData.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYRankingData : FYBaseModel
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, copy) NSString *nextPageUrl;
@end
