//
//  VideoPlayViewController.m
//  App
//
//  Created by 张丁豪 on 16/9/7.
//  Copyright © 2016年 张丁豪. All rights reserved.
//


#import "VideoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayViewController ()

// 视频
@property (strong, nonatomic) UIView *movieView;

@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,assign) BOOL isCollect;
@property(nonatomic,strong) UIView *ControlView;
@property(nonatomic,strong) UIButton *CollectButton;
@property(nonatomic,assign) BOOL isPause;
@property(nonatomic,strong) UIButton *pauseButton;
@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UILabel *startTimeLabel;
@property(nonatomic,strong) UIButton *volumeDownbutton;
@property(nonatomic,strong) UISlider *timeSlider;
@property(nonatomic,strong) UIButton *uploadButton;
@property(nonatomic,strong) UIButton *volumeUpbutton;
@property(nonatomic,strong) UIButton *HDButton;
@property(nonatomic,strong) UILabel *allTimeLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIProgressView *progress;
//@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) CGFloat currentTime;
@property(nonatomic,strong) AVPlayerLayer *playerLayer;
// 进度
@property(nonatomic,strong) UIProgressView *buffer;
@property(nonatomic,strong) UIWebView *lodingGif;

//@property(nonatomic,strong) UIView *adView;
/** 缓冲进度条 */
@property(nonatomic,strong) UIView *bufferView;
/** playItem时间刻度 */
@property(nonatomic,assign) int timeScale;
// 时间后台
@property(nonatomic,strong) id obj;
// 自动布局用的字典
@property(nonatomic,strong) NSDictionary *views;

@end

@implementation VideoPlayViewController

#pragma mark - 懒加载
-(UIProgressView *)buffer{
    if (_buffer == nil) {
        _buffer = [[UIProgressView alloc]init];
        _buffer.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        _buffer.trackTintColor = [UIColor clearColor];
        [self.ControlView insertSubview:_buffer belowSubview:_timeSlider];
        _buffer.translatesAutoresizingMaskIntoConstraints = NO;
        self.views = NSDictionaryOfVariableBindings(_buffer);
        [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_buffer]-50-|" options:0 metrics:nil views:_views]];
        [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_buffer(2.0)]-16-|" options:0 metrics:nil views:_views]];
    }
    return _buffer;
}

// 暂停
- (void)stopPlay{
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateActive ) {
        
        [_player play];
    }
    else{
        [_player pause];
    }
}

// 播放
- (void)play{
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateActive ) {
        
        [_player play];
    }
    else{
        [_player pause];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlay) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(play) name:@"stop" object:nil];

    self.movieView = [[UIView alloc]initWithFrame:self.view.bounds];
    _movieView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_movieView];
    
    // 网络
    NSURL *playURl = [NSURL URLWithString:self.UrlString];
    AVAsset *asset = [AVAsset assetWithURL:playURl];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    _player = [AVPlayer playerWithPlayerItem:item];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_movieView.layer addSublayer:_playerLayer];
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听属性
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self setUpControllView];
    _ControlView.hidden = 1;
    _isCollect = 0;
}

- (void)setUpControllView{
    
    self.ControlView = [[UIView alloc]init];
    _player.volume = 2;
    _ControlView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    [self.view addSubview:_ControlView];
    
    // 播放进度条
    self.timeSlider = [[UISlider alloc] init];
    UIImage *imaga = [UIImage imageNamed:@"player_handle"];
    [_timeSlider setThumbImage:imaga forState:UIControlStateNormal];
    _timeSlider.minimumTrackTintColor = [UIColor whiteColor];
    _timeSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    _timeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [_timeSlider addTarget:self action:@selector(changeProgress:)forControlEvents:UIControlEventValueChanged];
    _timeSlider.maximumValue = _duration;
    [_ControlView addSubview:_buffer];
    [_ControlView addSubview:_timeSlider];
    [_timeSlider release];
    
    // 开始时间
    self.startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.text = @"00:00";
    _startTimeLabel.textColor = [UIColor whiteColor];
    _startTimeLabel.font = [UIFont systemFontOfSize:12];
    [_ControlView addSubview:_startTimeLabel];
    _startTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_startTimeLabel release];
    
    // 总时间
    self.allTimeLabel = [[UILabel alloc] init];
    _allTimeLabel.text = @"00:00";
    _allTimeLabel.textColor = [UIColor whiteColor];
    _allTimeLabel.font = [UIFont systemFontOfSize:12];
    [_ControlView addSubview:_allTimeLabel];
    _allTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_allTimeLabel release];
    
    // 返回button
    self.backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(20, 0, 350,50);
    [_backButton addTarget:self action:@selector(BackButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ControlView addSubview:_backButton];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_back_normal"]];
    image.frame = CGRectMake(0, 10, 20, 20);
    [_backButton addSubview:image];
    [_backButton release];
    
    // VideoTitle
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(20, 10, 400, 20);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = _titleStr;
    [_backButton addSubview:_titleLabel];
    [_titleLabel release];
    
    // 音量+
    self.volumeUpbutton = [[UIButton alloc] init];
    _volumeUpbutton.frame = CGRectMake(23, 90, 18, 18);
    [_volumeUpbutton setImage:[UIImage imageNamed:@"V+"] forState:UIControlStateNormal];
    [_ControlView addSubview:_volumeUpbutton];
    [_volumeUpbutton addTarget:self action:@selector(volumeUp:) forControlEvents:UIControlEventTouchUpInside];
    [_volumeUpbutton release];
    
    // 声音进度条
    self.progress = [[UIProgressView alloc]initWithProgressViewStyle: UIProgressViewStyleBar];
    _progress.backgroundColor = [UIColor grayColor];
    _progress.progressTintColor = [UIColor whiteColor];
    _progress.progress = 0.2;
    _progress.frame = CGRectMake(-26, 175, 110, 15);
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI/2 * 3);
    _progress.transform = trans;
    [_ControlView addSubview:_progress];
    [_progress release];
    
    // 音量-
    self.volumeDownbutton = [[UIButton alloc] init];
    _volumeDownbutton.frame = CGRectMake(24, 242, 18, 18);
    [_volumeDownbutton setImage:[UIImage imageNamed:@"V-0"] forState:UIControlStateNormal];
    [_ControlView addSubview:_volumeDownbutton];
    [_volumeDownbutton addTarget:self action:@selector(volumeDown:) forControlEvents:UIControlEventTouchUpInside];
    [_volumeUpbutton release];
    
