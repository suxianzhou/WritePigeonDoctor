//
//  RWWPDBaseController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWPDBaseController.h"

@interface RWWPDBaseController ()

@end

@implementation RWWPDBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __DEFAULT_NAVIGATION_BAR__;
    __NAVIGATION_DEUAULT_SETTINGS__;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushNextWithViewcontroller:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:NO];
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

@end
