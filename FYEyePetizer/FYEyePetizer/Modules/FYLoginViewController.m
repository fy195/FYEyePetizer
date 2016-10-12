//
//  FYLoginViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/12.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYLoginViewController.h"

@interface FYLoginViewController ()

@end

@implementation FYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置背景图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome"]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:imageView];
    [imageView release];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 20, 20, 20);
    [button setImage:[UIImage imageNamed:@"箭头2下"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [backView addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [backView addSubview:label];
    label.text = @"登录后即可评论视频";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@20);
    }];
    
    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    [backView addSubview:userTextField];
    userTextField.backgroundColor = [UIColor clearColor];
    userTextField.textColor = [UIColor whiteColor];
    userTextField.clearButtonMode = UITextFieldViewModeAlways;
    userTextField.placeholder = @"点击后输入手机号 / Email登录";
    [userTextField setValue:[UIColor colorWithWhite:0.826 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-50);
        make.width.equalTo(@250);
        make.height.equalTo(@50);
    }];
    [userTextField release];
    
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    [backView addSubview:passwordTextField];
    passwordTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.placeholder = @"输入密码";
    [passwordTextField setValue:[UIColor colorWithWhite:0.826 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(userTextField.mas_bottom).offset(20);
        make.width.equalTo(@250);
        make.height.equalTo(@50);
    }];
    [passwordTextField release];
    
    UISegmentedControl *segmengtControl = [[UISegmentedControl alloc] initWithItems:@[@"登录", @"马上注册"]];
    [backView addSubview:segmengtControl];
    [segmengtControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView).offset(0);
        make.top.equalTo(passwordTextField.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    segmengtControl.backgroundColor = [UIColor clearColor];
    segmengtControl.tintColor = [UIColor clearColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [segmengtControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor whiteColor]};
    [segmengtControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    [segmengtControl release];
}

- (void)buttonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
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
