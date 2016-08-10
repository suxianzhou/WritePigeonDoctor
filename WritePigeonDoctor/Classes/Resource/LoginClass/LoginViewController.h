//
//  LoginViewController.h
//  LoginTest
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "FEBaseLoginController.h"
typedef void (^LoginCompletion)(id responseObject, NSError *error);
@interface LoginViewController : FEBaseLoginController
@property (nonatomic, copy) LoginCompletion completion;
@end
