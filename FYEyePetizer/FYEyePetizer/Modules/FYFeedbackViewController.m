//
//  FYFeedbackViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/12.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYFeedbackViewController.h"

@interface FYFeedbackViewController ()

@end

@implementation FYFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"意见反馈";
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
    UITextView *nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 200)];
    [self.view addSubview:nameTextView];
    nameTextView.backgroundColor = [UIColor whiteColor];
    nameTextView.layer.borderWidth = 1.0;
    nameTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [nameTextView becomeFirstResponder];
    [nameTextView release];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    [nameTextView addSubview:placeholderLabel];
    [nameTextView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    placeholderLabel.text = @"请告诉我们你遇到的问题或想反馈的意见";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    [placeholderLabel release];
    
    UITextView *emailTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 320, SCREEN_WIDTH - 40, 50)];
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

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
    NSLog(@"发送");
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
