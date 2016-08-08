//
//  RWRequsetManager+UserLogin.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager+UserLogin.h"
#import "XZUMComPullRequest.h"
#import "RWDataBaseManager.h"
#import <EMSDK.h>

@implementation RWRequsetManager (UserLogin)

- (void)registerWithUsername:(NSString *)username AndPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
    [XZUMComPullRequest userCustomAccountLoginWithName:username
                                              sourceId:username
                                              icon_url:nil
                                                gender:0
                                                   age:20
                                                custom:nil
                                                 score:0
                                            levelTitle:nil
                                                 level:0
                                     contextDictionary:nil
                                          userNameType:userNameDefault
                                        userNameLength:userNameLengthDefault
                                            completion:^(NSDictionary *responseObject, NSError *error)
     {
         if(!error)
         {
             NSDictionary *body = @{@"username":username,
                                    @"password":password};
             
             [self.requestManager POST:__USER_REGISTER__
                            parameters:body
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 
                 NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                 
                 if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
                 {
                     RWUser *user = [[RWUser alloc] init];
                     
                     user.username = username;
                     user.password = password;
                     
                     RWDataBaseManager *baseManager =
                                                [RWDataBaseManager defaultManager];
                     
                     [baseManager addNewUesr:user];
                     
                     [self.delegate userRegisterSuccess:YES
                                        responseMessage:nil];
                 }
                 else
                 {
                     if ([Json objectForKey:@"result"])
                     {
                         [self.delegate userRegisterSuccess:NO
                                            responseMessage:
                                                    [Json objectForKey:@"result"]];
                     }
                     else
                     {
                         [self.delegate userRegisterSuccess:NO
                                            responseMessage:@"注册失败"];
                     }
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
              {
                  [self.delegate userRegisterSuccess:NO
                                     responseMessage:error.description];
              }];
         }
         else
         {
             [self.delegate userRegisterSuccess:NO
                                responseMessage:error.description];
         }
    }];
}

- (void)setUserHeader:(UIImage *)header name:(NSString *)name age:(NSString *)age sex:(NSString *)sex
{
    
}

- (void)userinfoWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    [XZUMComPullRequest userCustomAccountLoginWithName:username
                                              sourceId:username
                                              icon_url:nil
                                                gender:0
                                                   age:20
                                                custom:nil
                                                 score:0
                                            levelTitle:nil
                                                 level:0
                                     contextDictionary:nil
                                          userNameType:userNameDefault
                                        userNameLength:userNameLengthDefault
                                            completion:^(NSDictionary *responseObject, NSError *error)
    {
        if(!error)
        {
            NSDictionary *body = @{@"username":username,
                                   @"password":password};
            
            [self.requestManager POST:__USER_LOGIN__
                           parameters:body
                             progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                 
                 if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
                 {
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 1), ^{
                         
                         EMError *error =
                                [[EMClient sharedClient]loginWithUsername:username
                                                                 password:password];
                         
                         if (!error)
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 RWDataBaseManager *baseManager =
                                                    [RWDataBaseManager defaultManager];
                                 
                                 if (![baseManager existUser:username])
                                 {
                                     RWUser *user = [[RWUser alloc] init];
                                     
                                     user.username = username;
                                     user.password = password;
                                     
                                     [baseManager addNewUesr:user];
                                 }
                                 
                                 [self.delegate userLoginSuccess:YES
                                                 responseMessage:nil];
                             });
                         }
                     });
                 }
                 else
                 {
                     if ([Json objectForKey:@"result"])
                     {
                         [self.delegate userLoginSuccess:NO
                                         responseMessage:
                                                [Json objectForKey:@"result"]];
                     }
                     else
                     {
                         [self.delegate userLoginSuccess:NO
                                         responseMessage:
                                                    [Json objectForKey:@"登录失败"]];
                     }
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 [self.delegate userLoginSuccess:NO
                                 responseMessage:error.description];
             }];
        }
        else
        {
            
            [self.delegate userLoginSuccess:NO
                            responseMessage:error.description];
        }
    }];
}

- (void)replacePasswordWithUsername:(NSString *)username AndPassword:(NSString *)password verificationCode:(NSString *)verificationCode
{
//    NSDictionary *body = @{@"username":username,
//                           @"password":password,
//                           @"yzm":verificationCode};
    
//    [self.manager POST:REPLACE_PASSWORD_URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
//        {
//            [self.delegate replacePasswordResponds:YES ErrorReason:nil];
//        }
//        else
//        {
//            [self.delegate replacePasswordResponds:NO ErrorReason:
//                                                        [Json objectForKey:@"result"]];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        [self.delegate requestError:error Task:task];
//    }];
}

- (void)obtainVerificationWithPhoneNunber:(NSString *)phoneNumber result:(void(^)(BOOL succeed,NSString *reason))result
{
//    NSString *UUID =  [UIDevice currentDevice].identifierForVendor.UUIDString;
//    
//    NSDictionary *body = @{@"username":phoneNumber,@"did":UUID};
//    
//    [self.manager POST:VERIFICATION_PHONENUMBER parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         
//        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        if ([[Json objectForKey:@"code"] integerValue] == 200)
//        {
//            result(YES,nil);
//        }
//        else
//        {
//            NSString *errorCode =
//                        [NSString stringWithFormat:@"%@",[Json objectForKey:@"code"]];
//            
//            NSString *description = [self.errorDescription objectForKey:errorCode];
//            
//            if (description)
//            {
//                result(NO,description);
//            }
//            else
//            {
//                result(NO,@"验证码获取失败");
//            }
//        }
//        
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         
//         result(NO,error.description);
//     }];
}

- (BOOL)verificationPhoneNumber:(NSString *)phoneNumber
{
    NSString *mobile = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    
    NSPredicate *regexTestMobile =
                        [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    
    return [regexTestMobile evaluateWithObject:phoneNumber];
}

- (BOOL)verificationPassword:(NSString *)password
{
    return password.length >= 6 && password.length <= 18 ? YES : NO;
}

- (BOOL)verificationEmail:(NSString *)Email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:Email];
}

@end
