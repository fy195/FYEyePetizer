//
//  FYMineViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

static NSString *const tableViewCell = @"cell";

#import "FYMineViewController.h"
#import "FYLoginViewController.h"
#import "FYContributeViewController.h"
#import "FYFeedbackViewController.h"

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
    
    self.textArray = @[@"我的收藏", @"我的评论", @"我的消息", @"我的缓存", @"功能开关", @"我要投稿", @"意见反馈"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
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
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.center = CGPointMake(SCREEN_WIDTH / 2, 160);
    label.backgroundColor = [UIColor clearColor];
    label.text = @"点击登录后可以评论";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
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
    if (indexPath.row < 3) {
        FYLoginViewController *loginViewController = [[FYLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        [loginViewController release];
    }else if (indexPath.row == 5){
        FYContributeViewController *contributeViewController = [[FYContributeViewController alloc] init];
        [self.navigationController pushViewController:contributeViewController animated:YES];
        [contributeViewController release];
    }else if (indexPath.row == 6){
        FYFeedbackViewController *feedbackViewController = [[FYFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
        [feedbackViewController release];
    }else {
        
    }
}

- (void)buttonAction:(UIButton *)button {
    FYLoginViewController *loginViewController = [[FYLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
    [loginViewController release];
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
