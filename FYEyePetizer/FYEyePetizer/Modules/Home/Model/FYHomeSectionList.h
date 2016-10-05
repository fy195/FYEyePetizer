//
//  FYHomeSectionList.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYHomeSectionList : FYBaseModel

@property (nonatomic, retain) NSNumber *sectionId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSMutableArray *itemList;
@property (nonatomic, retain) NSDictionary *footer;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSDictionary *header;

@end
