//
//  FYAuthorSectionTableViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYHomeItemData;

@protocol FYAuthorCellDelegete <NSObject>

@required
- (void)getPgcId:(NSNumber *)pgcId;
- (void)getPgcArray:(NSArray *)videoArray;
@end

@interface FYAuthorSectionTableViewCell : UITableViewCell
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *authorDes;
@property (nonatomic, retain) UIImage *topicImage;
@property (nonatomic, retain) FYHomeItemData *itemData;
@property (nonatomic, assign) id<FYAuthorCellDelegete>authorDelegate;
@end
