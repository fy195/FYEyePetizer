//
//  FYVideoCollectionViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYVideoCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) NSString *coverImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cellTag;
@end
