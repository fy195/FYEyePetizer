//
//  FYTopicCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYTopicCollectionViewCell.h"

@interface FYTopicCollectionViewCell ()

@property (nonatomic, retain) UIImageView *cover;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *tagLabel;

@end
@implementation FYTopicCollectionViewCell

- (void)dealloc {
    [_cover release];
    [_titleLabel release];
    [_tagLabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cover = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_cover];
        [_cover release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:20];
        [self addSubview:_titleLabel];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagLabel.textColor = [UIColor lightGrayColor];
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        _tagLabel.font = [UIFont fontWithName:@"Thonburi" size:17];
        [self addSubview:_tagLabel];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cover.frame = CGRectMake(5, 5, self.width - 5, 170);
    _titleLabel.frame = CGRectMake(5, _cover.y + _cover.height + 5, self.width - 5, 20);
    _tagLabel.frame = CGRectMake(10, _titleLabel.y + _titleLabel.height + 5, self.width - 5, 20);
}

- (void)setCoverImage:(UIImage *)coverImage {
    if (_coverImage != coverImage) {
        [_coverImage release];
        _coverImage = [coverImage retain];
    }
    _cover.image = _coverImage;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = title;
}

- (void)setCellTag:(NSString *)cellTag {
    if (_cellTag != cellTag) {
        [_cellTag release];
        _cellTag = [cellTag copy];
    }
    _tagLabel.text = cellTag;
}

@end
