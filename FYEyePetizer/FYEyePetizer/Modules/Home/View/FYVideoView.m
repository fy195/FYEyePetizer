//
//  FYVideoView.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/11.
//  Copyright © 2016年 dllo. All rights reserved.
//
static NSString *const videoDetailCell= @"collectionViewCell";
#import "FYVideoView.h"
#import "UIButton+Block.h"
#import "FYVideoDetailCollectionViewCell.h"
#import "FYHomeItemData.h"
#import "FYHomeItemList.h"
#import "NSString+FYTime.h"
#import "UIImageView+WebCache.h"
#import "FYPlayViewController.h"

#import "FYPopAnimation.h"


@interface FYVideoView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIImageView *downBackImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *tagLabel;
@property (nonatomic, retain) UILabel *briefLabel;
@property (nonatomic, retain) UILabel *likeLabel;
@property (nonatomic, retain) UILabel *shareLabel;
@property (nonatomic, retain) UILabel *commentLabel;
@property (nonatomic, assign) CGFloat beginX;
@property (nonatomic, retain) UIPercentDrivenInteractiveTransition *interaction;
@end

@implementation FYVideoView
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20, 40, 20, 20);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"箭头2下"] forState:UIControlStateNormal];
        [self addSubview:_backButton];
        [_backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            self.hidden = YES;
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
        [self addSubview:_videoCollectionView];
        [_videoCollectionView release];
        [_videoCollectionView registerClass:[FYVideoDetailCollectionViewCell class] forCellWithReuseIdentifier:videoDetailCell];
        [self bringSubviewToFront:_backButton];
        
//        [_videoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_videoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.appearCell = [_videoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_videoIndex inSection:0]];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//        [_videoCollectionView addGestureRecognizer:pan];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        [_videoCollectionView addGestureRecognizer:tap];
//        [tap release];

    }
    return self;
}

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    return _interaction;
//}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGFloat progress = [pan translationInView:pan.view].y / CGRectGetHeight(pan.view.frame);
    if (progress > 0) {
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:{
                
                break;
            }
            case UIGestureRecognizerStateChanged:{
                [_interaction updateInteractiveTransition:progress];
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                if (progress > 0.5) {
                    [_interaction finishInteractiveTransition];
                }else {
                    [_interaction cancelInteractiveTransition];
                }
                break;
            }
            default:
                break;
        }
    }
    
    
}

- (void)createDownView {
    // 下部分背景图
    if (_downBackImageView == nil) {
        //        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.45, SCREEN_WIDTH, SCREEN_HEIGHT * 0.55)];
        //        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.55);
        //        [self.view addSubview:_scrollView];
        //        [_scrollView release];
        
        self.downBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.45, SCREEN_WIDTH, SCREEN_HEIGHT * 0.55)];
        [self addSubview:_downBackImageView];
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
            make.width.equalTo(@30);
            make.height.equalTo(@20);
        }];
        [_likeLabel release];
        
        UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上传"]];
        [_backView addSubview:shareImageView];
        [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_likeLabel.mas_right).offset(50);
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
            make.width.equalTo(@30);
            make.height.equalTo(@20);
        }];
        [_shareLabel release];
        
        UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"评论"]];
        [_backView addSubview:commentImageView];
        [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_shareLabel.mas_right).offset(50);
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
            make.width.equalTo(@30);
            make.height.equalTo(@20);
        }];
        [_commentLabel release];
        
        UIImageView *downLoadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下载"]];
        [_backView addSubview:downLoadImageView];
        [downLoadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentLabel.mas_right).offset(50);
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
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    FYPlayViewController *playViewController = [[FYPlayViewController alloc] init];
    //    playViewController.modalTransitionStyle = 2;
    //    playViewController.playArray = [_videoArray mutableCopy];
    //    playViewController.index = indexPath.item;
    //    [self.navigationController pushViewController:playViewController animated:YES];
    //    [playViewController release];
    FYHomeItemList *itemList = _videoArray[indexPath.item];
    FYHomeItemData *itemData = itemList.data;
    [self.delegate getVideoFromPlayUrl:itemData.playUrl];
    NSLog(@"哈哈哈哈哈哈哈");
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
        
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
    [_videoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_videoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
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
    
    //    // 视图跟随
    if (offsetX <= 0) {
        CGRect rect = _downBackImageView.frame;
        rect.origin.x = -offsetX;
        _downBackImageView.frame = rect;
    }else if (offsetX >= (_videoArray.count - 1) * SCREEN_WIDTH) {
        CGRect rect = _downBackImageView.frame;
        rect.origin.x = (_videoArray.count - 1) * SCREEN_WIDTH - offsetX;
        _downBackImageView.frame = rect;
    }else {
        _downBackImageView.frame = CGRectMake(0, SCREEN_HEIGHT * 0.45, SCREEN_WIDTH, SCREEN_HEIGHT * 0.55);
    }
    
    //    if (page + 1 < _videoArray.count) {
    //        FYHomeItemList *itemList = _videoArray[page];
    //        FYHomeItemData *itemData = itemList.data;
    //        [_downBackImageView sd_setImageWithURL:[NSURL URLWithString:[itemData.cover objectForKey:@"detail"]] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.cover objectForKey:@"blurred"]]]]];
    //    }
    //    if (page > 0 ) {
    //        FYHomeItemList *itemList = _videoArray[page];
    //        FYHomeItemData *itemData = itemList.data;
    //        [_downBackImageView sd_setImageWithURL:[NSURL URLWithString:[itemData.cover objectForKey:@"detail"]] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.cover objectForKey:@"blurred"]]]]];
    //    }
    
    
    //    // 向右划
    //    UIImageView *aView = (UIImageView *)[self.view viewWithTag:1000];
    //    UIImageView *aView1 = (UIImageView *)[self.view viewWithTag:1001];
    //
    //    if (scrollView.contentOffset.x > SCREEN_WIDTH * _videoIndex) {
    //        if (offsetX != 0) {
    //            aView.alpha = 1 - (scrollView.contentOffset.x - SCREEN_WIDTH * _videoIndex) / SCREEN_WIDTH;
    //            _downBackImageView.alpha = aView.alpha;
    //            aView1.alpha = 1;
    //        }
    //    }else if(scrollView.contentOffset.x < SCREEN_WIDTH * _videoIndex){
    //        aView.alpha = 1 - (SCREEN_WIDTH * _videoIndex - scrollView.contentOffset.x) / SCREEN_WIDTH;
    //        _downBackImageView.alpha = aView.alpha;
    //        aView1.alpha = 0;
    //    }
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
    
    //    UIImageView *aView = (UIImageView *)[self.view viewWithTag:1000];
    //    UIImageView *aView1 = (UIImageView *)[self.view viewWithTag:1001];
    //    UIImageView *aView2 = (UIImageView *)[self.view viewWithTag:1002];
    //
    //    if (scrollView.contentOffset.x > SCREEN_WIDTH * _videoIndex) {
    //        aView.image = aView1.image;
    //    }else if(scrollView.contentOffset.x < SCREEN_WIDTH * _videoIndex){
    //        aView.image = aView2.image;
    //    }
    //    aView.alpha = 1;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
