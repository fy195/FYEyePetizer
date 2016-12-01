//
//  FYAuthorViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYAuthorViewController.h"
#import "NSString+FY_MD5.h"
#import "NSString+FYTime.h"
#import "FYHomeItemList.h"
#import "FYFeedSectionCell.h"
#import "FYHomeItemData.h"
#import "FYAuthorDetailData.h"
#import "FYVideoViewController.h"

@interface FYAuthorViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>
@property (nonatomic, retain) UISegmentedControl *segmentControl;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FYAuthorDetailData *allData;
@property (nonatomic, retain) NSMutableArray *dateArray;
@property (nonatomic, retain) NSMutableArray *shareArray;
@property (nonatomic, copy) NSString *dateNext;
@property (nonatomic, copy) NSString *shareNext;
/** 两种排序方法*/
@property (nonatomic, copy) NSString *currentStrategy;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, assign) CGFloat beginDragY;
@property (nonatomic, retain) UIScrollView *scrollView;
@end

@implementation FYAuthorViewController
- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _scrollView.delegate = nil;
    [_scrollView release];
    [_backView release];
    [_dateArray release];
    [_dateNext release];
    [_shareArray release];
    [_shareNext release];
    [_allData release];
    [_segmentControl release];
    [_tableView release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.text = @"";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    self.dateArray = [NSMutableArray array];
    self.shareArray = [NSMutableArray array];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 180);
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    [self getDataWithPgcId:_pgcId strategy:@"date"];
}

// 网络请求
- (void)getDataWithPgcId:(NSNumber *)pgcId strategy:(NSString *)strategy{
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString =[NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/pgc/videos?_s=%@&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&pgcId=%@&start=0&strategy=%@&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32], _pgcId, strategy] ;
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.allData = [FYAuthorDetailData modelWithDic:responseObject];
        if ([strategy isEqualToString:@"date"]) {
            [_dateArray addObjectsFromArray: _allData.itemList];
            self.dateNext = _allData.nextPageUrl;
            self.currentStrategy = @"date";
        }else {
            [_shareArray addObjectsFromArray: _allData.itemList];
            self.shareNext = _allData.nextPageUrl;
            self.currentStrategy = @"share";
        }
        if (nil == _tableView) {
            [self createView];
        }else {
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_currentStrategy isEqualToString:@"date"]) {
        return _dateArray.count;
    }
    return _shareArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentStrategy isEqualToString:@"date"]) {
        FYHomeItemList *itemList = _dateArray[indexPath.row];
        FYHomeItemData *itemData = itemList.data;
        static NSString *const videoCell = @"videoCell";
        FYFeedSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
        if (nil == cell) {
            cell = [[[FYFeedSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCell] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.image = [itemData.cover objectForKey:@"feed"];
        cell.title = itemData.title;
        NSString *time = [NSString stringChangeWithTimeFormat:itemData.duration];
        cell.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, time];
        return  cell;
    }
    FYHomeItemList *itemList = _shareArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    static NSString *const videoCell = @"videoCell";
    FYFeedSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
    if (nil == cell) {
        cell = [[[FYFeedSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCell] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image = [itemData.cover objectForKey:@"feed"];
    cell.title = itemData.title;
    NSString *time = [NSString stringChangeWithTimeFormat:itemData.duration];
    cell.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, time];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 判断当前排序方法，跳转到不同页面
    if ([_currentStrategy isEqualToString:@"date"]) {
        FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
        if (videoViewController.videoArray.count > 0) {
            [videoViewController.videoArray removeAllObjects];
        }
        videoViewController.videoArray = [_dateArray mutableCopy];
        videoViewController.videoIndex = indexPath.row;
        videoViewController.hidesBottomBarWhenPushed = YES;
        [videoViewController setModalTransitionStyle:2];
        [self presentViewController:videoViewController animated:YES completion:nil];
        [videoViewController release];
    }else {
        FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
        if (videoViewController.videoArray.count > 0) {
            [videoViewController.videoArray removeAllObjects];
        }
        videoViewController.videoArray = [_shareArray mutableCopy];
        videoViewController.videoIndex = indexPath.row;
        videoViewController.hidesBottomBarWhenPushed = YES;
        [videoViewController setModalTransitionStyle:2];
        [self presentViewController:videoViewController animated:YES completion:nil];
        [videoViewController release];
    }

}

- (void)createView {
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    [_scrollView addSubview:_backView];
    _backView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    [_backView release];
    // 头像
    UIImageView *iconImagView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_allData.pgcInfo objectForKey:@"icon"]]]]];
    iconImagView.frame = CGRectMake(0, 0, 60, 60);
    iconImagView.clipsToBounds = YES;
    iconImagView.layer.cornerRadius = 30.f;
    iconImagView.center = CGPointMake(SCREEN_WIDTH / 2, 30);
    [_backView addSubview:iconImagView];
    [iconImagView release];
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    nameLabel.center = CGPointMake(SCREEN_WIDTH / 2, iconImagView.y + iconImagView.height + 25);
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = [_allData.pgcInfo objectForKey:@"name"];
    [_backView addSubview:nameLabel];
    [nameLabel release];
    // 简介
    UILabel *briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 75)];
    briefLabel.textColor = [UIColor lightGrayColor];
    briefLabel.text = [_allData.pgcInfo objectForKey:@"description"];
    briefLabel.numberOfLines = 0;
    [briefLabel sizeToFit];
    briefLabel.center = CGPointMake(SCREEN_WIDTH / 2, nameLabel.y + nameLabel.height + 20 + briefLabel.height / 2 - 15);
    [_backView addSubview:briefLabel];
    [briefLabel release];
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"按时间排序", @"按分享排序"]];
    _segmentControl.frame = CGRectMake(0, _backView.y + _backView.height - 40, SCREEN_WIDTH, 40);
    [_backView addSubview:_segmentControl];
    [_segmentControl release];
    _segmentControl.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    _segmentControl.tintColor = [UIColor clearColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [_segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]};
    [_segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _backView.y + _backView.height, SCREEN_WIDTH, SCREEN_HEIGHT - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_tableView];
    [_tableView release];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    // 根据排序策略进行不同的网络请求
    if (0 == segmentedControl.selectedSegmentIndex) {
        [self getDataWithPgcId:_pgcId strategy: @"date"];
    }else{
        [self getDataWithPgcId:_pgcId strategy: @"shareCount"];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentStrategy isEqualToString:@"date"]) {
        if (indexPath.row >= _dateArray.count - 2) {
            _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(Loading)];
        }
    }else {
        if (indexPath.row >= _shareArray.count - 2) {
            _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(Loading)];
        }
    }
}

