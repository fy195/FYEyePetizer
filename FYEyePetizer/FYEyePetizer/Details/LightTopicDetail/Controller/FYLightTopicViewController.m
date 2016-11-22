//
//  FYLightTopicViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/5.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYLightTopicViewController.h"
#import "NSString+FY_MD5.h"
#import "FYLightTopicData.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYFeedSectionCell.h"
#import "NSString+FYTime.h"
#import "FYHomeTags.h"
#import "FYVideoViewController.h"

@interface FYLightTopicViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, retain) FYLightTopicData *allData;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *next;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation FYLightTopicViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_allData release];
    [_dataArray release];
    [_next release];
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
    
    NSString *str = [_actionUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange start = [str rangeOfString:@"="];
    NSRange end = [str rangeOfString:@"&"];
    NSString *sub = [str substringWithRange:NSMakeRange(start.location, end.location- start.location + 1)];
    NSString *sub1 = [sub substringFromIndex:1];
    NSString *title = [sub1 substringToIndex:sub1.length - 1];
    self.navigationItem.title = title;
    [self createView];
    self.dataArray  = [NSMutableArray array];
    [self getData];
}

- (void)getData {
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString =[NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/lightTopics/%@?_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", _imageId, [timeStamp fy_stringByMD5Bit32]] ;
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.allData = [FYLightTopicData modelWithDic:responseObject];
        [_dataArray addObjectsFromArray:_allData.itemList];
        self.next = _allData.nextPageUrl;
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"网络请求失败");
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    static NSString *const videoCell = @"videoCell";
    FYFeedSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
    if (nil == cell) {
        cell = [[FYFeedSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image = [itemData.cover objectForKey:@"feed"];
    cell.title = itemData.title;
    NSString *time = [NSString stringChangeWithTimeFormat:itemData.duration];
    cell.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, time];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
    if (videoViewController.videoArray.count > 0) {
        [videoViewController.videoArray removeAllObjects];
    }
    videoViewController.videoArray = [_dataArray mutableCopy];
    videoViewController.videoIndex = indexPath.row;
    videoViewController.hidesBottomBarWhenPushed = YES;
    [videoViewController setModalTransitionStyle:2];
    [self presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController release];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _dataArray.count - 2) {
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
        FYLightTopicData *data = [FYLightTopicData modelWithDic:responseObject];
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
