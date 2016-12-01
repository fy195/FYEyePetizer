//
//  AppDelegate.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "AppDelegate.h"
#import "FYGuideViewController.h"
#import "FYHomeViewController.h"
#import "FYDiscoveryViewController.h"
#import "FYAuthorPageViewController.h"
#import "FYMineViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    [_window release];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user boolForKey:@"notFirst"]) {
        self.window.rootViewController = [[FYGuideViewController alloc] init];
    }else {
        [self createTabBar];
    }
    return YES;
}

- (void)createTabBar{
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
    self.window.rootViewController = rootTabBarController;
    
    rootTabBarController.tabBar.tintColor = [UIColor blackColor];
    rootTabBarController.tabBar.translucent = NO;
    
    [homeViewController release];
    [homeNavigationController release];
    
    [discoveryViewController release];
    [discoveryNavigationController release];
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
