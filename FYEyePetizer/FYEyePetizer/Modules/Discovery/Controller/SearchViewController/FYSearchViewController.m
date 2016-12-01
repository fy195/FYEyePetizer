//
//  FYSearchViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/12.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYSearchViewController.h"
#import "NSString+FY_MD5.h"
#import "NSString+Categories.h"
#import "FYSearchData.h"
#import "FYFeedSectionCell.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "NSString+FYTime.h"
#import "FYVideoViewController.h"

static NSString *const tableViewCell = @"cell";

@interface FYSearchViewController ()
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FYSearchData *allData;
@property (nonatomic, retain) NSString *nextPage;
@end

@implementation FYSearchViewController

- (void)dealloc {
    [_searchTextField release];
    [_dataArray release];
    [_countLabel release];
    [_nextPage release];
    [_allData release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.alpha = 0.0;
    self.tabBarController.tabBar.hidden = YES;
}

//- (void)viewWillDisappear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    self.dataArray = [NSMutableArray array];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = self.view.bounds;
    [self.view addSubview:visualView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    backView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    [self.view addSubview:backView];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 80, 30)];
    _searchTextField.layer.cornerRadius = 5.0f;
    _searchTextField.backgroundColor = [UIColor colorWithWhite:0.882 alpha:1.000];
    _searchTextField.placeholder = @"帮你找到感兴趣的视频";
    [_searchTextField setValue:[UIColor colorWithWhite:0.749 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    _searchTextField.delegate = self;
    [_searchTextField becomeFirstResponder];
//    [_searchTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:_searchTextField];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(_searchTextField.x + _searchTextField.width + 10, 20, 40, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithWhite:0.285 alpha:1.000] forState:UIControlStateNormal];
    [backView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 30)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor colorWithWhite:0.421 alpha:1.000];
    [self.view addSubview:_countLabel];
    _countLabel.text = @"输入标题或描述中的关键词找到更多视频";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, SCREEN_WIDTH, SCREEN_HEIGHT - 106 - 44) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
}

- (void)cancelButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text urlEncode];
    [self getData:text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    UILabel *label = [self.view viewWithTag:1002];
    if (label != nil) {
        [label removeFromSuperview];
    }
    UILabel *endLabel = [self.view viewWithTag:1003];
    if (endLabel != nil) {
        [endLabel removeFromSuperview];
    }
    _countLabel.text = @"输入标题或描述中的关键词找到更多视频";
    [_tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchTextField resignFirstResponder];
    return YES;
}

- (void)getData:(NSString *)text {
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/search?_s=%@&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&query=%@&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32], text];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.allData = [FYSearchData modelWithDic:responseObject];
        if (_allData.itemList.count > 0) {
            [_dataArray addObjectsFromArray:_allData.itemList];
            self.nextPage = _allData.nextPageUrl;
            [_tableView reloadData];
            UILabel *label = [self.view viewWithTag:1002];
            if (label != nil) {
                [label removeFromSuperview];
            }
            _countLabel.text = [NSString stringWithFormat:@"- 「%@」搜索结果共%@个 -", [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _allData.total];
        }else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH,40)];
            label.tag = 1002;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"很抱歉,没有找到相匹配的内容";
            label.textColor = [UIColor colorWithWhite:0.421 alpha:1.000];
            label.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
            [self.view addSubview:label];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _dataArray[indexPath.row];
    FYHomeItemData *itemData = itemList.data;
    FYFeedSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell];
    if (nil == cell) {
        cell = [[[FYFeedSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCell] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image = [itemData.cover objectForKey:@"feed"];
    cell.title = itemData.title;
    NSString *time = [NSString stringChangeWithTimeFormat:itemData.duration];
    cell.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, time];
    return cell;
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

- (void)Loading {
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    
    NSString *timeString = [NSString stringWithFormat:@"&_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", _nextPage, timeString];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            FYSearchData *data = [FYSearchData modelWithDic:responseObject];
            [_dataArray addObjectsFromArray:data.itemList];
            _nextPage = data.nextPageUrl;
            [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            label.tag = 1003;
            label.backgroundColor = [UIColor clearColor];
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
