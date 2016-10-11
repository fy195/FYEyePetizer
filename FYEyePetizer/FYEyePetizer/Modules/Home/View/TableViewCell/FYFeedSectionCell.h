//
//  FYFeedSectionCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYFeedSectionCell : UITableViewCell

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIView *backView;

@end