//    // 收藏Button
//    self.CollectButton = [[UIButton alloc] init];
//    [_CollectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
//    [_CollectButton addTarget:self action:@selector(collectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//    _CollectButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_ControlView addSubview:_CollectButton];
//    [_CollectButton release];
//    
//    // 上传Button
//    self.uploadButton = [[UIButton alloc] init];
//    [_uploadButton setImage:[UIImage imageNamed:@"上传"] forState:UIControlStateNormal];
//    _uploadButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_ControlView addSubview:_uploadButton];
//    [_uploadButton release];
//    
//    // HDButton
//    self.HDButton = [[UIButton alloc]init];
//    [_HDButton setImage:[UIImage imageNamed:@"btn_HD_normal"] forState:UIControlStateNormal];
//    _HDButton.translatesAutoresizingMaskIntoConstraints = NO;
//    _HDButton.backgroundColor = [UIColor colorWithWhite:5 alpha:0.3];
//    _HDButton.layer.cornerRadius = 5;
//    _HDButton.userInteractionEnabled = NO;
//    [_ControlView addSubview:_HDButton];
//    [_HDButton release];
    
    // 暂停button
    self.pauseButton = [[UIButton alloc] init];
    [_pauseButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
    _pauseButton.frame = CGRectMake(SCREEN_HEIGHT/2-22, SCREEN_WIDTH/2-22, 44, 44);
    [_pauseButton addTarget:self action:@selector(pauseButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ControlView addSubview:_pauseButton];
    [_pauseButton release];
    
    // 自动布局用的字典
    self.views = NSDictionaryOfVariableBindings(_timeSlider,_startTimeLabel,_allTimeLabel);
//    ,_CollectButton,_uploadButton,_HDButton
    // 纯代码自动布局
    // _timeSlider
    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_timeSlider]-50-|" options:0 metrics:nil views:_views]];
    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeSlider(15.0)]-10-|" options:0 metrics:nil views:_views]];
    // startTimeLabel
    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_startTimeLabel]" options:0 metrics:nil views:_views]];
    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_startTimeLabel(15.0)]-10-|" options:0 metrics:nil views:_views]];
    // _allTimeLabel
    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_allTimeLabel]-5-|" options:0 metrics:nil views:_views]];
    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_allTimeLabel(15.0)]-10-|" options:0 metrics:nil views:_views]];
//    // collectButton
//    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_CollectButton(20.0)]-90-|" options:0 metrics:nil views:_views]];
//    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_CollectButton(20.0)]" options:0 metrics:nil views:_views]];
//    // _uploadButton
//    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_uploadButton(20.0)]-60-|" options:0 metrics:nil views:_views]];
//    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_uploadButton(20.0)]" options:0 metrics:nil views:_views]];
//    // HDButton
//    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_HDButton(20.0)]-30-|" options:0 metrics:nil views:_views]];
//    [_ControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_HDButton(20.0)]" options:0 metrics:nil views:_views]];
    
    // 在控件层加手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    // 需要手指的个数
    tapGR.numberOfTouchesRequired = 1;
    [_ControlView addGestureRecognizer:tapGR];
    // 在视频层加手势
    UITapGestureRecognizer *movietapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movietapGRAction:)];
    movietapGR.numberOfTouchesRequired = 1;
    [_movieView addGestureRecognizer:movietapGR];
    
    //初始化控件
    _allTimeLabel.text = [self getTtime:_duration ];
}

