//
//  BH_AVPlayerView.h
//  BH_AVPlayer
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Ma Baihui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BH_AVPlayerStyle) {
    
    BH_PlayerStatusReadyToPlay,
    BH_PlayerStatusFailed,
    BH_PlayerStatusUnknown,
    BH_PlayerStatusPlayEnd,
    
};

@class BH_AVPlayerView;

@protocol BH_AVPlayerViewDelegate <NSObject>

/** 播放器状态改变 */
- (void)BH_AVPlayerView:(BH_AVPlayerView *)playerView ReloadStatuesChanged:(BH_AVPlayerStyle)BH_PlayerStyle;

/** 播放时间进度改变 */
- (void)BH_AVPlayerView:(BH_AVPlayerView *)playerView CurrentPlayTimeChanged:(Float64)currentPlayTime;

@end


@interface BH_AVPlayerView : UIView
/**<#注释#>*/
@property (nonatomic, assign) id<BH_AVPlayerViewDelegate> delegate;

/**播放链接*/
@property (nonatomic, retain) NSURL *playerUrl;
/**当前播放时间*/
@property (nonatomic, assign) Float64 currentPlayTime;
/**总时长*/
@property (nonatomic, assign) Float64 totalDuration;
/**可用时间*/
@property (nonatomic, assign) Float64 timeInterval;
/**<#注释#>*/
@property (nonatomic, assign) BOOL isShowBottomProgressView;
@property (nonatomic, assign) BOOL isShowTopView;
/**<#注释#>*/
@property (nonatomic, assign) BOOL isShowResumViewAtPlayEnd;

/**播放状态*/
- (BOOL)isPlaying;

/**播放*/
- (void)play;

/**暂停*/
- (void)pause;

/**继续*/
- (void)resume;

/**结束*/
- (void)stop;

/**拉动进度条*/
- (void)seekToTime:(CGFloat)seekTime;

/**播放时间 00:00:00*/
- (NSString *)convertTimeToString:(CGFloat)second;

@end
