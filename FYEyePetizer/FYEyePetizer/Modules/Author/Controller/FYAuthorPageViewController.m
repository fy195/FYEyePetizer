//
//  FYAuthorPageViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//
static NSString *const authorCell = @"authorCell";
static NSString *const titleCell = @"titleCell";
static NSString *const videoCell = @"videoCell";
#import "FYAuthorPageViewController.h"
#import "FYAuthorData.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYAuthorTableViewCell.h"
#import "FYTitleTableViewCell.h"
#import "FYVideoCollectionTableViewCell.h"
#import "NSString+FY_MD5.h"
#import "FYAuthorViewController.h"
#import "FYVideoViewController.h"

@interface FYAuthorPageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FYVideoTableViewCellDelegate
>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FYAuthorData *AllData;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *next;

@end

@implementation FYAuthorPageViewController
- (void)dealloc {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView release];
    [_AllData release];
    [_next release];
    [_dataArray release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Eyepetizer";
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    [self createView];
    [self getData];
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://baobab.wandoujia.com/api/v3/tabs/pgcs?_s=8e4ce93f2345d3ca722ba419f9ac96b0&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305";
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.AllData = [FYAuthorData modelWithDic:responseObject];
        [_dataArray addObjectsFromArray:_AllData.itemList];
        self.next = _AllData.nextPageUrl;
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    if ([itemData.dataType isEqualToString:@"LeftAlignTextHeader"]) {
        return 30;
    }else if ([itemData.dataType isEqualToString:@"BriefCard"]){
        return 80;
    }else if ([itemData.dataType isEqualToString:@"VideoCollection"]) {
        return 320;
    }
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    if ([itemData.dataType isEqualToString:@"BriefCard"]) {
        FYAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:authorCell];
        if (nil == cell) {
            cell = [[[FYAuthorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:authorCell] autorelease];
        }
        cell.icon = itemData.icon;
        cell.title = itemData.title;
        cell.subTitle = itemData.subTitle;
        cell.authorDescription = itemData.dataDescription;
        return cell;
    }else if ([itemData.dataType isEqualToString:@"LeftAlignTextHeader"]) {
        FYTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
        if (nil == cell) {
            cell = [[[FYTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell] autorelease];
        }
        cell.text = itemData.text;
        return cell;
    }else if ([itemData.dataType isEqualToString:@"VideoCollection"]){
        FYVideoCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
        if (nil == cell) {
            cell = [[[FYVideoCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCell] autorelease];
        }
        cell.delegate = self;
        cell.icon = [itemData.header objectForKey:@"icon"];
        cell.title = [itemData.header objectForKey:@"title"];
        cell.subTitle = [itemData.header objectForKey:@"subTitle"];
        cell.authorDescription = [itemData.header objectForKey:@"description"];
        cell.data = itemData;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    if ([itemList.type isEqualToString:@"briefCard"]) {
        FYHomeItemData *itemdata = itemList.data;
        FYAuthorViewController *authorController = [[FYAuthorViewController alloc] init];
        authorController.pgcId = itemdata.dataId;
        authorController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorController animated:YES];
        [authorController release];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataArray.count-1) {
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(Loading)];
    }
}

- (void)getPgcId:(NSNumber *)pgcId actionUrl:(NSString *)actionUrl {
    FYAuthorViewController *authorController = [[FYAuthorViewController alloc] init];
    authorController.pgcId = pgcId;
    authorController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorController animated:YES];
    [authorController release];
}

- (void)getVideoArray:(NSArray *)videoArray index:(NSInteger)index {
    FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
    if (videoViewController.videoArray.count > 0) {
        [videoViewController.videoArray removeAllObjects];
    }
    videoViewController.videoArray = [videoArray mutableCopy];
    videoViewController.videoIndex = index;
    [self presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController release];
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
        FYAuthorData *data = [FYAuthorData modelWithDic:responseObject];
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
