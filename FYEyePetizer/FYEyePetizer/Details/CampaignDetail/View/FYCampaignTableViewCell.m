//
//  FYCampaignTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYCampaignTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface FYCampaignTableViewCell ()
@property (nonatomic, retain) UIImageView *campaignImageView;
@end

@implementation FYCampaignTableViewCell
- (void)dealloc {
    [_campaignImageView release];
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.campaignImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_campaignImageView];
        [_campaignImageView release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _campaignImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
}

- (void)setCampaignImage:(NSString *)campaignImage {
    if (_campaignImage != campaignImage) {
        [_campaignImage release];
        _campaignImage = [campaignImage retain];
    }
    [_campaignImageView sd_setImageWithURL:[NSURL URLWithString:campaignImage]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
