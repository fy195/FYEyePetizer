//
//  FYVideoViewController.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseViewController.h"
#import "FYHomeItemData.h"
#import "FYVideoDetailCollectionViewCell.h"


@interface FYVideoViewController : FYBaseViewController
@property (nonatomic, retain) NSMutableArray *videoArray;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, retain) FYVideoDetailCollectionViewCell *appearCell;
@property (nonatomic, retain) UICollectionView *videoCollectionView;
@property (nonatomic, retain) UIImageView *downBackImageView;
@property (nonatomic, retain) UIView *backView;

@end
