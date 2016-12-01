//
//  FYBannerTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBannerTableViewCell.h"

@interface FYBannerTableViewCell ()

@property (nonatomic, retain) UIImageView *bannerImageView;

@end

@implementation FYBannerTableViewCell

- (void)dealloc {
    [_bannerImageView release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_bannerImageView];
        [_bannerImageView release];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _bannerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        [_image release];
        _image = [image retain];
    }
    _bannerImageView.image = image;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
