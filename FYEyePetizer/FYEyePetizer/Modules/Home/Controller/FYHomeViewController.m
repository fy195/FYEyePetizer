//
//  FYHomeViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYHomeViewController.h"
#import "FYHomeData.h"
#import "FYHomeSectionList.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYFeedSectionCell.h"
#import "FYHomeTags.h"
#import "FYTextHeaderTableViewCell.h"
#import "NSString+FYTime.h"
#import "FYBannerTableViewCell.h"
#import "FYFooterTableViewCell.h"
#import "FYLightTopicSectionCell.h"
#import "FYCategorySectionCell.h"
#import "FYAuthorSectionTableViewCell.h"
#import "NSString+FY_MD5.h"
#import "FYDailyViewController.h"
#import "FYLightTopicViewController.h"
#import "FYRankingViewController.h"
#import "FYTagViewController.h"
#import "FYCategoryViewController.h"
#import "FYAuthorViewController.h"
#import "FYVideoViewController.h"
#import "FYHonriZontalViewController.h"

@interface FYHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
FYLightTopicHeaderDelegate,
FYCategoryCellDelegate,
FYAuthorCellDelegete
>

@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIImageView *headerView;
@property (nonatomic, retain) UIButton *headerButton;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) FYHomeData *homeData;
@property (nonatomic, retain) FYHomeSectionList *sectionList;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *next;
@property (nonatomic, retain)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation FYHomeViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_activityIndicatorView release];
    [_timeLabel release];
    [_headerView release];
    [_tableView release];
    [_backView release];
    [_headerButton release];
    [_dataArray release];
    [_next release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    self.dataArray = [NSMutableArray array];
    [self data];
}

