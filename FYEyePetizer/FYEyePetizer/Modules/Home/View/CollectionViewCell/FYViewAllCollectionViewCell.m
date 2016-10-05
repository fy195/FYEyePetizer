//
//  FYViewAllCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/3.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYViewAllCollectionViewCell.h"

@interface FYViewAllCollectionViewCell ()

@property (nonatomic, retain) UILabel *label;

@end

@implementation FYViewAllCollectionViewCell

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor colorWithRed:1.000 green:0.990 blue:0.980 alpha:0.8];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont fontWithName:@"Thonburi" size:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.borderWidth = 5.0f;
        _label.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8].CGColor;
        [self addSubview:_label];
        [_label release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(5, 5, self.width - 10, 170);
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        [_text release];
        _text = [text copy];
    }
    _label.text = text;
}

@end
