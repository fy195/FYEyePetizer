//
//  FYPlayViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/10.
//  Copyright © 2016年 dllo. All rights reserved.
//
#import "FYPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MBProgressHUD.h>
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYPlayerView.h"
typedef NS_ENUM(NSInteger, BoardType) {
    BoardHidden,
    BoardNoHidden
};

@interface FYPlayViewController ()
@property (nonatomic, assign) BoardType boardType;
@property (nonatomic, retain) MBProgressHUD *hud;

@property (nonatomic, retain) AVPlayerViewController *playerVC;

@end

@implementation FYPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)setPlayArray:(NSMutableArray *)playArray {
    if (_playArray != playArray) {
        [_playArray release];
        _playArray = [playArray retain];
    }
}

- (void)setIndex:(NSInteger)index {
    if (_index != index) {
        _index = index;
    }
//    FYHomeItemList *itemList = _playArray[_index];
//    FYHomeItemData *itemData = itemList.data;
    
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
