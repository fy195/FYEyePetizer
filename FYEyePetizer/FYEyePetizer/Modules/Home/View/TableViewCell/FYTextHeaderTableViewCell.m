//
//  FYTextHeaderTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYTextHeaderTableViewCell.h"

@interface FYTextHeaderTableViewCell ()
@property (nonatomic, retain)UILabel *label;
@end

@implementation FYTextHeaderTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        _label.text = @"";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont fontWithName:@"Lobster 1.4" size:17];
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
