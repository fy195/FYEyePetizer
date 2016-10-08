//
//  FYCampaignViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 dllo. All rights reserved.
//
static NSString *const campaignCell = @"campaignCell";

#import "FYCampaignViewController.h"
#import "NSString+FY_MD5.h"
#import "FYCampaignData.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYCampaignTableViewCell.h"
#import "FYLightTopicViewController.h"
#import "FYHonriZontalViewController.h"

@interface FYCampaignViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *next;
@property (nonatomic, retain) FYCampaignData *allData;
@property (nonatomic, assign) BOOL isRefresh;
@end

@implementation FYCampaignViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_allData release];
    [_dataArray release];
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
    
    NSString *str = [_actionUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange start = [str rangeOfString:@"="];
    NSString *sub = [str substringWithRange:NSMakeRange(start.location, str.length - start.location)];
    NSString *title = [sub substringFromIndex:1];
    self.navigationItem.title = title;
    
    self.dataArray = [NSMutableArray array];
    [self createView];
    [self getData];
}

- (void)getData {
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString =[NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/specialTopics?_s=%@&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]] ;
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.allData = [FYCampaignData modelWithDic:responseObject];
        [_dataArray addObjectsFromArray: _allData.itemList];
        self.next = _allData.nextPageUrl;
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    FYCampaignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:campaignCell];
    if (nil == cell) {
        cell = [[[FYCampaignTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:campaignCell] autorelease];
    }
    cell.campaignImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemData.image]]];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    NSString *actionUrl = itemData.actionUrl;
    if ([actionUrl hasSuffix:@"true"]) {
        FYHonriZontalViewController *honrizontalViewController = [[FYHonriZontalViewController alloc] init];
        honrizontalViewController.actionUrl = actionUrl;
        honrizontalViewController.bannerId = itemData.dataId;
        honrizontalViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:honrizontalViewController animated:YES];
        [honrizontalViewController release];
    }else {
        FYLightTopicViewController *lightTopicViewController = [[FYLightTopicViewController alloc] init];
        lightTopicViewController.imageId = itemData.dataId;
        lightTopicViewController.actionUrl = actionUrl;
        lightTopicViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lightTopicViewController animated:YES];
        [lightTopicViewController release];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _dataArray.count - 2) {
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(Loading)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        if (scrollView.contentOffset.y < 0) {
            [self Refreshing];
        }
    }
}

- (void)Refreshing {
        NSDate *datenow =[NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:datenow];
        NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *urlString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/specialTopics?_s=%@&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.allData = [FYCampaignData modelWithDic:responseObject];
            if (_dataArray.count > 0) {
                [_dataArray removeAllObjects];
            }
            self.next = _allData.nextPageUrl;
            [_dataArray addObjectsFromArray:_allData.itemList];
            [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败");
        }];
        [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
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
            FYCampaignData *data = [FYCampaignData modelWithDic:responseObject];
            [_dataArray addObjectsFromArray:data.itemList];
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
