//
//  FYCatogeryCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/3.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYCatogeryCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface FYCatogeryCollectionViewCell ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *tagLabel;

@end

@implementation FYCatogeryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        [_imageView release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:20];
        [self addSubview:_titleLabel];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagLabel.textColor = [UIColor lightGrayColor];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont fontWithName:@"Thonburi" size:17];
        [self addSubview:_tagLabel];

    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.width, 200);
    _titleLabel.frame = CGRectMake(5, _imageView.y + _imageView.height + 20, self.width - 5, 20);
    _tagLabel.frame = CGRectMake(10, _titleLabel.y + _titleLabel.height + 5, self.width - 10, 20);
}

- (void)setImage:(NSString *)image {
    if (_image != image) {
        [_image release];
        _image = [image retain];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:image]];
}

- (void)setItemTitle:(NSString *)itemTitle {
    if (_itemTitle != itemTitle) {
        [_itemTitle release];
        _itemTitle = [itemTitle copy];
    }
    _titleLabel.text = itemTitle;
}

- (void)setItemTag:(NSString *)itemTag {
    if (_itemTag != itemTag) {
        [_itemTag release];
        _itemTag = [itemTag copy];
    }
    _tagLabel.text = itemTag;
}


@end
