//
//  FYLightTopicSectionCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYHomeItemData;
@class FYHomeSectionList;

@protocol FYLightTopicHeaderDelegate <NSObject>

@required
- (void)getInfoFromTouchImage:(NSNumber *)imageId sectionListType:(NSString *)type actionUrl:(NSString *)actionUrl;
- (void)getArrayFromCell:(NSArray *)videoArray;
- (void)getCurrentImageId:(NSNumber *)imageId actionUrl:(NSString *)actionUrl;
@end

@interface FYLightTopicSectionCell : UITableViewCell

@property (nonatomic, retain) UIImage *topicImage;
@property (nonatomic, retain) FYHomeSectionList *sectionList;
@property (nonatomic, retain) FYHomeItemData *itemData;
@property (nonatomic, assign) id<FYLightTopicHeaderDelegate>tapDelegate;
@end
