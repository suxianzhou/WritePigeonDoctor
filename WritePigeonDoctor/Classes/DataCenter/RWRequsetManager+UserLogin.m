
//
//  RWRequsetManager+UserLogin.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager+UserLogin.h"
#import "XZUMComPullRequest.h"
#import "UMComUser.h"
#import "UMComSession.h"
#import "UMComImageUrl.h"
#import "UMComMacroConfig.h"
#import "RWDataBaseManager.h"
#import "RWChatManager.h"

RWGender getGenderIdentifier(NSString *gender)
{
    return [gender isEqualToString:@"男"]?RWGenderIsMan:RWGenderIsWoman;
}

NSString *getGender(RWGender gender)
{
    return gender?@"男":@"女";
}

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
             UMComUser *umuser = responseObject[UMComModelDataKey];
             
             NSDictionary *body = @{@"username":username,
                                    @"password":password,
                                    @"udid":__TOKEN_KEY__,
                                    @"yzm":verificationCode,
                                    @"umid":umuser.uid};
             
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
                      user.umid = umuser.uid;
                      
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

- (void)setUserHeader:(UIImage *)header
                 name:(NSString *)name
                  age:(NSString *)age
                  sex:(NSString *)sex
           completion:(void(^)(BOOL success,NSString *errorReason))completion
{
    RWDataBaseManager *baseManager = [RWDataBaseManager defaultManager];
    
    RWUser *user = [baseManager getDefualtUser];
    
    user.header =   UIImagePNGRepresentation(header)?
                    UIImagePNGRepresentation(header):
                    UIImageJPEGRepresentation(header,1.0);
    user.name = name;
    user.age = age;
    user.gender = sex;
    
    [XZUMComPullRequest updateProfileWithName:user.name
                                          age:@(age.integerValue)
                                       gender:@(getGenderIdentifier(user.gender))
                                       custom:nil
                                 userNameType:userNameDefault
                               userNameLength:userNameLengthDefault
                                   completion:^(NSDictionary *responseObject, NSError *error)
     {
         if (!error)
         {
             [XZUMComPullRequest userUpdateAvatarWithImage:header completion:^(NSDictionary *responseObject, NSError *error) {
                 
                 if (!error)
                 {
                     [self.requestManager POST:__USER_INFORMATION__
                                    parameters:@{@"username":user.username,@"age":age}
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                      {
                          
                          NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                          
                          if (Json)
                          {
                              MESSAGE(@"%@",Json);
                          }
                                           
                         
                         if ([baseManager updateUesr:user])
                         {
                             if (completion)
                             {
                                 completion(YES,nil);
                             }
                         }
                         else
                         {
                             if (completion)
                             {
                                 completion(NO,@"本地保存失败");
                             }
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                         completion(NO,[NSString stringWithFormat:@"上传失败!\n原因：%@",
                                        error.description]);
                     }];
                 }
                 else
                 {
                     if (completion)
                     {
                         completion(NO,[NSString stringWithFormat:@"上传失败!\n原因：%@",
                                        error.description]);
                     }
                 }
             }];
         }
         else
         {
             if (completion)
             {
                 completion(NO,[NSString stringWithFormat:@"上传失败!\n原因：%@",
                                error.description]);
             }
         }
     }];
}

- (void)userinfoWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    [XZUMComPullRequest userCustomAccountLoginWithName:username
                                              sourceId:username
                                              icon_url:nil
                                                gender:0
                                                   age:0
                                                custom:nil
                                                 score:0
                                            levelTitle:nil
                                                 level:0
                                     contextDictionary:nil
                                          userNameType:userNameDefault
                                        userNameLength:userNameLengthDefault
                                            completion:^(NSDictionary *responseObject, NSError *error)
     {
         NSDictionary *UMResponse = responseObject;
         
         if(!error)
         {
             NSDictionary *body = @{@"username":username,
                                    @"password":password,
                                    @"udid":__TOKEN_KEY__};
             
             [self.requestManager POST:__USER_LOGIN__
                            parameters:body
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
              {
                  NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                  
                  if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
                  {
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                          
                          EMError *error =
                          [[EMClient sharedClient]loginWithUsername:username
                                                           password:password];
                          
                          if (!error)
                          {
                              UMComUser *user = UMResponse[UMComModelDataKey];
                              
                              if (user)
                              {
                                  [UMComSession sharedInstance].loginUser = user;
                                  [UMComSession sharedInstance].token = UMResponse[UMComTokenKey];
                                  
                                  [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSucceedNotification object:nil];
                              }
                              
                              UMComImageUrl * imageUrl = (UMComImageUrl *)user.icon_url;
                              
                              NSString * small = imageUrl.small_url_string;
                              NSURL *imageURL = [NSURL URLWithString:small];
                              
                              NSData *imageData=[NSData dataWithContentsOfURL:imageURL];
                              
                              RWDataBaseManager *baseManager =
                                                    [RWDataBaseManager defaultManager];
                              
                              if (![baseManager existUser:username])
                              {
                                  RWUser *us = [[RWUser alloc] init];
                                  
                                  us.username = username;
                                  us.password = password;
                                  us.umid = Json[@"result"][@"umid"];
                                  us.age = user.age.stringValue;
                                  us.name = user.name;
                                  us.gender = getGender(user.gender.integerValue);
                                  us.header = imageData;
                                  
                                  if (![baseManager addNewUesr:us])
                                  {
                                      MESSAGE(@"用户信息储存失败");
                                  }
                              }
                              else
                              {
                                  RWUser *us = [baseManager getUser:username];
                                  
                                  if (!us.defaultUser)
                                  {
                                      us.defaultUser = YES;
                                  }
                                  
                                  us.username = username;
                                  us.password = password;
                                  us.umid = Json[@"result"][@"umid"];
                                  us.age = user.age.stringValue;
                                  us.name = user.name;
                                  us.gender = getGender(user.gender.integerValue);
                                  us.header = imageData;
 
                                  if (![baseManager updateUesr:us])
                                  {
                                      MESSAGE(@"用户信息储存失败");
                                  }
                              }

                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
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
    NSDictionary *body = @{@"username":username,
                           @"password":password,
                           @"yzm":verificationCode};
    
    [self.requestManager POST:__REPLACE_PASSWORD__
                   parameters:body
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                          
                          if ([[Json objectForKey:@"resultCode"] integerValue] == 200)
                          {
                              [self.delegate userReplacePasswordResponds:YES
                                                         responseMessage:@"密码重置成功"];
                          }
                          else
                          {
                              [self.delegate userReplacePasswordResponds:NO
                                                         responseMessage:[Json objectForKey:@"result"]];
                          }
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          [self.delegate userReplacePasswordResponds:NO
                                                     responseMessage:error.description];
                      }];
}

- (void)obtainVerificationWithPhoneNunber:(NSString *)phoneNumber result:(void(^)(BOOL succeed,NSString *reason))result
{
    [self.requestManager POST: __VERIFICATION_CODE__
                   parameters:@{@"username":phoneNumber,@"did":__TOKEN_KEY__}
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                          
                          if ([[Json objectForKey:@"code"] integerValue] == 200)
                          {
                              result(YES,nil);
                          }
                          else
                          {
                              NSString *errorCode =
                              [NSString stringWithFormat:@"%@",[Json objectForKey:@"code"]];
                              
                              NSString *description = [self.errorDescription objectForKey:errorCode];
                              
                              if (description)
                              {
                                  result(NO,description);
                              }
                              else
                              {
                                  result(NO,@"验证码获取失败");
                              }
                          }
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          result(NO,error.description);
                      }];
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

- (BOOL)verificationAge:(NSString *)age
{
    for (int i = 0; i < age.length; i++)
    {
        unichar c = [age characterAtIndex:i];
        
        if (c > 57 || c < 48)
        {
            return NO;
        }
    }
    
    return YES;
}

+ (void)userLogout:(void(^)(BOOL success))complete
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            if (!error)
            {
                [RWChatManager defaultManager].connectionState=EMConnectionDisconnected;
                
                [[UMComSession sharedInstance] userLogout];
                
                if (complete)
                {
                    complete(YES);
                    return;
                }
            }
            
            if (complete)
            {
                complete(NO);
            }
        }];
    }];
    
    [[RWChatManager defaultManager].downLoadQueue addOperation:operation];
}

@end
