//
//  BH_AVPlayerView.m
//  BH_AVPlayer
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Ma Baihui. All rights reserved.
//

#import "BH_AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "BH_PlayProgressView.h"

#define Bottom_Height  (self.bounds.size.height * 0.18)

@interface BH_AVPlayerView ()
/**负责视频操作，例如播放，暂停，声音大小，跳到指定时间*/
@property (nonatomic, retain) AVPlayer *avPlayer;
/**负责视频的可视区域，视频的播放模式，注意是CALayer，不能接受触摸*/
@property (nonatomic, retain) AVPlayerLayer *avPlayerLayer;
/**表示AVPlayer播放的资源对象，可以监听其状态*/
@property (nonatomic, retain) AVPlayerItem *playerItem;
/**屏幕切换*/
@property (nonatomic, retain) BH_PlayProgressView *progressView;
/**<#注释#>*/
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
/**<#注释#>*/
@property (nonatomic, retain) UIButton *resumeBtn;
/**<#注释#>*/
@property (nonatomic, retain) UIView *superView;
/**<#注释#>*/
@property (nonatomic, assign) BOOL canEditProgressView;
/**<#注释#>*/
@property (nonatomic, assign) BOOL isDragSlider;

@property (nonatomic, retain) UIView *topView;

@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, retain) UILabel *titleLabel;

@end

@implementation BH_AVPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setVolum];
    }
    return self;
    
}

- (void)createTopView {
    if (!_topView) {
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _topView.backgroundColor = [UIColor redColor];
        _topView.userInteractionEnabled = YES;
        [self addSubview:_topView];
        [_topView release];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
        [_topView addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView.mas_centerY);
            make.left.equalTo(_topView).offset(20);
            make.height.equalTo(@40);
            make.width.equalTo(@40);
        }];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_topView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backButton.mas_right).offset(50);
            make.centerY.equalTo (_topView.mas_centerY);
            make.right.equalTo(_topView).offset (50);
            make.height.equalTo(@40);
        }];
    }
}

- (void)backAction: (UIButton *)button {
    [_avPlayer setRate:0.0f];
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]init];
        _activityView.bounds = self.bounds;
        _activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_activityView stopAnimating];
        _activityView.hidesWhenStopped = YES;
        _activityView.userInteractionEnabled = NO;
        [self addSubview:_activityView];
    }
    return _activityView;
    
}

- (BH_PlayProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[BH_PlayProgressView alloc] init];
        _progressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        // 播放状态(YES / NO)
        [_progressView.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 手动转屏(横屏 / 竖屏)
        [_progressView.fullBtn addTarget:self action:@selector(fullBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 接触 slider
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        // 滑动 slider 值改变, 并且赋给 currentTimeLabel
        [_progressView.progressSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // 取消滑动
        [_progressView.progressSlider addTarget:self action:@selector(sliderCancled:) forControlEvents:UIControlEventTouchCancel];
        // 滑动到某一位置
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        // 不能滑
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_progressView];
    }
    return _progressView;
    
}

- (UIButton *)resumeBtn {
    return _resumeBtn;
}

- (void)setVolum {
    self.clipsToBounds = YES;
    self.isShowTopView = YES;
    self.isShowBottomProgressView = YES;
    self.isShowResumViewAtPlayEnd = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarWillChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)setPlayerUrl:(NSURL *)playerUrl {
    if (playerUrl) {
        _playerUrl = playerUrl;
        if (_avPlayer) {
            [_avPlayer pause];
            [_avPlayerLayer removeFromSuperlayer];
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _totalDuration = 0.0f;// 总时长
            _timeInterval = 0.0f;// 时间间隔
            _currentPlayTime = 0.0f;// 当前播放时间
        }
        self.canEditProgressView = YES;// ProgressView 可编辑
        [self hiddenProgressView:NO];// 不隐藏
        _topView.hidden = NO;
        self.canEditProgressView = NO;// ProgressView 不可编辑
        [self.activityView startAnimating];// 开始
        _playerItem = [[AVPlayerItem alloc]initWithURL:playerUrl];
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
        _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        _avPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [(AVPlayerLayer *)self.layer addSublayer:_avPlayerLayer];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentTLCPlayerTime) object:nil];
        [self currentTLCPlayerTime];
        
        [self bringSubviewToFront:self.progressView];
        [self bringSubviewToFront:self.activityView];
        
    }
}

