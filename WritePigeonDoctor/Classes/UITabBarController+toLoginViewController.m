//
//  UITabBarController+toLoginViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "UITabBarController+toLoginViewController.h"
#import "LoginViewController.h"
#import "InfoViewController.h"
#import "RWDataBaseManager.h"

@implementation UITabBarController (toLoginViewController)

- (void)toLoginViewController
{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    
    [self presentViewController:loginView animated:YES completion:nil];
}

- (void)toPerfectPersonalInformation
{
    InfoViewController * ifVC=[[InfoViewController alloc]init];
    RWUser * user=[[RWDataBaseManager defaultManager] getDefualtUser];
    ifVC.name=user.name;
    ifVC.age=user.age;
    ifVC.headerImage=user.header;
    ifVC.gender=user.gender;
    [self presentViewController:ifVC animated:YES completion:nil];
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
