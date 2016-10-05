//
//  FYTopicCollectionViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYTopicCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) UIImage *coverImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cellTag;

@end
