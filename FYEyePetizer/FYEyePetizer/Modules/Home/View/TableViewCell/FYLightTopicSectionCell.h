//
//  FYLightTopicSectionCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYHomeItemData;

@protocol FYLightTopicHeaderDelegate <NSObject>

@required
- (void)getIdFromTouchImage:(NSNumber *)imageId;
@end

@interface FYLightTopicSectionCell : UITableViewCell

@property (nonatomic, retain) UIImage *topicImage;
@property (nonatomic, retain) FYHomeItemData *itemData;
@property (nonatomic, assign) id<FYLightTopicHeaderDelegate>tapDelegate;
@end
