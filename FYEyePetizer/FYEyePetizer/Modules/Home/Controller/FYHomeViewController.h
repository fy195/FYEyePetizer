//
//  FYHomeViewController.h
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYBaseViewController.h"
#import "FYFeedSectionCell.h"

@interface FYHomeViewController : FYBaseViewController
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FYFeedSectionCell *selectedCell;
@end
