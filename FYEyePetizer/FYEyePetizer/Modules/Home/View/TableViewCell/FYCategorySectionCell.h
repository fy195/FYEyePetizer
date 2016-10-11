//
//  FYCategorySectionCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYHomeItemData;

@protocol FYCategoryCellDelegate <NSObject>

@required
- (void)getCategoryId:(NSNumber *)categoryId;
- (void)getCategoryArray:(NSArray *)videoArray WithIndex:(NSInteger)index;

@end
@interface FYCategorySectionCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) FYHomeItemData *itemData;
@property (nonatomic, assign) id<FYCategoryCellDelegate>categoryDelegate;
@end
