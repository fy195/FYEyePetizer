//
//  FYTitleTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYTitleTableViewCell.h"

@interface FYTitleTableViewCell ()
@property (nonatomic, retain) UILabel *LeftAlignLabel;
@end

@implementation FYTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.LeftAlignLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_LeftAlignLabel];
        _LeftAlignLabel.textColor = [UIColor blackColor];
        _LeftAlignLabel.font = [UIFont fontWithName:@"Thonburi" size:15];
        [_LeftAlignLabel release];

    }
    return self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        [_text release];
        _text = [text copy];
    }
    _LeftAlignLabel.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _LeftAlignLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH, self.height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
