//
//  XZUMComPullRequest.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/2.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#define UMComRequestManager [UMComDataRequestManager defaultManager]

#import "XZUMComPullRequest.h"
#import "UMComUser.h"
#import "UMComImageUrl.h"
@interface XZUMComPullRequest ()

@end

@implementation XZUMComPullRequest


+ (void)userCustomAccountLoginWithName:(NSString *)name
                              sourceId:(NSString *)sourceId
                              icon_url:(NSString *)icon_url
                                gender:(NSInteger)gender
                                   age:(NSInteger)age
                                custom:(NSString *)custom
                                 score:(CGFloat)score
                            levelTitle:(NSString *)levelTitle
                                 level:(NSInteger)level
                     contextDictionary:(NSDictionary *)context
                          userNameType:(UMComUserNameType)userNameType
                        userNameLength:(UMComUserNameLength)userNameLength
                            completion:(UMComRequestCompletion)completion
{
    [UMComRequestManager userCustomAccountLoginWithName:name sourceId:sourceId icon_url:icon_url gender:gender age:age custom:custom score:score levelTitle:levelTitle level:level contextDictionary:context userNameType:userNameType userNameLength:userNameLength completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject,error);
    }];
}

+ (void)userFollowWithUserID:(NSString *)uid isFollow:(BOOL)isFollow completion:(UMComRequestCompletion)completion
{
    [UMComRequestManager userFollowWithUserID:uid isFollow:isFollow completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject,error);
    }];
}

+ (void)fecthUserProfileWithUid:(NSString *)uid source:(NSString *)source source_uid:(NSString *)source_uid completion:(UIImageCompletion)imageStr
{
    [UMComRequestManager fecthUserProfileWithUid:uid source:source source_uid:source_uid completion:^(NSDictionary *responseObject, NSError *error) {
        NSLog(@"res = %@",responseObject);
        if (!error) {
        UMComUser *umuser = responseObject[@"data"];
        if (umuser.icon_url) {
        UMComImageUrl * imageUrl = umuser.icon_url;
        NSString * small = imageUrl.small_url_string;
        imageStr(small);
        }
      }
     }];
}

+ (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
           completion:(UMComRequestCompletion)completion
{
    [UMComRequestManager checkUserName:name userNameType:userNameType userNameLength:userNameLength completion:^(NSDictionary *responseObject, NSError *error) {
        completion (responseObject,error);
    }];
}

+ (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                   completion:(UMComRequestCompletion)completion
{
   [UMComRequestManager updateProfileWithName:name age:age gender:gender custom:custom userNameType:userNameType userNameLength:userNameLength completion:^(NSDictionary *responseObject, NSError *error) {
       completion (responseObject,error);
   }];
}

+ (void)userUpdateAvatarWithImage:(id)image
                       completion:(UMComRequestCompletion)completion
{
   [UMComRequestManager userUpdateAvatarWithImage:image completion:^(NSDictionary *responseObject, NSError *error) {
      completion (responseObject,error); 
   }];
}

+ (void)fecthUserFollowingsWithUid:(NSString *)uid
                             count:(NSInteger)count
                        completion:(UMComRequestCompletion)completion
{
    [UMComRequestManager fecthUserFollowingsWithUid:uid count:count completion:^(NSDictionary *responseObject, NSError *error) {
        completion (responseObject,error);
    }];
}
@end
