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
        self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_videoImageView];
        [_videoImageView release];
        
//        self.downBackImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self addSubview:_downBackImageView];
//        
//        [_downBackImageView release];
        
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//        [_downBackImageView addSubview:effectview];
//        effectview.frame = _downBackImageView.bounds;
//        [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_downBackImageView);
//        }];
//        [_downBackImageView layoutIfNeeded];
//
//        self.backView = [[UIView alloc] initWithFrame:CGRectZero];
//        _backView.backgroundColor = [UIColor clearColor];
//        [_downBackImageView addSubview:_backView];
//        [_backView release];
//        
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:20];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_titleLabel];
//        
//        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _tagLabel.textColor = [UIColor whiteColor];
//        _tagLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
//        _tagLabel.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_tagLabel];
//        [_tagLabel release];
//        
//        self.briefLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _briefLabel.textColor = [UIColor whiteColor];
//        _briefLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
//        _briefLabel.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_briefLabel];
//        _briefLabel.textAlignment = NSTextAlignmentLeft;
//        
//        self.likeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _likeLabel.textColor = [UIColor whiteColor];
//        _likeLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
//        _likeLabel.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_likeLabel];
//        [_likeLabel release];
//        
//        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _shareLabel.textColor = [UIColor whiteColor];
//        _shareLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
//        _shareLabel.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_shareLabel];
//        [_shareLabel release];
//        
//        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _commentLabel.textColor = [UIColor whiteColor];
//        _commentLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
//        _commentLabel.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:_commentLabel];
//        [_commentLabel release];
        
    }
    return self;
}

- (void)setVideoImage:(UIImage *)videoImage {
    if (_videoImage != videoImage) {
        [_videoImage release];
        _videoImage = [videoImage retain];
    }
    _videoImageView.image = videoImage;
//    _downBackImageView.image = videoImage;
}

//- (void)setBlurImage:(UIImage *)blurImage {
//    if (_blurImage != blurImage) {
//        [_blurImage release];
//        _blurImage = [blurImage retain];
//    }
//    _downBackImageView.image = blurImage;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    _videoImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
    
//    _downBackImageView.frame = CGRectMake(0, _videoImageView.y + _videoImageView.height, SCREEN_WIDTH, SCREEN_HEIGHT - _videoImageView.y - _videoImageView.height);
//
//    _backView.frame = _downBackImageView.bounds;
//    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_backView).offset(20);
//        make.left.equalTo(_backView).offset(20);
//        make.width.equalTo(@(SCREEN_WIDTH - 40));
//        make.height.equalTo(@30);
//    }];
//    
//    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
//        make.left.equalTo(_backView).offset(20);
//        make.width.equalTo(@(SCREEN_WIDTH - 40));
//        make.height.equalTo(@20);
//    }];
//    
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    view.backgroundColor = [UIColor lightGrayColor];
//    [_backView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_tagLabel.mas_bottom).offset(20);
//        make.left.equalTo(_backView).offset(20);
//        make.width.equalTo(@(SCREEN_WIDTH - 40));
//        make.height.equalTo(@(1));
//    }];
//    
//    [_briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_bottom).offset(20);
//        make.left.equalTo(_backView).offset(20);
//        make.width.equalTo(@(SCREEN_WIDTH - 40));
//        make.height.equalTo(@(80));
//    }];
//    _briefLabel.numberOfLines = 0;
//    
//    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"收藏"]];
//    [_backView addSubview:likeImageView];
//    [likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_backView).offset(20);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@20);
//        make.height.equalTo(@20);
//    }];
//    
//    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(likeImageView.mas_right).offset(10);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@30);
//        make.height.equalTo(@20);
//    }];
//    
//    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上传"]];
//    [_backView addSubview:shareImageView];
//    [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_likeLabel.mas_right).offset(50);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@20);
//        make.height.equalTo(@20);
//    }];
//    
//    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(shareImageView.mas_right).offset(10);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@30);
//        make.height.equalTo(@20);
//    }];
//    
//    UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"评论"]];
//    [_backView addSubview:commentImageView];
//    [commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_shareLabel.mas_right).offset(50);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@20);
//        make.height.equalTo(@20);
//    }];
//    
//    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(commentImageView.mas_right).offset(10);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@30);
//        make.height.equalTo(@20);
//    }];
//    
//    UIImageView *downLoadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下载"]];
//    [_backView addSubview:downLoadImageView];
//    [downLoadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_commentLabel.mas_right).offset(50);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@20);
//        make.height.equalTo(@20);
//    }];
//    
//    UILabel *downLoadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    downLoadLabel.textColor = [UIColor whiteColor];
//    downLoadLabel.backgroundColor = [UIColor clearColor];
//    downLoadLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
//    downLoadLabel.text = @"缓存";
//    [_backView addSubview:downLoadLabel];
//    [downLoadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(downLoadImageView.mas_right).offset(10);
//        make.bottom.equalTo(_backView).offset(-50);
//        make.width.equalTo(@30);
//        make.height.equalTo(@20);
//    }];
}

@end