- (void)Loading{
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    
    NSString *timeString = [NSString stringWithFormat:@"&_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([_currentStrategy isEqualToString:@"date"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", _dateNext, timeString];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            FYAuthorDetailData *data = [FYAuthorDetailData modelWithDic:responseObject];
            [_dateArray addObjectsFromArray:data.itemList];
            _dateNext = data.nextPageUrl;
            [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Lobster 1.4" size:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"- The End -";
            _tableView.tableFooterView = label;
        }];
        [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
    }else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", _shareNext, timeString];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            FYAuthorDetailData *data = [FYAuthorDetailData modelWithDic:responseObject];
            [_shareArray addObjectsFromArray:data.itemList];
            _shareNext = data.nextPageUrl;
            [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Lobster 1.4" size:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"- The End -";
            _tableView.tableFooterView = label;
        }];
        [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginDragY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        CGFloat offsetY = scrollView.contentOffset.y;
        // 分类按钮未达到顶部之前打开scrollView的滑动，关闭tableView滑动
        if (offsetY >= 0 && offsetY < 180) {
            _scrollView.scrollEnabled = YES;
            _tableView.scrollEnabled = NO;
        }
        // 分类按钮到达顶部之后关闭scrollView滑动，打开tableView滑动
        if (offsetY == 180) {
            _scrollView.scrollEnabled = NO;
            _tableView.scrollEnabled = YES;
        }
        // 导航栏名称改变
        if (offsetY >= 110) {
            self.navigationItem.title = [_allData.pgcInfo objectForKey:@"name"];
        }else {
            self.navigationItem.title = @"";
        }
    }
    if ([scrollView isEqual:_tableView]) {
        if (0 == scrollView.contentOffset.y) {
            _tableView.scrollEnabled = NO;
            _scrollView.scrollEnabled = YES;
        }
    }
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
