//
//  InfoViewController.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/3.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "FEBaseLoginController.h"

@interface InfoViewController : FEBaseLoginController


@property(nonatomic,copy)NSString * phoneNumber;

@property(nonatomic,copy)NSString * passWord;

@property(nonatomic,strong)NSData * headerImage;

@property(nonatomic,copy)NSString * name;

@property(nonatomic,copy)NSString *age;

@property(nonatomic,copy)NSString * gender;

@end
