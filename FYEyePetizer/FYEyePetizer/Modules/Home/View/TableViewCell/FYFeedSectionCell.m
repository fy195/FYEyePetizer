//
//  FYFeedSectionCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYFeedSectionCell.h"

@interface FYFeedSectionCell ()

@property (nonatomic, retain) UIImageView *myImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *tagLabel;

@end

@implementation FYFeedSectionCell
- (void)dealloc {
    [_myImageView release];
    [_titleLabel release];
    [_tagLabel release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        [self addSubview:_myImageView];
        [_myImageView release];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        [_myImageView addSubview:_backView];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [_backView release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
        [_titleLabel release];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_tagLabel];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        [_tagLabel release];
        
    }
    return  self;
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        [_image release];
        _image = [image retain];
    }
    _myImageView.image = image;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = title;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        [_text release];
        _text = [text copy];
    }
    _tagLabel.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _myImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    _backView.frame = _myImageView.bounds;
    _titleLabel.numberOfLines = 1;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(SCREEN_WIDTH / 2, _backView.height / 2 - _titleLabel.height / 2 - 5);
    _tagLabel.numberOfLines = 1;
    [_tagLabel sizeToFit];
    _tagLabel.center = CGPointMake(SCREEN_WIDTH / 2, _backView.height / 2 + _tagLabel.height / 2 + 5);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
