//
//  FYVideoView.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/11.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYVideoViewDelegate <NSObject>

- (void)getVideoFromPlayUrl:(NSString *)playUrl;

@end

@interface FYVideoView : UIView

@property (nonatomic, retain) NSMutableArray *videoArray;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, retain) UICollectionViewCell *appearCell;
@property (nonatomic, retain) UICollectionView *videoCollectionView;
@property (nonatomic, assign) id<FYVideoViewDelegate>delegate;
@end
