//
//  FYImageCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYImageCollectionViewCell.h"

@interface FYImageCollectionViewCell ()
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation FYImageCollectionViewCell

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        [_imageView release];
    }
    return  self;
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        [_image release];
        _image = [image retain];
    }
    _imageView.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
