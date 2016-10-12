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

@interface FYSearchViewController ()
<
UITextFieldDelegate
>
@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UILabel *countLabel;
@end

@implementation FYSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
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
    [_searchTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
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
    _countLabel.textColor = [UIColor colorWithWhite:0.882 alpha:1.000];
    [self.view addSubview:_countLabel];
    
}

- (void)cancelButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text urlEncode];
    [self getData:text];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchTextField resignFirstResponder];
    return YES;
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
