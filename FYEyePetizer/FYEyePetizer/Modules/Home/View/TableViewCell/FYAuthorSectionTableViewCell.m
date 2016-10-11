//
//  FYAuthorSectionTableViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//
static NSString *const collectionViewCell = @"cell";
static NSString *const viewAllCell = @"viewAllCell";
#import "FYAuthorSectionTableViewCell.h"
#import "FYTopicCollectionViewCell.h"
#import "FYHomeItemData.h"
#import "FYHomeItemList.h"
#import "NSString+FYTime.h"
#import "FYViewAllCollectionViewCell.h"

@interface FYAuthorSectionTableViewCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *desLabel;
@property (nonatomic, retain) UIImageView *topicImageView;
@property (nonatomic, retain) UICollectionView *topicCollectionView;
@property (nonatomic, retain) UIImageView *cellImageView;

@end

@implementation FYAuthorSectionTableViewCell
- (void)dealloc {
    _topicCollectionView.delegate = nil;
    _topicCollectionView.dataSource = nil;
    [_iconImageView release];
    [_titleLabel release];
    [_desLabel release];
    [_topicCollectionView release];
    [_topicImageView release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topicImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_topicImageView];
        _topicImageView.userInteractionEnabled = YES;
        [_topicImageView release];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 30.f;
        [_topicImageView addSubview:_iconImageView];
        [_iconImageView release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_topicImageView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel release];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_topicImageView addSubview:_desLabel];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont fontWithName:@"Thonburi" size:14];
        _desLabel.backgroundColor = [UIColor clearColor];
        [_desLabel release];
        
        self.cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三角形cell"]];
        [_topicImageView addSubview:_cellImageView];
        [_cellImageView release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_topicImageView addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (nil != _itemData) {
        return _itemData.itemList.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (nil != _itemData) {
        FYHomeItemList *itemList = _itemData.itemList[indexPath.section];
        if ([itemList.type isEqualToString:@"video"]) {
            FYTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCell forIndexPath:indexPath];
            FYHomeItemData *cellData = itemList.data;
            cell.coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[cellData.cover objectForKey:@"feed"]]]];
            cell.title = cellData.title;
            NSString *time = [NSString stringChangeWithTimeFormat:cellData.duration];
            cell.cellTag = [NSString stringWithFormat:@"#%@ / %@", cellData.category, time];
            return cell;
        }else {
            FYViewAllCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:viewAllCell forIndexPath:indexPath];
            FYHomeItemData *cellData = itemList.data;
            cell.text = cellData.text;
            return cell;
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"originCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _itemData.itemList[indexPath.section];
    if ([itemList.type isEqualToString:@"video"]) {
        [self.authorDelegate getPgcArray:_itemData.itemList];
    }else {
        [self.authorDelegate getPgcId:[_itemData.header objectForKey:@"id"]];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.authorDelegate getPgcId:[_itemData.header objectForKey:@"id"]];
}

- (void)setTopicImage:(UIImage *)topicImage {
    if (_topicImage != topicImage) {
        [_topicImage release];
        _topicImage = [topicImage retain];
    }
    _topicImageView.image = _topicImage;
}

- (void)setItemData:(FYHomeItemData *)itemData {
    if (_itemData != itemData) {
        [_itemData release];
        _itemData = [itemData retain];
    }
    [self createView];
}

- (void)setIconImage:(UIImage *)iconImage {
    if (_iconImage != iconImage) {
        [_iconImage release];
        _iconImage = [iconImage retain];
    }
    _iconImageView.image = iconImage;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = title;
}

- (void)setAuthorDes:(NSString *)authorDes {
    if (_authorDes != authorDes) {
        [_authorDes release];
        _authorDes = [authorDes copy];
    }
    _desLabel.text = authorDes;
}

- (void)createView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 65, self.height - _topicImageView.height);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.topicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _topicCollectionView.delegate = self;
    _topicCollectionView.dataSource = self;
    _topicCollectionView.bounces = NO;
    _topicCollectionView.backgroundColor = [UIColor whiteColor];
    _topicCollectionView.showsHorizontalScrollIndicator = NO;
    _topicCollectionView.contentSize = CGSizeMake(_itemData.itemList.count * (5 + SCREEN_WIDTH - 65) + 5, self.height - _topicImageView.height - 5);
    [_topicCollectionView registerClass:[FYTopicCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCell];
    [_topicCollectionView registerClass:[FYViewAllCollectionViewCell class] forCellWithReuseIdentifier:viewAllCell];
    [_topicCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"originCell"];
    [self addSubview:_topicCollectionView];
    [flowLayout release];
    [_topicCollectionView release];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _topicImageView.frame = CGRectMake(0, 0, self.width, 240);
    _cellImageView.frame = CGRectMake(0, 0, 20, 20);
    _cellImageView.center = CGPointMake(_topicImageView.width / 2, _topicImageView.height - 7);
    _topicCollectionView.frame = CGRectMake(0, _topicImageView.y + _topicImageView.height, self.width, self.height - _topicImageView.height);
    _iconImageView.frame = CGRectMake(0, 0, 60, 60);
    _iconImageView.center = CGPointMake(self.width / 2, 90);
    _titleLabel.frame = CGRectMake(0, 0, self.width, 20);
    _titleLabel.center = CGPointMake(self.width / 2, 150);
    _desLabel.frame = CGRectMake(0, 0, self.width, 20);
    _desLabel.center = CGPointMake(self.width / 2, 180);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
