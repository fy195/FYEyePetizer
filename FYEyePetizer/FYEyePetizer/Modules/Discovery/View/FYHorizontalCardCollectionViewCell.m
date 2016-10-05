//
//  FYHorizontalCardCollectionViewCell.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/4.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHorizontalCardCollectionViewCell.h"
#import "FYCellCollectionViewCell.h"
#import "FYHomeItemData.h"
#import "FYHomeItemList.h"

static NSString *const collectionViewCell = @"cellCollectionViewCell";
@interface FYHorizontalCardCollectionViewCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, retain) UICollectionView *cellCollectionView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *currentArray;
@property (nonatomic, retain) NSMutableArray *itemListArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FYHorizontalCardCollectionViewCell

- (void)dealloc {
    [_cellCollectionView release];
    [_pageControl release];
    [_currentArray release];
    [_itemListArray release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentArray = [NSMutableArray array];
        self.itemListArray = [NSMutableArray array];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 200);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.cellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) collectionViewLayout:flowLayout];
        _cellCollectionView.delegate = self;
        _cellCollectionView.dataSource = self;
        _cellCollectionView.pagingEnabled = YES;
        _cellCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_cellCollectionView];
        [_cellCollectionView registerClass:[FYCellCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCell];
    }
    return self;
}

- (void)pageControlValueChanged:(UIPageControl *)pageControl {
    _cellCollectionView.contentOffset = CGPointMake(SCREEN_WIDTH * (pageControl.currentPage + 1), 0);
}

#pragma mark - 定时器
- (void)closeTimer {
    [_timer invalidate];
}

- (void)timerAction:(NSTimer *)timer {
    NSInteger pageNumber = _cellCollectionView.contentOffset.x / SCREEN_WIDTH;
    if (_itemListArray.count == pageNumber) {
        pageNumber = 0;
        _cellCollectionView.contentOffset = CGPointMake(pageNumber * SCREEN_WIDTH, 0);
        
    }
    [_cellCollectionView setContentOffset:CGPointMake((pageNumber + 1) * SCREEN_WIDTH, 0) animated:YES];
    _pageControl.currentPage = pageNumber;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_cellCollectionView]) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:_cellCollectionView]) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0f]];
    }
}

#pragma mark - collectionView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_cellCollectionView]) {
        NSInteger pageCount = scrollView.contentOffset.x / SCREEN_WIDTH;
        if (0 == pageCount) {
            pageCount = _itemListArray.count;
        } else if (_itemListArray.count + 1 == pageCount) {
            pageCount = 1;
        }
        _pageControl.currentPage = pageCount - 1;
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * pageCount, 0);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _itemListArray.count + 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _currentArray[indexPath.section];
    FYCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCell forIndexPath:indexPath];
    if (_currentArray.count > 1) {
        cell.carouselImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemList.data.image]]];
    }
    
    return cell;
}

- (void)setData:(FYHomeItemData *)data {
    if (_data != data) {
        [_data release];
        _data = [data retain];
    }
    
    if (_itemListArray.count > 0) {
        [_itemListArray removeAllObjects];
    }
    
    if (_data.itemList.count > 0) {
        for (int i = 0; i < data.itemList.count; i++) {
            FYHomeItemList *itemList = _data.itemList[i];
            [_itemListArray addObject:itemList];
        }
    }
    
    if (_currentArray.count > 0) {
        [_currentArray removeAllObjects];
    }
    if (_itemListArray.count > 0) {
        [_currentArray addObject:[_itemListArray lastObject]];
        [_currentArray addObjectsFromArray:_itemListArray];
        [_currentArray addObject:[_itemListArray firstObject]];
    }
    
        if (_timer) {
            [_timer invalidate];
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = _itemListArray.count;
        CGSize pageSize = [_pageControl sizeForNumberOfPages:_itemListArray.count];
        _pageControl.frame = CGRectMake(0, 0, pageSize.width, pageSize.height);
        _pageControl.center = CGPointMake(SCREEN_WIDTH / 2, _cellCollectionView.y + _cellCollectionView.height - 20);
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
        
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _cellCollectionView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
}


@end