- (void)createView {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self.view addSubview:_tableView];
    [_tableView release];
    
    // 顶部视图
    self.headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_header"]];
    [self.view addSubview:_headerView];
    _headerView.userInteractionEnabled = YES;
    _headerView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 200);
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView release];
    
    // 时间Label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:17];
    _timeLabel.numberOfLines = 0;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [_timeLabel sizeToFit];
    _timeLabel.center = CGPointMake(SCREEN_WIDTH / 2, 40);
    [_headerView addSubview:_timeLabel];
    
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_headerView addSubview:_backView];
    [_backView release];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.center = _headerView.center;
    _backView.layer.borderWidth = 2.0f;
    _backView.layer.borderColor = [UIColor whiteColor].CGColor;
    _backView.clipsToBounds = YES;
    _backView.layer.cornerRadius = 50.0f;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_backView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"EyePetizer";
    titleLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(0);
        make.left.equalTo(_backView).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [titleLabel release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"每日精选";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView).offset(0);
        make.bottom.equalTo(_backView).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [label release];
    
    
    self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:_headerButton];
    [_headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(0);
        make.left.equalTo(_backView).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    _headerButton.backgroundColor = [UIColor clearColor];
    [_headerButton addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

// 网络请求
- (void)data {
    self.isRefresh = NO;
    NSDate *datenow =[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/tabs/selected?_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.homeData = [FYHomeData modelWithDic:responseObject];
        self.next = _homeData.nextPageUrl;
        [_dataArray addObjectsFromArray:_homeData.sectionList];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FYHomeSectionList *sectionList = _dataArray[section];
    return sectionList.itemList.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeSectionList *sectionList = _dataArray[indexPath.section];
    // 根据sectionList的type给cell不同的高度
    if ([sectionList.type isEqualToString:@"feedSection"] || [sectionList.type isEqualToString:@"recommendSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            if ([itemData.dataType isEqualToString:@"TextHeader"]) {
                return 50;
            }else {
                return 200;
            }
        }
        NSString *type = [sectionList.footer objectForKey:@"type"];
        if ([type isEqualToString:@"forwardFooter"]) {
            return 53;
        }else if ([type isEqualToString:@"blankFooter"]) {
            return 3;
        }
    }else if ([sectionList.type isEqualToString:@"lightTopicSection"] || [sectionList.type isEqualToString:@"rankListSection"] || [sectionList.type isEqualToString:@"authorSection"] || [sectionList.type isEqualToString:@"tagSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            return 480;
        }
        NSString *type = [sectionList.footer objectForKey:@"type"];
        if ([type isEqualToString:@"forwardFooter"]) {
            return 53;
        }else if ([type isEqualToString:@"blankFooter"]) {
            return 3;
        }
    }else if ([sectionList.type isEqualToString:@"categorySection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            return 400;
        }
        NSString *type = [sectionList.footer objectForKey:@"type"];
        if ([type isEqualToString:@"forwardFooter"]) {
            return 53;
        }else if ([type isEqualToString:@"blankFooter"]) {
            return 3;
        }
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeSectionList *sectionList = _dataArray[indexPath.section];
    if ([sectionList.type isEqualToString:@"feedSection"] || [sectionList.type isEqualToString:@"recommendSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            // textHeader类型
            if ([itemData.dataType isEqualToString:@"TextHeader"]) {
                static NSString *const textHeaderCell = @"textHeaderCell";
                FYTextHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textHeaderCell];
                if (nil == cell) {
                    cell = [[FYTextHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textHeaderCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = itemData.text;
                return cell;
            }else if ([itemList.type isEqualToString:@"video"]){
            // feedSection类型
                static NSString *const feedCell = @"feedCell";
                FYFeedSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:feedCell];
                if (nil == cell) {
                    cell = [[[FYFeedSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feedCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.image = [itemData.cover objectForKey:@"feed"];
                cell.title = itemData.title;
                NSString *time = [NSString stringChangeWithTimeFormat:itemData.duration];
                cell.text = [NSString stringWithFormat:@"#%@ / %@", itemData.category, time];
                return  cell;
            }else if ([itemList.type isEqualToString:@"banner1"]){
            // banner类型
                static NSString *const bannerCell = @"bannerCell";
                FYBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerCell];
                if (nil == cell) {
                    cell = [[FYBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemData.image]]];
                return  cell;
            }
        }else if (indexPath.row >= sectionList.itemList.count) {
        // 当有尾视图时，将尾视图设置成cell
            NSString *type = [sectionList.footer objectForKey:@"type"];
            NSDictionary *data = [sectionList.footer objectForKey:@"data"];
            if ([type isEqualToString:@"forwardFooter"]) {
                static NSString *const footerCell = @"footerCell";
                FYFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCell];
                if (nil == cell) {
                    cell = [[[FYFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = [NSString stringWithFormat:@"%@  >", [data objectForKey:@"text"]];
                return cell;
            }else if ([type isEqualToString:@"blankFooter"]) {
                static NSString *const blankCell = @"blankCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
                return cell;
            }
        }
    }
    // lightTop类型
    if ([sectionList.type isEqualToString:@"lightTopicSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            static NSString *const lightTopicCell = @"lightTopicCell";
            FYLightTopicSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:lightTopicCell];
            if (nil == cell) {
                cell = [[[FYLightTopicSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lightTopicCell] autorelease];
            }
            cell.tapDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.topicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.header objectForKey:@"cover"]]]];
            cell.itemData = itemData;
            cell.sectionList = sectionList;
            return cell;
        }else {
            NSString *type = [sectionList.footer objectForKey:@"type"];
            NSDictionary *data = [sectionList.footer objectForKey:@"data"];
            if ([type isEqualToString:@"forwordFooter"]) {
                static NSString *const footerCell = @"footerCell";
                FYFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCell];
                if (nil == cell) {
                    cell = [[[FYFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = [NSString stringWithFormat:@"%@  >", [data objectForKey:@"text"]];
                return cell;
            }else if ([type isEqualToString:@"blankFooter"]) {
                static NSString *const blankCell = @"blankCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
                return cell;
            }
        }
    }
    // ranking 类型
    if ([sectionList.type isEqualToString:@"rankListSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            static NSString *const rankingListCell = @"rankingListCell";
            FYLightTopicSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:rankingListCell];
            if (nil == cell) {
                cell = [[[FYLightTopicSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rankingListCell] autorelease];
            }
            cell.tapDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.topicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.header objectForKey:@"cover"]]]];
            cell.sectionList = sectionList;
            cell.itemData = itemData;
            return cell;
        }else {
            NSString *type = [sectionList.footer objectForKey:@"type"];
            NSDictionary *data = [sectionList.footer objectForKey:@"data"];
            if ([type isEqualToString:@"forwordFooter"]) {
                static NSString *const footerCell = @"footerCell";
                FYFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCell];
                if (nil == cell) {
                    cell = [[[FYFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = [NSString stringWithFormat:@"%@  >", [data objectForKey:@"text"]];
                return cell;
            }else if ([type isEqualToString:@"blankFooter"]) {
                static NSString *const blankCell = @"blankCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
                return cell;
            }
        }
    }
    if ([sectionList.type isEqualToString:@"tagSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            static NSString *const tagCell = @"tagCell";
            FYLightTopicSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCell];
            if (nil == cell) {
                cell = [[[FYLightTopicSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagCell] autorelease];
            }
            cell.tapDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.topicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.header objectForKey:@"cover"]]]];
            cell.itemData = itemData;
            cell.sectionList = sectionList;
            return cell;
        }else {
            NSString *type = [sectionList.footer objectForKey:@"type"];
            NSDictionary *data = [sectionList.footer objectForKey:@"data"];
            if ([type isEqualToString:@"forwordFooter"]) {
                static NSString *const footerCell = @"footerCell";
                FYFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCell];
                if (nil == cell) {
                    cell = [[[FYFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = [NSString stringWithFormat:@"%@  >", [data objectForKey:@"text"]];
                return cell;
            }else if ([type isEqualToString:@"blankFooter"]) {
                static NSString *const blankCell = @"blankCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
                return cell;
            }
        }
    }
    if ([sectionList.type isEqualToString:@"categorySection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            static NSString *const catogeryCell = @"categoryCell";
            FYCategorySectionCell *cell = [tableView dequeueReusableCellWithIdentifier:catogeryCell];
            if (nil == cell) {
                cell = [[[FYCategorySectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:catogeryCell] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.itemData = itemData;
            cell.title = [itemData.header objectForKey:@"title"];
            cell.subtitle = [itemData.header objectForKey:@"subTitle"];
            cell.categoryDelegate = self;
            return cell;
        }else {
            NSString *type = [sectionList.footer objectForKey:@"type"];
            NSDictionary *data = [sectionList.footer objectForKey:@"data"];
            if ([type isEqualToString:@"forwordFooter"]) {
                static NSString *const footerCell = @"footerCell";
                FYFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCell];
                if (nil == cell) {
                    cell = [[[FYFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = [NSString stringWithFormat:@"%@  >", [data objectForKey:@"text"]];
                return cell;
            }else if ([type isEqualToString:@"blankFooter"]) {
                static NSString *const blankCell = @"blankCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
                return cell;
            }
        }
    }
    if ([sectionList.type isEqualToString:@"authorSection"]) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            FYHomeItemData *itemData = itemList.data;
            static NSString *const authorCell = @"authorCell";
            FYAuthorSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:authorCell];
            if (nil == cell) {
                cell = [[[FYAuthorSectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:authorCell] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.topicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.header objectForKey:@"cover"]]]];
            cell.itemData = itemData;
            cell.iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemData.header objectForKey:@"icon"]]]];
            cell.title = [itemData.header objectForKey:@"title"];
            cell.authorDes = [itemData.header objectForKey:@"description"];
            cell.authorDelegate = self;
            return cell;
        }else {
            NSString *type = [sectionList.footer objectForKey:@"type"];
            NSDictionary *data = [sectionList.footer objectForKey:@"data"];
            if ([type isEqualToString:@"forwordFooter"]) {
                static NSString *const footerCell = @"footerCell";
                FYFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCell];
                if (nil == cell) {
                    cell = [[[FYFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerCell] autorelease];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.text = [NSString stringWithFormat:@"%@  >", [data objectForKey:@"text"]];
                return cell;
            }else if ([type isEqualToString:@"blankFooter"]) {
                static NSString *const blankCell = @"blankCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
                return cell;
            }
        }
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeSectionList *sectionList = _dataArray[indexPath.section];
    if ([sectionList.type isEqualToString:@"feedSection"] ) {
        if (indexPath.row < sectionList.itemList.count) {
            FYHomeItemList *itemList = sectionList.itemList[indexPath.row];
            if ([itemList.type isEqualToString:@"video"]){
                FYHomeItemData *itemData = itemList.data;
            if (![itemData.dataType isEqualToString:@"TextHeader"]) {
                FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
                if (videoViewController.videoArray.count > 0) {
                    [videoViewController.videoArray removeAllObjects];
                }
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:sectionList.itemList];
                NSArray *listArray = [NSArray arrayWithArray:array];
                
                for (FYHomeItemList *list in listArray) {
                    NSInteger index = 0;
                    if ([list.type isEqualToString:@"textHeader"]) {
                        index = [array indexOfObject:list];
                        [array removeObjectAtIndex:index];
                    }
                    if ([list.type isEqualToString:@"banner1"]) {
                        index = [array indexOfObject:list];
                        [array removeObjectAtIndex:index];
                    }
                }
                videoViewController.videoArray = [array mutableCopy];
                videoViewController.videoIndex = indexPath.row;
                videoViewController.hidesBottomBarWhenPushed = YES;
                [videoViewController setModalTransitionStyle:2];
                [self presentViewController:videoViewController animated:YES completion:nil];
                [videoViewController release];
            }
            }else {
                FYHonriZontalViewController *honrizontalViewController = [[FYHonriZontalViewController alloc] init];
                honrizontalViewController.bannerId = itemList.data.dataId;
                honrizontalViewController.actionUrl = itemList.data.actionUrl;
                honrizontalViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:honrizontalViewController animated:YES];
                [honrizontalViewController release];
            }
        }else {
            NSString *type = [sectionList.footer objectForKey:@"type"];
            if ([type isEqualToString:@"forwardFooter"]) {
                FYDailyViewController *dailyViewController = [[FYDailyViewController alloc] init];
                dailyViewController.hidesBottomBarWhenPushed = YES;
                dailyViewController.date = _homeData.date;
                [self.navigationController pushViewController:dailyViewController animated:YES];
                [dailyViewController release];
            }
        }
    }else {
        FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
        if (videoViewController.videoArray.count > 0) {
            [videoViewController.videoArray removeAllObjects];
        }
        videoViewController.videoArray = [sectionList.itemList mutableCopy];
        videoViewController.videoIndex = indexPath.row;
        videoViewController.hidesBottomBarWhenPushed = YES;
        [videoViewController setModalTransitionStyle:2];
        [self presentViewController:videoViewController animated:YES completion:nil];
        [videoViewController release];
    }
    
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        if (scrollView.contentOffset.y <= -200) {
            // 将headerView置于最前
            [self.view bringSubviewToFront:_headerView];
            CGRect frame = _headerView.frame;
            frame.origin.y = 0;
            frame.size.height = 220 +(-200 - scrollView.contentOffset.y);
            _headerView.frame = frame;
            _backView.center = _headerView.center;
        }else if (scrollView.contentOffset.y > -200){
            // 将headerView至于最后
            [self.view sendSubviewToBack:_headerView];
            CGFloat alpha = (scrollView.contentOffset.y + 200) / 300;
            _tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
            if (scrollView.contentOffset.y > 0) {
                _tableView.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        if (scrollView.contentOffset.y == -200) {
            _isRefresh = YES;
            self.activityIndicatorView  = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            _activityIndicatorView.center = CGPointMake(SCREEN_WIDTH / 2, _headerView.y + _headerView.height - 20);
            _activityIndicatorView.backgroundColor = [UIColor clearColor];
            _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [_headerView addSubview:_activityIndicatorView];
            [_activityIndicatorView release];
        }
        [_activityIndicatorView startAnimating];
        [self Refreshing];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _dataArray.count - 2) {
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(Loading)];
    }
}

#pragma mark - 刷新加载
- (void)Loading{
    if (!_isRefresh) {
        NSDate *datenow =[NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:datenow];
        NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        NSString *timeString = [NSString stringWithFormat:@"&_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", _next, timeString];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            FYHomeData *data = [FYHomeData modelWithDic:responseObject];
            [_dataArray addObjectsFromArray:data.sectionList];
            _next = data.nextPageUrl;
            [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Lobster 1.4" size:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"- The End -";
            _tableView.tableFooterView = label;
        }];
        [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
    }
}

- (void)Refreshing {
    if (_isRefresh) {
        NSDate *datenow =[NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:datenow];
        NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *urlString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v3/tabs/selected?_s=%@&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305", [timeStamp fy_stringByMD5Bit32]];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.homeData = [FYHomeData modelWithDic:responseObject];
            if (_dataArray.count > 0) {
                [_dataArray removeAllObjects];
            }
            self.next = _homeData.nextPageUrl;
            [_dataArray addObjectsFromArray:_homeData.sectionList];
            [_tableView reloadData];
            [_activityIndicatorView stopAnimating];
            [_activityIndicatorView removeFromSuperview];
            UILabel *endLabel = [self.view viewWithTag:1002];
            if (endLabel != nil) {
                [endLabel removeFromSuperview];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_activityIndicatorView stopAnimating];
                [_activityIndicatorView removeFromSuperview];
            }completion:nil];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH,40)];
            label.tag = 1002;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"网络链接失败";
            label.textColor = [UIColor colorWithWhite:0.421 alpha:1.000];
            label.font = [UIFont fontWithName:@"Thonburi-Bold" size:17];
            [self.view addSubview:label];
        }];
        [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];
    }
    _isRefresh = NO;
}

