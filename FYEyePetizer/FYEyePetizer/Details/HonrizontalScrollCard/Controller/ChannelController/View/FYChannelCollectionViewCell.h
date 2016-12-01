//
//  FYChannelCollectionViewCell.h
//  FYEyePetizer
//
//  Created by dllo on 16/10/13.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYChannelCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) NSString *channelImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *timeTag;
@property (nonatomic, copy) NSString *brief;
@end
