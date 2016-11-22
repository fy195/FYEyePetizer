//
//  FYVideoCollectionTableViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYHomeItemData.h"

@protocol FYVideoTableViewCellDelegate <NSObject>
@required
- (void)getPgcId:(NSNumber *)pgcId actionUrl: (NSString *)actionUrl;
- (void)getVideoArray:(NSArray *)videoArray index:(NSInteger)index;
@end
@interface FYVideoCollectionTableViewCell : UITableViewCell

@property (nonatomic, retain) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *authorDescription;
@property (nonatomic, retain) FYHomeItemData *data;
@property (nonatomic, assign) id<FYVideoTableViewCellDelegate>delegate;

@end
