//
//  BH_PlayProgressView.h
//  BH_AVPlayer
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Ma Baihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BH_PlayProgressView : UIView

/**播放/暂停*/
@property (nonatomic, retain) UIButton *playBtn;
/**全屏/半屏*/
@property (nonatomic, retain) UIButton *fullBtn;
/**进度条*/
@property (nonatomic, retain) UISlider *progressSlider;
/**当前时间*/
@property (nonatomic, retain) UILabel *currentTimeLabel;
/**总时长*/
@property (nonatomic, retain) UILabel *totalDurationLabel;
/**进度指示器*/
@property (nonatomic, retain) UIProgressView *timeIntervalProgress;

@end
