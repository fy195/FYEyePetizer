//
//  FYVideoCollectionTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//
static NSString *const videoCell = @"videoCell";
#import "FYVideoCollectionTableViewCell.h"
#import "FYHomeItemList.h"
#import "FYVideoCollectionViewCell.h"
#import "NSString+FYTime.h"
#import "UIImageView+WebCache.h"

@interface FYVideoCollectionTableViewCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, retain) UIImageView *authorImageView;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subTitleLabel;
@property (nonatomic, retain) UILabel *desLabel;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UICollectionView *videoCollectionView;

@end

@implementation FYVideoCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.authorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_authorImageView];
        _authorImageView.clipsToBounds = YES;
        _authorImageView.layer.cornerRadius = 20.0f;
        _authorImageView.backgroundColor = [UIColor clearColor];
        [_authorImageView release];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_backView];
        _backView.backgroundColor = [UIColor clearColor];
        [_backView release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
        [_titleLabel release];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_subTitleLabel];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont fontWithName:@"Thonburi" size:13];
        [_subTitleLabel release];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_desLabel];
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.font = [UIFont fontWithName:@"Thonburi" size:14];
        [_desLabel release];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@">" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_backView addSubview:_button];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_backView addGestureRecognizer:tap];
        [tap release];
        
        [self createView];
    }
    return  self;
}

- (void)setData:(FYHomeItemData *)data {
    if (_data != data) {
        [_data release];
        _data = [data retain];
    }
    [_videoCollectionView reloadData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (nil != _data) {
        return _data.itemList.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (nil != _data) {
        FYHomeItemList *itemList = _data.itemList[indexPath.section];
        if ([itemList.type isEqualToString:@"video"]) {
            FYVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoCell forIndexPath:indexPath];
            FYHomeItemData *cellData = itemList.data;
            cell.coverImage = [cellData.cover objectForKey:@"feed"];
            cell.title = cellData.title;
            NSString *time = [NSString stringChangeWithTimeFormat:cellData.duration];
            cell.cellTag = [NSString stringWithFormat:@"#%@ / %@", cellData.category, time];
            return cell;
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"originCell" forIndexPath:indexPath];
    return cell;
}

- (void)createView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 65, 240);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _backView.y + _backView.height + 20, SCREEN_WIDTH, self.height - _backView.height - 20) collectionViewLayout:flowLayout];
    _videoCollectionView.delegate = self;
    _videoCollectionView.dataSource = self;
    _videoCollectionView.bounces = NO;
    _videoCollectionView.backgroundColor = [UIColor whiteColor];
    _videoCollectionView.showsHorizontalScrollIndicator = NO;
    _videoCollectionView.contentSize = CGSizeMake(_data.itemList.count * (5 + SCREEN_WIDTH - 65) + 5, self.height - _backView.height - 5);
    [_videoCollectionView registerClass:[FYVideoCollectionViewCell class] forCellWithReuseIdentifier:videoCell];
    [_videoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"originCell"];
    [self addSubview:_videoCollectionView];
    [flowLayout release];
    [_videoCollectionView release];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_authorImageView.mas_right).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(20);
        make.height.equalTo(@40);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(0);
        make.left.equalTo(_backView).offset(0);
    }];
    _titleLabel.numberOfLines = 1;
    [_titleLabel sizeToFit];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(20);
        make.bottom.equalTo(_titleLabel.mas_bottom);
    }];
    _subTitleLabel.numberOfLines = 1;
    [_subTitleLabel sizeToFit];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView).offset(0);
        make.left.equalTo(_backView).offset(0);
        make.right.equalTo(_backView).offset(-25);
        make.height.equalTo(@20);
    }];
    _desLabel.numberOfLines = 1;
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backView).offset(0);
        make.centerY.equalTo(_backView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    _videoCollectionView.frame = CGRectMake(0, _backView.y + _backView.height + 20, SCREEN_WIDTH, self.height - _backView.height - 20);
}

- (void)setIcon:(NSString *)icon {
    if (_icon != icon) {
        [_icon release];
        _icon = [icon retain];
    }
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:icon]];
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = _title;
}

- (void)setSubTitle:(NSString *)subTitle {
    if (_subTitle != subTitle) {
        [_subTitle release];
        _subTitle = [subTitle copy];
    }
    _subTitleLabel.text = _subTitle;
}

- (void)setAuthorDescription:(NSString *)authorDescription {
    if (_authorDescription != authorDescription) {
        [_authorDescription release];
        _authorDescription = [authorDescription copy];
    }
    _desLabel.text = _authorDescription;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.delegate getPgcId:[_data.header objectForKey:@"id"] actionUrl:[_data.header objectForKey:@"actionUrl"]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_data != nil) {
        [self.delegate getVideoArray:_data.itemList index:indexPath.row];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
