//
//  FYHomeItemData.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/1.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseModel.h"

@interface FYHomeItemData : FYBaseModel

@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, retain) NSNumber *dataId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dataDescription;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL shade;
@property (nonatomic, retain) NSDictionary *provider;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, retain) NSDictionary *cover;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSDictionary *webUrl;
@property (nonatomic, retain) NSNumber *releaseTime;
@property (nonatomic, copy) NSMutableArray *playInfo;
@property (nonatomic, retain) NSDictionary *consumption;
@property (nonatomic, copy) NSMutableArray *tags;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSNumber *idx;
@property (nonatomic, retain) NSNumber *date;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, retain) NSDictionary *header;
@property (nonatomic, copy) NSMutableArray *itemList;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *font;
@property (nonatomic, copy) NSString *actionUrl;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *subTitle;

@end
