//
//  FYGuideViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYGuideViewController.h"
#import "FYHomeViewController.h"
#import "FYDiscoveryViewController.h"
#import "FYAuthorPageViewController.h"
#import "FYMineViewController.h"

@interface FYGuideViewController ()
<
UIScrollViewDelegate
>
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@end

@implementation FYGuideViewController

- (void)dealloc {
    [_scrollView release];
    [_pageControl release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor colorWithRed:1.000 green:0.682 blue:0.657 alpha:1.000];
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    self.pageControl = [[UIPageControl alloc] init];
    _pageControl.backgroundColor = [UIColor clearColor];
    CGSize pageSize = [_pageControl sizeForNumberOfPages:3];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.136 green:0.569 blue:1.000 alpha:1.000];
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(- (SCREEN_HEIGHT * 0.07));
        make.width.equalTo(@(pageSize.width));
        make.height.equalTo(@(pageSize.height));
    }];
    [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_pageControl release];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString *imageName = [NSString stringWithFormat:@"引导页%d.png",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [_scrollView addSubview:imageView];
        if (2 == i) {
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [imageView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView.mas_centerX);
                make.bottom.equalTo(imageView).offset(- (SCREEN_HEIGHT * 0.05));
                make.width.equalTo(@(SCREEN_WIDTH * 0.4));
                make.height.equalTo(@(SCREEN_HEIGHT * 0.06));
            }];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5.0f;
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor whiteColor].CGColor];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.hidden = NO;
    _pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    if (SCREEN_WIDTH * 2 == scrollView.contentOffset.x) {
        _pageControl.hidden = YES;
    }
}

- (void)pageControlValueChanged:(UIPageControl *)pageControl {
    _scrollView.contentOffset = CGPointMake(pageControl.currentPage * SCREEN_WIDTH, 0);
    if (2 == _pageControl.currentPage) {
        _pageControl.hidden = YES;
    }
}

- (void)buttonAction:(UIButton *)button {
    self.flag = YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:_flag forKey:@"notFirst"];
    [user synchronize];
    
    [self createTabBarViewController];
}

- (void)createTabBarViewController {
    FYHomeViewController *homeViewController = [[FYHomeViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    
    FYDiscoveryViewController *discoveryViewController = [[FYDiscoveryViewController alloc] init];
    UINavigationController *discoveryNavigationController = [[UINavigationController alloc] initWithRootViewController:discoveryViewController];
    
    FYAuthorPageViewController *authorPageViewController = [[FYAuthorPageViewController alloc] init];
    UINavigationController *authorPageNavigationController = [[UINavigationController alloc] initWithRootViewController:authorPageViewController];
    
    
    FYMineViewController *mineViewController = [[FYMineViewController alloc] init];
    UINavigationController *mineNavigationController = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    
    
    UITabBarController *rootTabBarController = [[UITabBarController alloc] init];
    rootTabBarController.viewControllers = @[homeNavigationController,discoveryNavigationController, authorPageNavigationController,mineNavigationController];
    self.view.window.rootViewController = rootTabBarController;
    
    rootTabBarController.tabBar.tintColor = [UIColor blackColor];
    rootTabBarController.tabBar.translucent = NO;
    
    [homeViewController release];
    [homeNavigationController release];
    
    [discoveryNavigationController release];
    [discoveryViewController release];

    [authorPageViewController release];
    [authorPageNavigationController release];
    
    [mineViewController release];
    [mineNavigationController release];
    
    [rootTabBarController release];
    
    UIImage *homeImage = [UIImage imageNamed:@"三角形1"];
    homeImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedHomeImage = [UIImage imageNamed:@"三角形"];
    selectedHomeImage = [selectedHomeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"精选" image:homeImage selectedImage:selectedHomeImage];
    [homeNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Thonburi" size:12.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    UIImage *discoveryImage = [UIImage imageNamed:@"圆形1"];
    discoveryImage = [discoveryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedDiscoveryImage = [UIImage imageNamed:@"圆形"];
    selectedDiscoveryImage = [selectedDiscoveryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoveryNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:discoveryImage selectedImage:selectedDiscoveryImage];
    [discoveryNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Thonburi" size:12.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    UIImage *authorImage = [UIImage imageNamed:@"方形1"];
    authorImage = [authorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedAuthorImage = [UIImage imageNamed:@"方形"];
    selectedAuthorImage = [selectedAuthorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    authorPageNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"作者" image:authorImage selectedImage:selectedAuthorImage];
    [authorPageNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Thonburi" size:12.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    UIImage *mineImage = [UIImage imageNamed:@"菱形1"];
    mineImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedMineImage = [UIImage imageNamed:@"菱形"];
    selectedMineImage = [selectedMineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:mineImage selectedImage:selectedMineImage];
    [mineNavigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Thonburi" size:12.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
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
