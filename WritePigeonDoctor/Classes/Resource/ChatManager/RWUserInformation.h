//
//  RWUserInformation.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RWUserJurisdiction)
{
    RWUserJurisdictionOfDoctor,
    RWUserJurisdictionOfCommon
};

typedef NS_ENUM(NSInteger,RWUserState)
{
    RWUserStateOnline,
    RWUserStateOffline,
    RWUserStateInvisible,
    RWUserStateLeave
};

typedef NS_ENUM(NSInteger,RWRelationship)
{
    RWRelationshipMySelf,
    RWRelationshipWithDoctor,
    RWRelationshipWithFriend,
    RWRelationshipStranger,
    RWRelationshipForBlacklist
};

@interface RWUserInformation : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *profession;
@property (nonatomic,copy)NSString *personalized;
@property (nonatomic,assign)RWUserJurisdiction jurisdiction;
@property (nonatomic,assign)RWUserState status;
@property (nonatomic,assign)RWRelationship *relationship;

@property (nonatomic,strong)NSMutableArray *readMessages;
@property (nonatomic,strong)NSMutableArray *unreadMessages;

@end
