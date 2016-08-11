//
//  RWChatManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChatManager.h"

const NSString *messageTextBody = @"messageTextBody";
const NSString *messageImageName = @"messageImageName";
const NSString *messageImageBody = @"messageImageBody";
const NSString *messageVoiceName = @"messageVoiceName";
const NSString *messageVoiceBody = @"messageVoiceBody";
const NSString *messageVoiceDuration = @"messageVoiceDuration";
const NSString *messageLocationLatitude = @"messageLocationLatitude";
const NSString *messageLocationLongitude = @"messageLocationLongitude";
const NSString *messageLocationAddress = @"messageLocationAddress";
const NSString *messageVideoName = @"messageVideoName";
const NSString *messageVideoBody = @"messageVideoBody";
const NSString *conversationTo = @"onversationTo";

@implementation RWChatManager

+ (instancetype)defaultManager
{
    static RWChatManager *_default = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _default = [super allocWithZone:NULL];
        [_default setDefaultSettings];
    });
    
    return _default;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWChatManager defaultManager];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
}

- (void)setDefaultSettings
{
    _client = [EMClient sharedClient];
    _chatManager = _client.chatManager;
    _connectionState = EMConnectionDisconnected;
    
    [_client addDelegate:self delegateQueue:nil];
    [_chatManager addDelegate:self delegateQueue:nil];
    
    _allSessions = [[_chatManager loadAllConversationsFromDB] mutableCopy];
    _baseManager = [RWDataBaseManager defaultManager];
    
    if ([SETTINGS_VALUE(__AUTO_LOGIN__) boolValue])
    {
        RWUser *user = [_baseManager getDefualtUser];
        
        if (user)
        {
            RWRequsetManager *request = [[RWRequsetManager alloc] init];
            request.delegate = self;
            
            [request userinfoWithUsername:user.username AndPassword:user.password];
        }
    }
}

- (void)userLoginSuccess:(BOOL)success responseMessage:(NSString *)responseMessage
{
    if (!success)
    {
        UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        [RWRequsetManager warningToViewController:tabbar
                                            Title:[NSString stringWithFormat:@"自动登录失败\n%@",responseMessage]
                                            Click:^{
           
            [tabbar toLoginViewController];
        }];
    }
}

- (void)createConversationWithID:(NSString *)ID extension:(NSDictionary *)extension
{
    _faceSession =[_chatManager getConversation:ID
                                           type:EMConversationTypeChat
                               createIfNotExist:YES];
    
    _faceSession.ext = extension;
    
    _allSessions = [[_chatManager loadAllConversationsFromDB] mutableCopy];
}

- (void)removeFaceConversation
{
    _faceSession = nil;
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *msg in aMessages)
    {
        __block EMMessageBody *msgBody = msg.body;
        
        if (msgBody.type != EMMessageBodyTypeText)
        {
            [_chatManager asyncDownloadMessageAttachments:msg
                                                 progress:nil
                                               completion:^(EMMessage *message, EMError *error)
             {
                 if (!error)
                 {
                     EMFileMessageBody *body = (EMFileMessageBody *)message.body;
                     
                     if ([NSData dataWithContentsOfFile:body.localPath])
                     {
                         RWWeChatMessage *newMsg;
                         
                         switch (msgBody.type)
                         {
                             case EMMessageBodyTypeImage:
                             {
                                 newMsg =
                                  [RWWeChatMessage message:message
                                                    header:[UIImage imageNamed:@"MY"]
                                                      type:RWMessageTypeImage
                                                 myMessage:NO
                                               messageDate:[NSDate date]
                                                  showTime:NO
                                          originalResource:nil];
                                 
                                 break;
                             }
                             case EMMessageBodyTypeLocation:break;
                             case EMMessageBodyTypeVoice:
                             {
                                 newMsg =
                                  [RWWeChatMessage message:message
                                                    header:[UIImage imageNamed:@"MY"]
                                                      type:RWMessageTypeVoice
                                                 myMessage:NO
                                               messageDate:[NSDate date]
                                                  showTime:NO
                                          originalResource:nil];
                                 
                                 break;
                             }
                             case EMMessageBodyTypeVideo:
                             {
                                 newMsg =
                                  [RWWeChatMessage message:message
                                                    header:[UIImage imageNamed:@"MY"]
                                                      type:RWMessageTypeVideo
                                                 myMessage:NO
                                               messageDate:[NSDate date]
                                                  showTime:NO
                                          originalResource:nil];
                                 
                                 break;
                             }
                             case EMMessageBodyTypeFile:break;
                                 
                             default:
                                 break;
                         }

                         if (msg)
                         {
                             if ([msg.conversationId isEqualToString:_faceSession.conversationId])
                             {
                                 [_delegate receiveMessage:newMsg];
                             }
                             
                             [_baseManager cacheMessage:newMsg];
                         }
                     }
                 }
             }];
        }
        else
        {
            RWWeChatMessage *newMsg = [RWWeChatMessage message:msg
                                                        header:[UIImage imageNamed:@"MY"]
                                                          type:RWMessageTypeText
                                                     myMessage:NO
                                                   messageDate:[NSDate date]
                                                      showTime:NO
                                              originalResource:nil];
            
            if ([msg.conversationId isEqualToString:_faceSession.conversationId])
            {
                [_delegate receiveMessage:newMsg];
            }
            
            [_baseManager cacheMessage:newMsg];
        }
    }
}

