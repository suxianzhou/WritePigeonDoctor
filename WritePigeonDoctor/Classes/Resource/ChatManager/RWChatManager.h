//
//  RWChatManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSDK.h>

extern NSString *messageTextBody;
extern NSString *messageImageName;
extern NSString *messageImageBody;
extern NSString *messageVoiceName;
extern NSString *messageVoiceBody;
extern NSString *messageLocationLatitude;
extern NSString *messageLocationLongitude;
extern NSString *messageLocationAddress;
extern NSString *messageVideoName;
extern NSString *messageVideoBody;

typedef NS_ENUM(NSInteger,RWMessageType)
{
    RWMessageTypeText,
    RWMessageTypeImage,
    RWMessageTypeVoice,
    RWMessageTypeLocation,
    RWMessageTypeVideo
};

@interface RWChatManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic,strong,readonly)EMConversation *faceSession;
@property (nonatomic,strong,readonly)NSMutableArray *allSessions;

- (void)createConversationWithID:(NSString *)ID;

@end

@interface RWChatMessageMaker : NSObject

+ (EMMessage *)messageWithType:(RWMessageType)type body:(NSDictionary *)body extension:(NSDictionary *)extension;

@end
