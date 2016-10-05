//
//  FYDiscoveryViewController.m
//  FYEyePetizer
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYDiscoveryViewController.h"
#import "FYDisData.h"
#import "FYHomeItemList.h"
#import "FYHomeItemData.h"
#import "FYHorizontalCardCollectionViewCell.h"
#import "FYImageCollectionViewCell.h"
#import "FYTagCollectionViewCell.h"

static NSString *const horizontalCell = @"horizontalCell";
static NSString *const imageCell = @"imageCell";
static NSString *const tagCell = @"tagCell";
@interface FYDiscoveryViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) FYDisData *AllData;
@end

@implementation FYDiscoveryViewController
- (void)dealloc {
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Eyepetizer";
    self.navigationItem.titleView = titleLabel;
    
    [self getData];
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://baobab.wandoujia.com/api/v3/discovery?_s=f8de34d32e8db0f6f4310967e800fb5e&f=iphone&net=wifi&p_product=EYEPETIZER_IOS&u=227c329b8529f03c7ec60f7bba44edcfe0b12021&v=2.7.0&vc=1305";
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.AllData = [FYDisData modelWithDic:responseObject];
        [self createView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
    }];
    [manager.requestSerializer setValue:@"baobab.wandoujia.com" forHTTPHeaderField:@"Host"];

}

- (void)createView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[FYHorizontalCardCollectionViewCell class] forCellWithReuseIdentifier:horizontalCell];
    [_collectionView registerClass:[FYImageCollectionViewCell class] forCellWithReuseIdentifier:imageCell];
    [_collectionView registerClass:[FYTagCollectionViewCell class] forCellWithReuseIdentifier:tagCell];
    [_collectionView release];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _AllData.itemList[indexPath.item];
    if ([itemList.type isEqualToString:@"horizontalScrollCard"] ) {
        return CGSizeMake(SCREEN_WIDTH, 200);
    }else if ([itemList.type isEqualToString:@"rectangleCard"]) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 2 - 2.5f);
    }
    return CGSizeMake(SCREEN_WIDTH / 2 - 2.5f, SCREEN_WIDTH / 2 - 2.5f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _AllData.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYHomeItemList *itemList = _AllData.itemList[indexPath.item];
    FYHomeItemData *itemData = itemList.data;
    if ([itemList.type isEqualToString:@"horizontalScrollCard"]) {
        FYHorizontalCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:horizontalCell forIndexPath:indexPath];
        cell.data = itemList.data;
        return cell;
    }else if ([itemList.type isEqualToString:@"squareCard"]) {
        if ([itemData.title isEqualToString:@""]) {
            FYImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCell forIndexPath:indexPath];
            cell.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemData.image]]];
            return cell;
        }else {
            FYTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tagCell forIndexPath:indexPath];
            cell.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemData.image]]];
            cell.itemTag = itemData.title;
            return  cell;
        }
    }
    FYImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCell forIndexPath:indexPath];
    cell.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemData.image]]];
    return cell;
    
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
