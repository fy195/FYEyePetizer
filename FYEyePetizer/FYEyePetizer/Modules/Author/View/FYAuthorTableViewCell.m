//
//  FYAuthorTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYAuthorTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface FYAuthorTableViewCell ()
@property (nonatomic, retain) UIImageView *authorImageView;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subTitleLabel;
@property (nonatomic, retain) UILabel *desLabel;
@property (nonatomic, retain) UIButton *button;
@end

@implementation FYAuthorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.authorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_authorImageView];
        _authorImageView.clipsToBounds = YES;
        _authorImageView.layer.cornerRadius = 20.0f;
        _authorImageView.backgroundColor = [UIColor clearColor];
        [_authorImageView release];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_backView];
        _backView.backgroundColor = [UIColor clearColor];
        [_backView release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
        [_titleLabel release];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_subTitleLabel];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        [_subTitleLabel release];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_desLabel];
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.font = [UIFont fontWithName:@"Thonburi" size:14];
        [_desLabel release];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@">" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_backView addSubview:_button];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_authorImageView.mas_right).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(20);
        make.height.equalTo(@40);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(0);
        make.left.equalTo(_backView).offset(0);
    }];
    _titleLabel.numberOfLines = 1;
    [_titleLabel sizeToFit];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(20);
        make.bottom.equalTo(_titleLabel.mas_bottom);
    }];
    _subTitleLabel.numberOfLines = 1;
    [_subTitleLabel sizeToFit];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView).offset(0);
        make.left.equalTo(_backView).offset(0);
        make.right.equalTo(_backView).offset(-25);
        make.height.equalTo(@20);
    }];
    _desLabel.numberOfLines = 1;
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backView).offset(0);
        make.centerY.equalTo(_backView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
}

- (void)setIcon:(NSString *)icon {
    if (_icon != icon) {
        [_icon release];
        _icon = [icon retain];
    }
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:icon]];
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = _title;
}

- (void)setSubTitle:(NSString *)subTitle {
    if (_subTitle != subTitle) {
        [_subTitle release];
        _subTitle = [subTitle copy];
    }
    _subTitleLabel.text = _subTitle;
}

- (void)setAuthorDescription:(NSString *)authorDescription {
    if (_authorDescription != authorDescription) {
        [_authorDescription release];
        _authorDescription = [authorDescription copy];
    }
    _desLabel.text = _authorDescription;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
