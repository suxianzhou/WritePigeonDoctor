//
//  RWChatManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSDK.h>
#import <EMSDKFull.h>
#import "RWWeChatBar.h"
#import "RWDataBaseManager+ChatCache.h"
#import "RWRequsetManager+UserLogin.h"

extern NSString *messageTextBody;
extern NSString *messageImageName;
extern NSString *messageImageBody;
extern NSString *messageVoiceName;
extern NSString *messageVoiceBody;
extern NSString *messageVoiceDuration;
extern NSString *messageLocationLatitude;
extern NSString *messageLocationLongitude;
extern NSString *messageLocationAddress;
extern NSString *messageVideoName;
extern NSString *messageVideoBody;

extern NSString *conversationTo;
extern NSString *UMID;

extern NSString *QueueName;

@protocol RWChatManagerDelegate <NSObject>

- (void)receiveMessage:(RWWeChatMessage *)message;

@end

@interface RWChatManager : NSObject

<
    EMClientDelegate,
    EMChatManagerDelegate,
    RWRequsetDelegate
>

+ (instancetype)defaultManager;

@property (nonatomic,strong,readonly)EMClient *client;
@property (nonatomic,weak,readonly)id<IEMChatManager> chatManager;

@property (nonatomic,assign)id<RWChatManagerDelegate> delegate;

@property (nonatomic,assign)EMConnectionState connectionState;

@property (nonatomic,strong,readonly)EMConversation *faceSession;
@property (nonatomic,strong,readonly)NSMutableArray *allSessions;

@property (nonatomic,strong)RWDataBaseManager *baseManager;
@property (nonatomic,strong)NSOperationQueue *downLoadQueue;

- (void)createConversationWithID:(NSString *)ID extension:(NSDictionary *)extension;
- (void)removeFaceConversation;

+ (NSString *)videoName;
+ (NSString *)voiceName;
+ (NSString *)imageNameSuffix:(NSString *)suffix;

@end

@interface RWChatMessageMaker : NSObject

+ (EMMessage *)messageWithType:(EMMessageBodyType)type body:(NSDictionary *)body extension:(NSDictionary *)extension;

@end