// 在控件层加手势
- (void)tapGRAction:(UITapGestureRecognizer *)sender{
    
    _ControlView.hidden = 1;
//    _shadeView.hidden = 1;
}

// 在视频层加手势
- (void)movietapGRAction:(UITapGestureRecognizer *)sender{
    _ControlView.hidden = 0;
//    _shadeView.hidden = 0;
}

// 收藏button点击事件
- (void)collectButtonDidClicked:(UIButton *)sender{
    [sender setShowsTouchWhenHighlighted:1];
    if (!_isCollect) {
        [_CollectButton setBackgroundImage:[UIImage imageNamed:@"collectSelete"] forState:UIControlStateNormal];
        _isCollect = 1;
    }else{
        [_CollectButton setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        _isCollect = 0;
    }
}

// 返回Button点击事件
- (void)BackButtonDidClicked:(UIButton *)sender{
    [_player pause];
    [_player setRate:0];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [_player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 音量加
- (void)volumeUp:(UIButton *)sender{
    [sender setShowsTouchWhenHighlighted:1];
    if(_player.volume < 5){
        _player.volume += 0.5;
        
    }else{
        _player.volume += 0.4;
    }
    _progress.progress = _player.volume/10;
}

// 声音减
- (void)volumeDown:(UIButton *)sender{
    [sender setShowsTouchWhenHighlighted:1];
    if (_player.volume < 5) {
        _player.volume -= 0.4;
    }else{
        _player.volume -= 0.5;
    }
    _progress.progress = _player.volume/10;
}

// 暂停点击
- (void)pauseButtonDidClicked:(UIButton *)sender{
    [sender setShowsTouchWhenHighlighted:1];
    if (!_isPause) {
        [_pauseButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_player pause];
//        _adView.hidden = 0;
        _isPause = 1;
    }else{
        [_pauseButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        [_player play];
//        self.adView.hidden = 1;
        _isPause = 0;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refondContr:) userInfo:nil repeats:NO];
        [UIView animateWithDuration:2 animations:^{
            [self refondContr];
        } completion:nil];
    }
}

// 收回控制器
- (void)refondContr{
    _ControlView.hidden = 1 ;
}

// timeSlider更新
//- (void)UpdateTimeSlider:(NSTimer *)sender{
//    
//}

// 监听player属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            if( [UIApplication sharedApplication].applicationState == UIApplicationStateActive ||  [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                [_player play];
            }
            else {
                [_player pause];
            }
            _ControlView.hidden = 1;
            [self monitoringPlayback:_player.currentItem];
            
            self.timeScale = playerItem.currentTime.timescale;
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;
        
        float bufferProgress = (float)result / _player.currentItem.duration.value * self.player.currentItem.duration.timescale;
        self.buffer.progress = bufferProgress;
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    ///破坏怪圈  甲里引用乙，乙里引用甲，就会导致 “retain cycle” -- “形成怪圈”的错误
    __block VideoPlayViewController *blockSelf = self;
    _obj = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time)
            {
                CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;
                _currentTime = currentSecond;
                double t = CMTimeGetSeconds(blockSelf.player.currentTime);
                //                   blockSelf.timeSlider.value = _currentTime/_receiveModel.duration;
                blockSelf.timeSlider.value = t;
                
                blockSelf. startTimeLabel.text = [blockSelf getTtime:blockSelf.currentTime];
            }];
    if (_obj) {
        return;
    }
    
}

// timeSlider绑定事件
- (void)changeProgress:(UISlider *)sender{
    
    [_player pause];
    CMTime cmtime = CMTimeMakeWithSeconds(sender.value, self.player.currentTime.timescale);
    
    [_player seekToTime:cmtime completionHandler:^(BOOL finished) {
        
        if (finished) {
            [_player play];
            [_pauseButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
            [_player play];
//            _adView.hidden = 1;
            _isPause = 0;
        }
    }];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(NSString *)getTtime:(NSInteger)time {
    NSInteger min;
    NSInteger sec;
    min = time / 60;
    sec = time % 60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld",min,sec];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [_player pause];
//    [_player setRate:0];
//    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
//    [_player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
//    [_player replaceCurrentItemWithPlayerItem:nil];
//    [_timer invalidate];
//    _timer = nil;
//    _player = nil;
//    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(remove:) userInfo:nil repeats:NO];
//    _timer = time;
//}

//- (void)remove:(NSTimer *)sender{
//    [_timer invalidate];
//    _timer = nil;
//}

@end
