//
//  FYDailyViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYDailyViewController.h"
#import "FYDailyData.h"
#import "FYHomeItemList.h"
#import "FYIssueList.h"
#import "FYHomeItemData.h"
#import "FYTextHeaderTableViewCell.h"
#import "FYFeedSectionCell.h"
#import "NSString+FYTime.h"
#import "NSString+FY_MD5.h"
#import "FYHomeTags.h"

@interface FYDailyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FYDailyData *allData;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *next;
@end

@implementation FYDailyViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_tableView release];
    [_allData release];
    [_dataArray release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.text = @"Today";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"每日编辑精选";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 80, 44)];
    rightLabel.textColor = [UIColor blackColor];
    rightLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:17];
    [self.navigationController.navigationBar addSubview:rightLabel];
    
    self.dataArray = [NSMutableArray array];
    [self getData];
}

- (void)getData {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://baobab.wandoujia.com/api/v2/feed?_s=8ac81bfe34c407e2d759a0439494f0f5&date=1475653034929&f=iphone&net=wifi&num=7&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305";
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.allData = [FYDailyData modelWithDic:responseObject];
        [_dataArray addObjectsFromArray:_allData.issueList];
        self.next = _allData.nextPageUrl;
        [self createView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FYIssueList *issueList = _dataArray[section];
    return issueList.itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYIssueList *issueList = _dataArray[indexPath.section];
    FYHomeItemList *itemList = issueList.itemList[indexPath.row];
    if ([itemList.type isEqualToString:@"video"]) {
        return 200;
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYIssueList *issueList = _dataArray[indexPath.section];
    FYHomeItemList *itemList = issueList.itemList[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    FYHomeTags *tag = [itemData.tags firstObject];
    if ([itemList.type isEqualToString:@"textHeader"]) {
        static NSString *const textCell = @"textCell";
        FYTextHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell];
        if (nil == cell) {
            cell = [[[FYTextHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCell] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.text = itemData.text;
        if (![itemData.text isEqualToString:@"- Weekend Special -" ]) {
            for (UIView *view in self.navigationController.navigationBar.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)view;
                    label.text = itemData.text;
                }
            }

        }
        return cell;
    }else {
        static NSString *const videoCell = @"videoCell";
        FYFeedSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
        if (nil == cell) {
            cell = [[FYFeedSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.cover objectForKey:@"feed"]]]];
        cell.title = itemData.title;
        NSString *time = [NSString stringChangeWithTimeFormat:itemData.duration];
        cell.text = [NSString stringWithFormat:@"#%@ / %@", tag.name, time];
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= _dataArray.count - 1) {
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(Loading)];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@", _next, timeString];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FYDailyData *data = [FYDailyData modelWithDic:responseObject];
        [_dataArray addObjectsFromArray:data.issueList];
        _next = data.nextPageUrl;
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