#pragma mark - Button点击
- (void)headerButtonAction:(UIButton *)sender {
    FYDailyViewController *dailyViewController = [[FYDailyViewController alloc] init];
    dailyViewController.hidesBottomBarWhenPushed = YES;
    dailyViewController.date = _homeData.date;
    [self.navigationController pushViewController:dailyViewController animated:YES];
    [dailyViewController release];
}

#pragma mark - 代理方法
- (void)getPgcArray:(NSArray *)videoArray {
    FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
    if (videoViewController.videoArray.count > 0) {
        [videoViewController.videoArray removeAllObjects];
    }
    videoViewController.videoArray = [videoArray mutableCopy];
    videoViewController.videoIndex = 0;
    videoViewController.hidesBottomBarWhenPushed = YES;
    [videoViewController setModalTransitionStyle:2];
    [self presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController release];
}

- (void)getCategoryArray:(NSArray *)videoArray WithIndex:(NSInteger)index {
    FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
    if (videoViewController.videoArray.count > 0) {
        [videoViewController.videoArray removeAllObjects];
    }
    videoViewController.videoArray = [videoArray mutableCopy];
    videoViewController.videoIndex = index;
    videoViewController.hidesBottomBarWhenPushed = YES;
    [videoViewController setModalTransitionStyle:2];
    [self presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController release];
}

