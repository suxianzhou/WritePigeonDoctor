//
//  FEBaseLoginController.h
//  LoginTest
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FEBaseLoginController : UIViewController
@property(nonatomic,strong)UIView * backView;
@property(nonatomic,strong)UITableView * viewList;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic ,strong)NSString *facePlaceHolder;


-(void)warningToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title Click:(void(^)(void))click;
@end
