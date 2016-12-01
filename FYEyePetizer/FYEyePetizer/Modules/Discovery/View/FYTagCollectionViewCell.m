//
//  FYTagCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYTagCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface FYTagCollectionViewCell ()
@property (nonatomic, retain) UIImageView *tagImageView;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) UILabel *label;
@end

@implementation FYTagCollectionViewCell

- (void)dealloc {
    [_tagImageView release];
    [_view release];
    [_label release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagImageView];
        [_tagImageView release];
        
        self.view = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_view];
        _view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [_view release];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_label];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
        [_label release];
    }
    return self;
}

- (void)setImage:(NSString *)image {
    if (_image != image) {
        [_image release];
        _image = [image retain];
    }
    [_tagImageView sd_setImageWithURL:[NSURL URLWithString:image]];
}

- (void)setItemTag:(NSString *)itemTag {
    if (_itemTag != itemTag) {
        [_itemTag release];
        _itemTag = [itemTag copy];
    }
    _label.text = itemTag;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tagImageView.frame = self.bounds;
    _view.frame = self.bounds;
    _label.frame = self.bounds;
}
@end
