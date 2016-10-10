//
//  FYPlayerView.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/10.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYPlayerView.h"

@implementation FYPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