- (void)getCurrentImageId:(NSNumber *)imageId actionUrl:(NSString *)actionUrl {
    NSString *str = [actionUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange start = [str rangeOfString:@"tag"];
    if (0 == [imageId integerValue]) {
        FYRankingViewController *rankViewController = [[FYRankingViewController alloc] init];
        rankViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rankViewController animated:YES];
        [rankViewController release];
    }else if (start.length != 0){
        FYTagViewController *tagViewController = [[FYTagViewController alloc] init];
        tagViewController.actionUrl = actionUrl;
        tagViewController.imageId = imageId;
        tagViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tagViewController animated:YES];
        [tagViewController release];
    }else {
        FYLightTopicViewController *lightTopicViewController = [[FYLightTopicViewController alloc] init];
        lightTopicViewController.imageId = imageId;
        lightTopicViewController.actionUrl = actionUrl;
        lightTopicViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lightTopicViewController animated:YES];
        [lightTopicViewController release];
    }

}

- (void)getArrayFromCell:(NSArray *)videoArray {
    FYVideoViewController *videoViewController = [[FYVideoViewController alloc] init];
    if (videoViewController.videoArray.count > 0) {
        [videoViewController.videoArray removeAllObjects];
    }
    videoViewController.videoArray = [videoArray mutableCopy];
    videoViewController.videoIndex = 0;
    videoViewController.hidesBottomBarWhenPushed = YES;
    [videoViewController setModalTransitionStyle:2];
    [self presentViewController:videoViewController animated:YES completion:nil];
    [videoViewController release];
}

