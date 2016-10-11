//
//  FYVideoCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYVideoDetailCollectionViewCell.h"
#import "UIImage+Categories.h"

@interface FYVideoDetailCollectionViewCell ()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *playImage;
@end

@implementation FYVideoDetailCollectionViewCell

- (void)dealloc {
    [_videoImageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
        [self.contentView addSubview:_scrollView];
        [_scrollView release];
        
        
        self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_videoImageView];
        [_videoImageView release];
        
        self.playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"播放"]];
        _playImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_playImage];
        [_playImage release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_playImage addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)setVideoImage:(UIImage *)videoImage {
    if (_videoImage != videoImage) {
        [_videoImage release];
        _videoImage = [videoImage retain];
    }
    _videoImageView.image = videoImage;
}

- (void)setIndex:(NSInteger)index {
    if (_index != index) {
        _index = index;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.delegate getIndex:_index];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
    _videoImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
    _playImage.frame = CGRectMake(0, 0, 50, 50);
    _playImage.center = _videoImageView.center;
}

@end
