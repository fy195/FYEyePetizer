//
//  FYContributeViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/12.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYContributeViewController.h"

@interface FYContributeViewController ()
@property (nonatomic, retain) UITextView *nameTextView;
@property (nonatomic, retain) UITextView *emailTextView;
@property (nonatomic, retain) UITextView *videoTextView;
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
    
    self.nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:_nameTextView];
    _nameTextView.backgroundColor = [UIColor whiteColor];
    _nameTextView.layer.borderWidth = 1.0;
    _nameTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_nameTextView becomeFirstResponder];
    [_nameTextView release];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    [_nameTextView addSubview:placeholderLabel];
    [_nameTextView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    placeholderLabel.text = @"昵称";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    [placeholderLabel release];
    
    self.emailTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:_emailTextView];
    _emailTextView.backgroundColor = [UIColor whiteColor];
    _emailTextView.layer.borderWidth = 1.0;
    _emailTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_emailTextView becomeFirstResponder];
    [_emailTextView release];
    
    UILabel *placeholderLabel1 = [[UILabel alloc] init];
    [_emailTextView addSubview:placeholderLabel1];
    [_emailTextView setValue:placeholderLabel1 forKey:@"_placeholderLabel"];
    placeholderLabel1.text = @"邮箱(必填)";
    placeholderLabel1.textColor = [UIColor lightGrayColor];
    [placeholderLabel1 release];
    
    self.videoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 160, SCREEN_WIDTH - 40, 200)];
    [self.view addSubview:_videoTextView];
    _videoTextView.backgroundColor = [UIColor whiteColor];
    _videoTextView.layer.borderWidth = 1.0;
    _videoTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_videoTextView becomeFirstResponder];
    [_videoTextView release];
    
    UILabel *placeholderLabel2 = [[UILabel alloc] init];
    [_videoTextView addSubview:placeholderLabel2];
    [_videoTextView setValue:placeholderLabel2 forKey:@"_placeholderLabel"];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"投稿成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nameTextView resignFirstResponder];
    [_emailTextView resignFirstResponder];
    [_videoTextView resignFirstResponder];
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
