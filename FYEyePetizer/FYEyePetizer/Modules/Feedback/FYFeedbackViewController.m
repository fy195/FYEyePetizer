//
//  FYFeedbackViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/12.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYFeedbackViewController.h"

@interface FYFeedbackViewController ()
@property (nonatomic, retain) UITextView *nameTextView;
@property (nonatomic, retain) UITextView *emailTextView;
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
    
    self.nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 200)];
    [self.view addSubview:_nameTextView];
    _nameTextView.backgroundColor = [UIColor whiteColor];
    _nameTextView.layer.borderWidth = 1.0;
    _nameTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_nameTextView becomeFirstResponder];
    [_nameTextView release];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    [_nameTextView addSubview:placeholderLabel];
    [_nameTextView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    placeholderLabel.text = @"请告诉我们你遇到的问题或想反馈的意见";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    [placeholderLabel release];
    
    self.emailTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 320, SCREEN_WIDTH - 40, 50)];
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

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_emailTextView resignFirstResponder];
    [_nameTextView resignFirstResponder];
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
