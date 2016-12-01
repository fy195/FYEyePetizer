//
//  FYMineViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

static NSString *const tableViewCell = @"cell";

#import "FYMineViewController.h"
#import "FYContributeViewController.h"
#import "FYFeedbackViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"


@interface FYMineViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *textArray;
@end

@implementation FYMineViewController

- (void)dealloc {
    [_tableView release];
    [_textArray release];
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
    
    self.textArray = @[@"我的缓存", @"我要投稿", @"意见反馈"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;

    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    backView.center = CGPointMake(SCREEN_WIDTH / 2, 70);
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor colorWithWhite:0.869 alpha:1.000];
    backView.layer.cornerRadius = 50.0;
    [headerView addSubview:backView];
    [backView release];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(25, 35, 50, 30);
    
    [backView addSubview:button];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCell] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _textArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *message = [NSString stringWithFormat:@"清除%.2fM缓存。", [self getCacheSize]];
            //1.删除SDWebimage缓存
            [[SDImageCache sharedImageCache]clearMemory];//清除内存缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];//清除磁盘
            
            //2.界面下载的缓存
            NSString *myPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/MyCaches"];
            // 删除文件
            [[NSFileManager defaultManager]removeItemAtPath:myPath error:nil];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

    }else if (indexPath.row == 1){
        FYContributeViewController *contributeViewController = [[FYContributeViewController alloc] init];
        [self.navigationController pushViewController:contributeViewController animated:YES];
        [contributeViewController release];
    }else if (indexPath.row == 2){
        FYFeedbackViewController *feedbackViewController = [[FYFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
        [feedbackViewController release];
    }
}
         
- (CGFloat)getCacheSize {
    CGFloat sdSize = [[SDImageCache sharedImageCache] getSize];
    NSString *myPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Library/Caches/MyCaches"];
    // 获取文件夹中的所有文件
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myPath error:nil];
    unsigned long long size = 0;
    for (NSString *fileName in arr) {
        NSString *filePath = [myPath stringByAppendingPathComponent:fileName];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += dict.fileSize;
    }
             // 1M = 1024K = 1024 * 1024 字节
    CGFloat totalSize = (sdSize + size) / 1024.0 / 1024.0;
    return totalSize;
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
