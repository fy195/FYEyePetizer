//
//  FYFooterTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/3.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYFooterTableViewCell.h"

@interface FYFooterTableViewCell ()

@property (nonatomic, retain) UILabel *label;

@end

@implementation FYFooterTableViewCell

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _label.font = [UIFont fontWithName:@"Thonburi" size:13];
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        [_label release];
    }
    return  self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        [_text release];
        _text = [text copy];
    }
    _label.text = text;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
