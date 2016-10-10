
//
//  FYPushAnimation.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/10.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYPushAnimation.h"
#import "FYHomeViewController.h"
#import "FYVideoViewController.h"

@implementation FYPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    FYHomeViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FYVideoViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    toVC.appearCell.hidden = YES;
    
    UIView *snapView = [fromVC.selectedCell snapshotViewAfterScreenUpdates:NO];
    snapView.frame = [fromVC.tableView convertRect:fromVC.selectedCell.frame toView:fromVC.view];
    [containerView addSubview:snapView];
    toVC.view.frame = snapView.frame;
    NSLog(@"tovc.frame %f   %f", toVC.view.height, toVC.view.width);
    
    [UIView animateWithDuration:5.0f delay:0.f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        snapView.frame = toVC.appearCell.frame;
        snapView.frame = [toVC.videoCollectionView convertRect:toVC.appearCell.frame toView:toVC.view];
        toVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            toVC.appearCell.hidden = NO;
            [snapView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
