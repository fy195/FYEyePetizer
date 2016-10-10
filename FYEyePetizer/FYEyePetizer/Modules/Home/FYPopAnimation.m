//
//  FYPopAnimation.m
//  FYEyePetizer
//
//  Created by dllo on 16/10/10.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "FYPopAnimation.h"
#import "FYHomeViewController.h"
#import "FYVideoViewController.h"

@implementation FYPopAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    FYVideoViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FYHomeViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVc.view];
    
    toVc.selectedCell.hidden = YES;
    
    UIView *snapView = [fromVC.appearCell snapshotViewAfterScreenUpdates:NO];
    snapView.frame = [fromVC.videoCollectionView convertRect:fromVC.appearCell.frame toView:fromVC.view];
    [containerView addSubview:snapView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapView.frame = [toVc.tableView convertRect:toVc.selectedCell.frame toView:toVc.view];
    } completion:^(BOOL finished) {
        if (finished) {
            toVc.selectedCell.hidden = NO;
            [snapView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
    }];
}

@end
