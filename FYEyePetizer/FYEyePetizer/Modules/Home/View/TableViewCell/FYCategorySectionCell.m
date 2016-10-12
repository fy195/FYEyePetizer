//
//  FYCategorySectionCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYCategorySectionCell.h"
#import "FYHomeItemData.h"
#import "FYCatogeryCollectionViewCell.h"
#import "FYHomeItemList.h"
#import "NSString+FYTime.h"

static NSString *const categoryCell = @"categoryCell";
@interface FYCategorySectionCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSMutableArray *currentArray;

@end

@implementation FYCategorySectionCell
- (void)dealloc {
    [_titleLabel release];
    [_subtitleLabel release];
    [_collectionView release];
    [_pageControl release];
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:CGRectZero];
        _view.backgroundColor = [UIColor whiteColor];
        _view.userInteractionEnabled = YES;
        [self addSubview:_view];
        [_view release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_view addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel release];
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_view addSubview:_subtitleLabel];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.font = [UIFont fontWithName:@"Thonburi" size:17];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [_subtitleLabel release];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@">" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_view addSubview:_button];
        
        self.currentArray = [NSMutableArray array];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_view addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)setItemData:(FYHomeItemData *)itemData {
    if (_itemData != itemData) {
        [_itemData release];
        _itemData = [itemData retain];
    }

    if (_currentArray.count > 0) {
        [_currentArray removeAllObjects];
    }
    if (nil != itemData) {
        [_currentArray addObject:[itemData.itemList lastObject]];
        [_currentArray addObjectsFromArray:itemData.itemList];
        [_currentArray addObject:[itemData.itemList firstObject]];
    }
    [self createCollectionView];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    _pageControl.numberOfPages = [_itemData.count integerValue];
    [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    [self addSubview:_pageControl];
    [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_pageControl release];
    
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 270);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[FYCatogeryCollectionViewCell class] forCellWithReuseIdentifier:categoryCell];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [flowLayout release];
    [_collectionView release];
    
    _collectionView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (nil != _itemData) {
        return _itemData.itemList.count + 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (nil != _itemData) {
        FYHomeItemList *itemList = _currentArray[indexPath.section];
        FYCatogeryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCell forIndexPath:indexPath];
        cell.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemList.data.cover objectForKey:@"feed"]]]];
        cell.itemTitle = itemList.data.title;
        NSString *time = [NSString stringChangeWithTimeFormat:itemList.data.duration];
        cell.itemTag = [NSString stringWithFormat:@"#%@ / %@", itemList.data.category, time];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.categoryDelegate getCategoryArray:_currentArray WithIndex:indexPath.section];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_collectionView]) {
        NSInteger pageCount;
        pageCount = scrollView.contentOffset.x/ SCREEN_WIDTH;
        if (0 == pageCount) {
            pageCount = _itemData.itemList.count;
        } else if (_itemData.itemList.count + 1 == pageCount) {
            pageCount = 1;
        }
        _pageControl.currentPage = pageCount - 1;
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH  * pageCount, 0);
    }
}

- (void)pageControlValueChanged:(UIPageControl *)pageControl {
    _collectionView.contentOffset = CGPointMake(SCREEN_WIDTH * (pageControl.currentPage + 1), 0);
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.categoryDelegate getCategoryId:[_itemData.header objectForKey:@"id"] actionUrl:[_itemData.header objectForKey:@"actionUrl"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    _titleLabel.center = CGPointMake(SCREEN_WIDTH / 2, 25 + _titleLabel.height / 2);
    _subtitleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    _subtitleLabel.center = CGPointMake(SCREEN_WIDTH / 2, _titleLabel.y + _titleLabel.height + 10 + _subtitleLabel.height / 2);
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_view).offset(-25);
        make.centerY.equalTo(_view.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    _collectionView.frame = CGRectMake(0, _view.y + _view.height + 25, SCREEN_WIDTH, 270);
    _pageControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height - (_collectionView.y + _collectionView.height));
    _pageControl.center = CGPointMake(SCREEN_WIDTH / 2, _collectionView.y + _collectionView.height + _pageControl.height / 2);
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    if (_subtitle != subtitle) {
        [_subtitle release];
        _subtitle = [subtitle copy];
    }
    _subtitleLabel.text = subtitle;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