- (void)setIsShowBottomProgressView:(BOOL)isShowBottomProgressView {
    _isShowBottomProgressView = isShowBottomProgressView;
    self.progressView.hidden = !isShowBottomProgressView;
}

- (void)setIsShowTopView:(BOOL)isShowTopView {
    _isShowTopView = isShowTopView;
    _topView.hidden = !isShowTopView;
}

- (void)setIsShowResumViewAtPlayEnd:(BOOL)isShowResumViewAtPlayEnd {
    _isShowResumViewAtPlayEnd = isShowResumViewAtPlayEnd;
}

- (void)layoutSubviews {
    // 全屏 / 回复 重走此方法
    [super layoutSubviews];
    
    if (_avPlayerLayer) {
        _avPlayerLayer.frame = self.bounds;
    }
    CGRect frame = self.progressView.frame;
    CGRect frame1 = _topView.frame;
    self.topView.frame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, 50);
    self.progressView.frame = CGRectMake(frame.origin.x, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
    self.activityView.bounds = self.bounds;
    self.activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.resumeBtn.frame = self.bounds;
    
}

/** 播放 */
- (void)play {
    if (_avPlayer) {
        [_avPlayer play];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentTLCPlayerTime) object:nil];
        [self performSelector:@selector(currentTLCPlayerTime) withObject:nil afterDelay:0.5];
    }
}

/** 暂停 */
- (void)pause {
    if (_avPlayer) {
        [_avPlayer pause];
    }
}

- (void)stop {
    if (_avPlayer) {
        [_avPlayer setRate:0.0];
    }
}

/** 重新开始 */
- (void)resume {
    [self.avPlayer seekToTime:kCMTimeZero];
    if (self.avPlayer.rate == 0.0) {
        [self.avPlayer play];
    }
}

/** 播放状态 */
- (BOOL)isPlaying {
    if (self.avPlayer.rate == 0) {
        return NO;
    }
    return YES;
}

- (void)playBtnClicked:(UIButton *)sender {
    if (self.avPlayer.rate != 0) {
        [self pause];
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    } else {
        [self play];
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
}

- (void)resumeBtnClicked:(UIButton *)sender {
    [self resume];
    sender.hidden = YES;
}

- (void)sliderTouchDown:(UISlider *)sender {
    _isDragSlider = YES;
}
- (void)sliderValueChanged:(UISlider *)sender {
    _isDragSlider = YES;
    self.progressView.currentTimeLabel.text = [self convertTimeToString:self.progressView.progressSlider.value];
}
- (void)sliderCancled:(UISlider *)sender {
    _isDragSlider = NO;
}
- (void)sliderTouchInside:(UISlider *)sender {
    [self seekToTime:self.progressView.progressSlider.value];
    _isDragSlider = NO;
}
- (void)sliderTouchOutside:(UISlider *)sender {
    _isDragSlider = NO;
}

#pragma mark----屏幕手动旋转
- (void)fullBtnClicked:(UIButton *)sender {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }else if (orientation  == UIInterfaceOrientationLandscapeLeft) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }else if (orientation  == UIInterfaceOrientationPortraitUpsideDown) {
        
    }else if (orientation  == UIInterfaceOrientationLandscapeRight) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

/** 播放时间 00:00:00 */
- (NSString *)convertTimeToString:(CGFloat)second {
    NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *timeString = [formatter stringFromDate:pastDate];
    return timeString;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"PlayerStatusReadyToPlay");
            self.totalDuration = floorf(CMTimeGetSeconds(self.playerItem.duration));
            self.progressView.totalDurationLabel.text = [self convertTimeToString:self.totalDuration];
            self.progressView.progressSlider.maximumValue = self.totalDuration;
            self.progressView.progressSlider.minimumValue = 0;
            self.canEditProgressView = YES;
            [self showProgressView:NO];
            _topView.hidden = YES;
            [self.activityView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BH_AVPlayerView:ReloadStatuesChanged:)]) {
                [self.delegate BH_AVPlayerView:self ReloadStatuesChanged:BH_PlayerStatusReadyToPlay];
            }
        }else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"PlayerStatusFailed");
            [self.activityView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BH_AVPlayerView:ReloadStatuesChanged:)]) {
                [self.delegate BH_AVPlayerView:self ReloadStatuesChanged:BH_PlayerStatusFailed];
            }
        }else if ([playerItem status] == AVPlayerStatusUnknown){
            NSLog(@"PlayerStatusUnknown");
            [self.activityView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BH_AVPlayerView:ReloadStatuesChanged:)]) {
                [self.delegate BH_AVPlayerView:self ReloadStatuesChanged:BH_PlayerStatusUnknown];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        self.timeInterval = timeInterval;
        self.progressView.timeIntervalProgress.progress = self.timeInterval / self.totalDuration;
        NSLog(@"Time Interval:%f",timeInterval);
    }
}