- (void)getPgcId:(NSNumber *)pgcId {
    FYAuthorViewController *authorViewController = [[FYAuthorViewController alloc] init];
    authorViewController.pgcId = pgcId;
    authorViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorViewController animated:YES];
    [authorViewController release];
}

- (void)getCategoryId:(NSNumber *)categoryId actionUrl:(NSString *)actionUrl{
    FYCategoryViewController *categoryViewController = [[FYCategoryViewController alloc] init];
    categoryViewController.categoryId = categoryId;
    categoryViewController.actionUrl = actionUrl;
    categoryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryViewController animated:YES];
    [categoryViewController release];
}

- (void)getInfoFromTouchImage:(NSNumber *)imageId sectionListType:(NSString *)type actionUrl:(NSString *)actionUrl{
    if ([type isEqualToString:@"lightTopicSection"]) {
        FYLightTopicViewController *lightTopicViewController = [[FYLightTopicViewController alloc] init];
        lightTopicViewController.imageId = imageId;
        lightTopicViewController.actionUrl = actionUrl;
        lightTopicViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lightTopicViewController animated:YES];
        [lightTopicViewController release];
        return;
    }
    if ([type isEqualToString:@"rankListSection"]) {
        FYRankingViewController *rankingViewController = [[FYRankingViewController alloc] init];
        rankingViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rankingViewController animated:YES];
        [rankingViewController release];
        return;
    }
    if ([type isEqualToString:@"tagSection"]) {
        FYTagViewController *tagViewController = [[FYTagViewController alloc] init];
        tagViewController.hidesBottomBarWhenPushed = YES;
        tagViewController.imageId = imageId;
        tagViewController.actionUrl = actionUrl;
        [self.navigationController pushViewController:tagViewController animated:YES];
        [tagViewController release];
    }
    
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
