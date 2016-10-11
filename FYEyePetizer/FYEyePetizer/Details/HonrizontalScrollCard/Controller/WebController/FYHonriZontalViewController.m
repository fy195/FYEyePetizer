//
//  FYHonriZontalViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/7.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHonriZontalViewController.h"

@interface FYHonriZontalViewController ()
@property (nonatomic, retain) UIWebView *webView;
@end

@implementation FYHonriZontalViewController
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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    NSString *str = [_actionUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange start = [str rangeOfString:@"="];
    NSRange end = [str rangeOfString:@"&"];
    NSString *sub = [str substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
    NSString *sub1 = [sub substringFromIndex:1];
    NSString *title = [sub1 substringToIndex:sub1.length - 1];
    self.navigationItem.title = title;
    
    NSRange startUrl = [str rangeOfString:@"url="];
    NSString *subUrl = [str substringWithRange:NSMakeRange(startUrl.location, str.length - startUrl.location)];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[subUrl substringFromIndex:4]]];
    [self.view addSubview:_webView];
    [_webView release];
    [_webView loadRequest:request];
    _webView.allowsInlineMediaPlayback = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    _webView.scalesPageToFit = YES;
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
