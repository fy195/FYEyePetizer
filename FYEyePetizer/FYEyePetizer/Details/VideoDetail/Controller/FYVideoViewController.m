//
//  FYVideoViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 dllo. All rights reserved.
//
static NSString *const videoDetailCell= @"collectionViewCell";
#import "FYVideoViewController.h"
#import "UIButton+Block.h"
#import "FYVideoDetailCollectionViewCell.h"
#import "FYHomeItemData.h"
#import "FYHomeItemList.h"
#import "NSString+FYTime.h"
#import "UIImageView+WebCache.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FYVideoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate,
UINavigationControllerDelegate,
FYVideoViewDelegate
>
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *tagLabel;
@property (nonatomic, retain) UILabel *briefLabel;
@property (nonatomic, retain) UILabel *likeLabel;
@property (nonatomic, retain) UILabel *shareLabel;
@property (nonatomic, retain) UILabel *commentLabel;
@property (nonatomic, assign) CGFloat beginX;

@end

@implementation FYVideoViewController
- (void)dealloc {
    [_videoCollectionView release];
    [_downBackImageView release];
    [_backView release];
    [_titleLabel release];
    [_tagLabel release];
    [_briefLabel release];
    [_likeLabel release];
    [_shareLabel release];
    [_commentLabel release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backButton.frame = CGRectMake(20, 40, 20, 20);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"箭头2下"] forState:UIControlStateNormal];
    [self.view addSubview:_backButton];
    [_backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45) collectionViewLayout:flowLayout];
    _videoCollectionView.backgroundColor = [UIColor whiteColor];
    _videoCollectionView.pagingEnabled = YES;
    _videoCollectionView.delegate = self;
    _videoCollectionView.dataSource = self;
    _videoCollectionView.bounces = NO;
    _videoCollectionView.allowsSelection = NO;
    [self.view addSubview:_videoCollectionView];
    [_videoCollectionView release];
    [_videoCollectionView registerClass:[FYVideoDetailCollectionViewCell class] forCellWithReuseIdentifier:videoDetailCell];
    [self.view bringSubviewToFront:_backButton];
    
    [_videoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_videoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)createDownView {
    // 下部分背景图
    if (_downBackImageView == nil) {
        self.downBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.45, SCREEN_WIDTH, SCREEN_HEIGHT * 0.55)];
        [self.view addSubview:_downBackImageView];
        [_downBackImageView release];
    
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        
        visualView.frame = _downBackImageView.bounds;
        
        [_downBackImageView addSubview:visualView];

    }
    if (_backView == nil) {
        self.backView = [[UIView alloc] initWithFrame:_downBackImageView.bounds];
        _backView.backgroundColor = [UIColor clearColor];
        [_downBackImageView addSubview:_backView];
        [_backView release];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:20];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView).offset(20);
            make.left.equalTo(_backView).offset(20);
            make.width.equalTo(@(SCREEN_WIDTH - 40));
            make.height.equalTo(@30);
        }];
        [_titleLabel release];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        _tagLabel.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_tagLabel];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(20);
            make.left.equalTo(_backView).offset(20);
            make.width.equalTo(@(SCREEN_WIDTH - 40));
            make.height.equalTo(@20);
        }];
        [_tagLabel release];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor lightGrayColor];
        [_backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tagLabel.mas_bottom).offset(20);
            make.left.equalTo(_backView).offset(20);
            make.width.equalTo(@(SCREEN_WIDTH - 40));
            make.height.equalTo(@(1));
        }];
        [view release];
        
        self.briefLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _briefLabel.textColor = [UIColor whiteColor];
        _briefLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        _briefLabel.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_briefLabel];
        [_briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).offset(20);
            make.left.equalTo(_backView).offset(20);
            make.width.equalTo(@(SCREEN_WIDTH - 40));
            make.height.equalTo(@(80));
        }];
        _briefLabel.numberOfLines = 0;
        [_briefLabel release];
        
        UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"收藏"]];
        [_backView addSubview:likeImageView];
        [likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView).offset(20);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [likeImageView release];
        
        self.likeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _likeLabel.textColor = [UIColor whiteColor];
        _likeLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        _likeLabel.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_likeLabel];
        [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(likeImageView.mas_right).offset(10);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        [_likeLabel release];
        
        UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上传"]];
        [_backView addSubview:shareImageView];
        [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_likeLabel.mas_right).offset(40);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [shareImageView release];
        
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shareLabel.textColor = [UIColor whiteColor];
        _shareLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        _shareLabel.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_shareLabel];
        [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shareImageView.mas_right).offset(10);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        [_shareLabel release];
        
        UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"评论"]];
        [_backView addSubview:commentImageView];
        [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_shareLabel.mas_right).offset(40);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [commentImageView release];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        _commentLabel.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_commentLabel];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentImageView.mas_right).offset(10);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        [_commentLabel release];
        
        UIImageView *downLoadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下载"]];
        [_backView addSubview:downLoadImageView];
        [downLoadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentLabel.mas_right).offset(40);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [downLoadImageView release];
        
        UILabel *downLoadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        downLoadLabel.textColor = [UIColor whiteColor];
        downLoadLabel.backgroundColor = [UIColor clearColor];
        downLoadLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        downLoadLabel.text = @"缓存";
        [_backView addSubview:downLoadLabel];
        [downLoadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(downLoadImageView.mas_right).offset(10);
            make.bottom.equalTo(_backView).offset(-50);
            make.width.equalTo(@30);
            make.height.equalTo(@20);
        }];
        [downLoadLabel release];
   
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _videoArray[indexPath.item];
    FYHomeItemData *itemData = itemList.data;
    FYVideoDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoDetailCell forIndexPath:indexPath];
    cell.videoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.cover objectForKey:@"detail"]]]];
    cell.index = indexPath.item;
    cell.delegate = self;
    return cell;
}

