//
//  FYHorizontalCardCollectionViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYHomeItemData;

@protocol FYHonrizontalCellDelegate <NSObject>

@required
- (void) getBannerId:(NSNumber *)bannerId actionUrl: (NSString *)actionUrl;
@end

@interface FYHorizontalCardCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) FYHomeItemData *data;
@property (nonatomic, assign) id<FYHonrizontalCellDelegate>delegate;
@end