- (void)currentTLCPlayerTime{
    self.currentPlayTime = floorf(CMTimeGetSeconds(self.playerItem.currentTime));
    if (self.currentPlayTime < 0) {
        self.currentPlayTime = 0.0;
    }
    if (self.avPlayer.rate != 0) {
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }else{
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }
    if (!_isDragSlider) {
        self.progressView.progressSlider.value = self.currentPlayTime;
        self.progressView.currentTimeLabel.text = [self convertTimeToString:self.currentPlayTime];
    }
    NSLog(@"current playTime:%f－－status:%ld",self.currentPlayTime,self.playerItem.status);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentTLCPlayerTime) object:nil];
    [self performSelector:@selector(currentTLCPlayerTime) withObject:nil afterDelay:0.5];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/** 拉动进度条 */
- (void)seekToTime:(CGFloat)seekTime{
    if (_avPlayer) {
        CMTime time = CMTimeMake(seekTime * self.playerItem.currentTime.timescale, self.playerItem.currentTime.timescale);
        [_avPlayer seekToTime:time];
    }
}
// 开始拉动进度条
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isShowBottomProgressView) {
        if ([self.progressView isHidden]) {
            [self showProgressView:YES];
            _topView.hidden = NO;
        }else{
            [self hiddenProgressView:YES];
            _topView.hidden = YES;
        }
    }
}


#pragma mark---bottom progress view
- (void)hiddenProgressView:(BOOL)animate{
    if (!_canEditProgressView) {
        return;
    }
    _canEditProgressView = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            _topView.frame = CGRectMake(0, -50, SCREEN_WIDTH, 50);
            self.progressView.frame = CGRectMake(0, self.bounds.size.height, self.progressView.bounds.size.width, self.progressView.bounds.size.height);
        } completion:^(BOOL finished) {
            _topView.hidden = YES;
            self.progressView.hidden = YES;
            self.canEditProgressView = YES;
        }];
    }else{
        _topView.hidden = YES;
        self.progressView.hidden = YES;
        self.canEditProgressView = YES;
        _topView.frame = CGRectMake(0, -50, SCREEN_WIDTH, 50);
        self.progressView.frame = CGRectMake(0, self.bounds.size.height, self.progressView.bounds.size.width, self.progressView.bounds.size.height);
    }
}

- (void)showProgressView:(BOOL)animate{
    if (!_canEditProgressView) {
        return;
    }
    _canEditProgressView = NO;
    self.progressView.hidden = NO;
    _topView.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            _topView.frame = CGRectMake(0, -50, SCREEN_WIDTH, 50);
            self.progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        } completion:^(BOOL finished) {
            self.canEditProgressView = YES;
        }];
    }else{
        _topView.frame = CGRectMake(0, -50, SCREEN_WIDTH, 50);
        self.progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        self.canEditProgressView = YES;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenProgressView:) object:self];
    [self performSelector:@selector(hiddenProgressView:) withObject:self afterDelay:3.0];
}

#pragma notification
- (void)playerPlayToEnd:(NSNotification *)notification{
    NSLog(@"play end");
    [self pause];
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    self.canEditProgressView = YES;
    [self hiddenProgressView:NO];
    self.resumeBtn.hidden = !_isShowResumViewAtPlayEnd;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BH_AVPlayerView:ReloadStatuesChanged:)]) {
        [self.delegate BH_AVPlayerView:self ReloadStatuesChanged:BH_PlayerStatusPlayEnd];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"播放结束" object:nil];
    
}

- (void)statusBarWillChanged:(NSNotification *)notification{
    NSLog(@"%ld",[UIApplication sharedApplication].statusBarOrientation);
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        if (self.superview != [UIApplication sharedApplication].keyWindow) {
            self.superView = self.superview;
        }
        if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        }
    }else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
            [self removeFromSuperview];
        }
        if (![self.superView.subviews containsObject:self]) {
            [self.superView addSubview:self];
        }
        self.frame = self.superView.bounds;
    }
}

- (void)applicationEnterbackground:(NSNotification *)notification{
    if ([self isPlaying]) {
        [self pause];
    }
}

- (void)dealloc{
    [self pause];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}


@end
