//
//  FYChannelCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/13.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYChannelCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface FYChannelCollectionViewCell ()
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *backView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *tagLabel;
@property (nonatomic, retain) UILabel *briefLabel;
@property (nonatomic, retain) UIView *blackView;
@end

@implementation FYChannelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 背景
        self.backView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backView];
        [_backView release];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = _backView.bounds;
        [_backView addSubview:visualView];
        [blurEffect release];
        [visualView release];
        
        // 亮图
        self.imageView = [[UIImageView alloc] init];
        [_backView addSubview:_imageView];
        [_imageView release];
        
        self.blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_backView addSubview:_blackView];
        [_blackView release];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_blackView addSubview:_titleLabel];
        [_titleLabel release];
        
        self.tagLabel = [[UILabel alloc] init];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.textColor = [UIColor clearColor];
        _tagLabel.font = [UIFont fontWithName:@"Thonburi" size:15];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [_blackView addSubview:_tagLabel];
        [_tagLabel release];
        
        self.briefLabel = [[UILabel alloc] init];
        _briefLabel.backgroundColor = [UIColor clearColor];
        _briefLabel.textColor = [UIColor clearColor];
        _briefLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        _briefLabel.numberOfLines = 4;
        [_backView addSubview:_briefLabel];
        [_briefLabel release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backView.frame = CGRectMake(30, 0, SCREEN_WIDTH - 60, self.height);
    _imageView.frame = CGRectMake(0, 0, _backView.width, _backView.height - 100);
    _blackView.frame = _imageView.bounds;
    _titleLabel.frame = CGRectMake(0, _blackView.y + _blackView.height / 2, _blackView.width, 30);
    _tagLabel.frame = CGRectMake(0, _titleLabel.y + _titleLabel.height + 20, _blackView.width, 30);
    _briefLabel.frame = CGRectMake(0, _blackView.y + _blackView.height, _imageView.width, _backView.height - _imageView.height);
}

- (void)setChannelImage:(NSString *)channelImage {
    if (_channelImage != channelImage) {
        [_channelImage release];
        _channelImage = [channelImage retain];
    }
    [_backView sd_setImageWithURL:[NSURL URLWithString:channelImage]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:channelImage]];
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = _title;
}

- (void)setTimeTag:(NSString *)timeTag {
    if (_timeTag != timeTag) {
        [_timeTag release];
        _timeTag = [timeTag copy];
    }
    _tagLabel.text = timeTag;
}

- (void)setBrief:(NSString *)brief {
    if (_brief != brief) {
        [_brief release];
        _brief = [_brief copy];
    }
    _briefLabel.text = brief;
}

@end
