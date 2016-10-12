//
//  FYContributeViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/12.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYContributeViewController.h"

@interface FYContributeViewController ()

@end

@implementation FYContributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我要投稿";
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"投稿" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
    UITextView *nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:nameTextView];
    nameTextView.backgroundColor = [UIColor whiteColor];
    nameTextView.layer.borderWidth = 1.0;
    nameTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [nameTextView becomeFirstResponder];
    [nameTextView release];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    [nameTextView addSubview:placeholderLabel];
    [nameTextView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    placeholderLabel.text = @"昵称";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    [placeholderLabel release];
    
    UITextView *emailTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:emailTextView];
    emailTextView.backgroundColor = [UIColor whiteColor];
    emailTextView.layer.borderWidth = 1.0;
    emailTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [emailTextView becomeFirstResponder];
    [emailTextView release];
    
    UILabel *placeholderLabel1 = [[UILabel alloc] init];
    [emailTextView addSubview:placeholderLabel1];
    [emailTextView setValue:placeholderLabel1 forKey:@"_placeholderLabel"];
    placeholderLabel1.text = @"邮箱(必填)";
    placeholderLabel1.textColor = [UIColor lightGrayColor];
    [placeholderLabel1 release];
    
    UITextView *videoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 160, SCREEN_WIDTH - 40, 200)];
    [self.view addSubview:videoTextView];
    videoTextView.backgroundColor = [UIColor whiteColor];
    videoTextView.layer.borderWidth = 1.0;
    videoTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [videoTextView becomeFirstResponder];
    [videoTextView release];
    
    UILabel *placeholderLabel2 = [[UILabel alloc] init];
    [videoTextView addSubview:placeholderLabel2];
    [videoTextView setValue:placeholderLabel2 forKey:@"_placeholderLabel"];
    placeholderLabel2.text = @"视频名称 & 视频播放链接(必填)";
    placeholderLabel2.textColor = [UIColor lightGrayColor];
    [placeholderLabel2 release];

    UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 460, SCREEN_WIDTH, 30)];
    wordLabel.text = @"- Your contribution is highly appreciated! -";
    wordLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:15];
    wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:wordLabel];
    [wordLabel release];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, SCREEN_WIDTH, 30)];
    textLabel.text = @"让每个人都开眼，开了又开。";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textLabel];
    [textLabel release];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
    NSLog(@"投稿");
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