- (void)getIndex:(NSInteger)index {
    FYHomeItemList *itemList = _videoArray[index];
    FYHomeItemData *itemData = itemList.data;
    
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:itemData.playUrl]];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = player;
    playerVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self presentViewController:playerVC animated:YES completion:nil];
    [playerVC.player play];
}

- (void)setVideoArray:(NSMutableArray *)videoArray {
    if (_videoArray != videoArray) {
        [_videoArray release];
        _videoArray = [videoArray retain];
    }
    [_videoCollectionView reloadData];
}

- (void)setVideoIndex:(NSInteger)videoIndex {
    if (_videoIndex != videoIndex) {
        _videoIndex = videoIndex;
    }
    FYHomeItemList *itemList = _videoArray[videoIndex];
    FYHomeItemData *itemData = itemList.data;
    [self createDownView];
    [_downBackImageView sd_setImageWithURL:[NSURL URLWithString:[itemData.cover objectForKey:@"detail"]] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.cover objectForKey:@"blurred"]]]]];
    
    
    _titleLabel.text = itemData.title;
    NSString *timeString = [NSString stringChangeWithTimeFormat:itemData.duration];
    _tagLabel.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, timeString];
    _briefLabel.text = itemData.dataDescription;
    _likeLabel.text = [NSString stringWithFormat:@"%ld",[[itemData.consumption objectForKey:@"collectionCount"] integerValue]];
    _shareLabel.text = [NSString stringWithFormat:@"%ld",[[itemData.consumption objectForKey:@"shareCount"] integerValue]];
    _commentLabel.text = [NSString stringWithFormat:@"%ld",[[itemData.consumption objectForKey:@"replyCount"] integerValue]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / SCREEN_WIDTH;
    if (offsetX > 0 && offsetX <= scrollView.contentSize.width - SCREEN_WIDTH) {
        NSIndexPath *currentIndex = [NSIndexPath indexPathForItem:page inSection:0];
        NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:page + 1 inSection:0];

        FYVideoDetailCollectionViewCell *currentCell = (FYVideoDetailCollectionViewCell *)[self.videoCollectionView cellForItemAtIndexPath:currentIndex];
        FYVideoDetailCollectionViewCell *nextCell = (FYVideoDetailCollectionViewCell *)[self.videoCollectionView cellForItemAtIndexPath:nextIndex];

        CGRect currentImageViewRect = currentCell.videoImageView.frame;
        CGRect nextImageViewRect = nextCell.videoImageView.frame;

        currentImageViewRect.origin.x = (offsetX - currentIndex.item * SCREEN_WIDTH) / 3;
        nextImageViewRect.origin.x = - SCREEN_WIDTH / 3 + (offsetX - currentIndex.item * SCREEN_WIDTH) / 3;

        currentCell.videoImageView.frame = currentImageViewRect;
        nextCell.videoImageView.frame = nextImageViewRect;
    }
    
    CGFloat alpha;
    if (_beginX < scrollView.contentOffset.x) {
        alpha = 1 - offsetX / (SCREEN_WIDTH * (page + 1)) * 1.0;
        _backView.alpha = alpha;
    }else {
        alpha = (offsetX - SCREEN_WIDTH *page) / SCREEN_WIDTH * 1.0f;
        _backView.alpha = alpha;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _backView.alpha = 1.0f;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / SCREEN_WIDTH;
    FYHomeItemList *itemList = _videoArray[page];
    FYHomeItemData *itemData = itemList.data;
    
    _downBackImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.cover objectForKey:@"detail"]]]];
    _titleLabel.text = itemData.title;
    NSString *timeString = [NSString stringChangeWithTimeFormat:itemData.duration];
    _tagLabel.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, timeString];
    _briefLabel.text = itemData.dataDescription;
    _likeLabel.text = [NSString stringWithFormat:@"%ld",[[itemData.consumption objectForKey:@"collectionCount"] integerValue]];
    _shareLabel.text = [NSString stringWithFormat:@"%ld",[[itemData.consumption objectForKey:@"shareCount"] integerValue]];
    _commentLabel.text = [NSString stringWithFormat:@"%ld",[[itemData.consumption objectForKey:@"replyCount"] integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
