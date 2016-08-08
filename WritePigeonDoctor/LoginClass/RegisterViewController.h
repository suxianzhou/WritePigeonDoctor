//
//  RegisterViewController.h
//  test3
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "FEBaseLoginController.h"
typedef enum
{
    TypeRegisterPassWord=0,
    
    TypeForgetPassWord
    
}TypePassWord;

@interface RegisterViewController : FEBaseLoginController

@property (nonatomic,assign)TypePassWord typePassWord;

@end
