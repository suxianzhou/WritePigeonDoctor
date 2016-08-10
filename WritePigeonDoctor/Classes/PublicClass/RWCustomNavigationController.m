//
//  RWCustomNavigationController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCustomNavigationController.h"

@interface RWCustomNavigationController ()

@end

@implementation RWCustomNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CATransition *transition = [CATransition animation];
    transition.type = @"suckEffect";
    transition.subtype = @"fromLeft";
    transition.duration = 1;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self addAnimation];
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addAnimation];
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self addAnimation];
    
    return [super popToRootViewControllerAnimated:animated];
}

- (void)addAnimation
{
    // pop 动画
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [self addWaterAnimation];
    
    [super presentViewController:viewControllerToPresent
                        animated:flag
                      completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [self addWaterAnimation];
    
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)addWaterAnimation
{
    CATransition *transition = [CATransition animation];
    
    transition.type = @"rippleEffect";
    
    transition.subtype = @"fromLeft";
    
    transition.duration = 1;
    
    [self.view.layer addAnimation:transition forKey:nil];
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