- (void)didReceiveHasReadAcks:(NSArray *)aMessages
{
    //已读
}

- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages
{
    //已送达
}

- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState
{
    _connectionState = aConnectionState;
}

- (void)didLoginFromOtherDevice
{
    _connectionState = EMConnectionDisconnected;
}

- (void)didRemovedFromServer
{
    _connectionState = EMConnectionDisconnected;
}

#pragma other funtion

+ (NSString *)videoName
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy$MM$dd#HH$mm$ss$SSS$$"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"video@%@&%@.mp4",defaultManager.faceSession.conversationId,timeString];
}

+ (NSString *)voiceName
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"voice%@%@.caf",defaultManager.faceSession.conversationId,timeString];
}

+ (NSString *)imageNameSuffix:(NSString *)suffix
{
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy$MM$dd#HH$mm$ss$SSS$$"];
    NSString *timeString= [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"image@%@&%@.%@",defaultManager.faceSession.conversationId,timeString,suffix];
}

@end

@implementation RWChatMessageMaker

+ (EMMessage *)messageWithType:(EMMessageBodyType)type body:(NSDictionary *)body extension:(NSDictionary *)extension
{
    NSString *from = [[EMClient sharedClient] currentUsername];
    RWChatManager *defaultManager = [RWChatManager defaultManager];
    NSString *conversationID = defaultManager.faceSession.conversationId;
    
    NSString *to = defaultManager.faceSession.ext[conversationTo];

    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationID
                                                              from:from
                                                                to:to
                                                              body:nil
                                                               ext:extension];
    message.chatType = EMChatTypeChat;
    
    switch (type)
    {
        case EMMessageBodyTypeText:
        {
            message.body = [[EMTextMessageBody alloc]
                                                initWithText:body[messageTextBody]];
            
            break;
        }
        case EMMessageBodyTypeImage:
        {
            message.body = [[EMImageMessageBody alloc] initWithData:body[messageImageBody] displayName:body[messageImageName]];
            
            break;
        }
        case EMMessageBodyTypeVoice:
        {
            EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithData:body[messageVoiceBody] displayName:body[messageVoiceName]];
            
            voiceBody.duration = [body[messageVoiceDuration] intValue];
            
            message.body = voiceBody ;
            
            break;
        }
        case EMMessageBodyTypeLocation:
        {
            message.body = [[EMLocationMessageBody alloc]
                            initWithLatitude:[body[messageLocationLatitude] doubleValue]
                                   longitude:[body[messageLocationLongitude] doubleValue]
                                     address:body[messageLocationAddress]];
            
            break;
        }
        case EMMessageBodyTypeVideo:
        {
            message.body = [[EMVideoMessageBody alloc] initWithLocalPath:body[messageVideoBody] displayName:body[messageVideoName]];
            
            break;
        }
            
        default:return nil;
            
    }
    
    return message;
}


@end
