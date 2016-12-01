//
//  FYVideoCollectionViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYVideoViewDelegate <NSObject>

- (void)getIndex:(NSInteger)index;

@end

@interface FYVideoDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImageView *videoImageView;
@property (nonatomic, retain) NSString *videoImage;
@property (nonatomic, assign) id<FYVideoViewDelegate>delegate;

@end
