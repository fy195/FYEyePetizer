//
//  FYCellCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYCellCollectionViewCell.h"

@interface FYCellCollectionViewCell ()

@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation FYCellCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setCarouselImage:(UIImage *)carouselImage {
    if (_carouselImage != carouselImage) {
        _carouselImage = carouselImage;
        _imageView.image = carouselImage;
    }
}
@end
