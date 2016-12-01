//
//  FYRankingViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYRankingViewController.h"
#import "FYRankingData.h"
#import "NSString+FY_MD5.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYFeedSectionCell.h"
#import "NSString+FYTime.h"
#import "FYVideoViewController.h"

@interface FYRankingViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, retain) UISegmentedControl *segmentControl;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FYRankingData *allData;
@end

@implementation FYRankingViewController
- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
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
    self.navigationItem.title = @"排行榜";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    [self createView];
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"周排行", @"月排行", @"总排行"]];
    _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [self.view addSubview:_segmentControl];
    [_segmentControl release];
    _segmentControl.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    _segmentControl.tintColor = [UIColor clearColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [_segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor blackColor]};
    [_segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];

    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self getDataWithStrategy:@"weekly"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allData.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _allData.itemList[indexPath.row];
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
    videoViewController.videoArray = [_allData.itemList mutableCopy];
    videoViewController.videoIndex = indexPath.row;
    videoViewController.hidesBottomBarWhenPushed = YES;
    [videoViewController setModalTransitionStyle:2];
    [self presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController release];
}


- (void)getDataWithStrategy:(NSString *)strategy{
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString =[NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/ranklist?_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&strategy=%@&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32], strategy] ;
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.allData = [FYRankingData modelWithDic:responseObject];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    if (0 == segmentedControl.selectedSegmentIndex) {
        [self getDataWithStrategy:@"weekly"];
    }else if (1 == segmentedControl.selectedSegmentIndex) {
        [self getDataWithStrategy:@"monthly"];
    }else {
        [self getDataWithStrategy:@"historical"];
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
