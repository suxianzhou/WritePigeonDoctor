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
const NSString *messageLocationLatitude = @"messageLocationLatitude";
const NSString *messageLocationLongitude = @"messageLocationLongitude";
const NSString *messageLocationAddress = @"messageLocationAddress";
const NSString *messageVideoName = @"messageVideoName";
const NSString *messageVideoBody = @"messageVideoBody";

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

- (void)setDefaultSettings
{
    _allSessions = [[[EMClient sharedClient].chatManager loadAllConversationsFromDB] mutableCopy];
}

- (void)createConversationWithID:(NSString *)ID
{
    [[EMClient sharedClient].chatManager getConversation:ID type:EMConversationTypeChat createIfNotExist:YES];
}

@end

@implementation RWChatMessageMaker

+ (EMMessage *)messageWithType:(RWMessageType)type body:(NSDictionary *)body extension:(NSDictionary *)extension
{
    NSString *from = [[EMClient sharedClient] currentUsername];

    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"6001"
                                                              from:from
                                                                to:@"6001"
                                                              body:nil
                                                               ext:extension];
    message.chatType = EMChatTypeChat;
    
    switch (type)
    {
        case RWMessageTypeText:
        {
            message.body = [[EMTextMessageBody alloc]
                                                initWithText:body[messageTextBody]];
            
            break;
        }
        case RWMessageTypeImage:
        {
            message.body = [[EMImageMessageBody alloc] initWithData:body[messageImageBody] displayName:body[messageImageName]];
            
            break;
        }
        case RWMessageTypeVoice:
        {
            message.body = [[EMVoiceMessageBody alloc] initWithLocalPath:body[messageVoiceBody] displayName:body[messageVoiceName]];
            
            break;
        }
        case RWMessageTypeLocation:
        {
            message.body = [[EMLocationMessageBody alloc]
                            initWithLatitude:[body[messageLocationLatitude] doubleValue]
                                   longitude:[body[messageLocationLongitude] doubleValue]
                                     address:body[messageLocationAddress]];
            
            break;
        }
        case RWMessageTypeVideo:
        {
            message.body = [[EMVideoMessageBody alloc] initWithLocalPath:body[messageVideoBody] displayName:body[messageVideoName]];
            
            break;
        }
            
        default:return nil;
            
    }
    
    return message;
}


@end
