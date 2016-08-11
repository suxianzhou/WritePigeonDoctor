//
//  RWConsultViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/1.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultViewController.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWDataBaseManager+ChatCache.h"

@interface RWConsultViewController ()

<
    RWChatManagerDelegate
>

@property (nonatomic,strong)RWChatManager *chatManager;

@end

@implementation RWConsultViewController

- (void)sendMessage:(EMMessage *)message type:(RWMessageType)type LocalResource:(id)resource
{
    [_chatManager.chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
       
        if (error)
        {
            MESSAGE(@"%@",error.errorDescription);
        }
    }];
    
    [super sendMessage:message type:type LocalResource:resource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _chatManager = [RWChatManager defaultManager];
    _chatManager.delegate = self;
    
    [_chatManager createConversationWithID:_item.EMID
                                 extension:@{conversationTo:_item.EMID,
                                             UMID:_item.umid}];
    
    self.weChat.messages = [[self.baseManager getMessageWith:_item.EMID] mutableCopy];
    
    if (!self.weChat.messages.count)
    {
        EMMessage *message = [[EMMessage alloc] initWithConversationID:nil
                                                                  from:nil
                                                                    to:nil
                                                                  body:nil
                                                                   ext:nil];
        message.chatType = EMChatTypeChat;
        
        message.body = [[EMTextMessageBody alloc]
                            initWithText:@"欢迎使用白鸽医生，白鸽医生您的私人医护助理!------中域教育集团是一家集医师资格考试、考研高端、公务员考试为一体的教学研究的专业化、规模化的考前辅导机构。自成立以来，业务领域扩展了二十省，培训学员15万名，保过班通过率达到了惊人的96%，已迅速发展成为考试培训界的权威品牌，遥遥领先于各大培训机构。"];
        
        RWWeChatMessage *newMsg = [RWWeChatMessage message:message
                                                    header:
                                                    [UIImage imageNamed:@"45195.jpg"]
                                                      type:RWMessageTypeText
                                                 myMessage:NO
                                               messageDate:[NSDate date]
                                                  showTime:NO
                                          originalResource:nil];
        
        self.weChat.messages = [@[newMsg] mutableCopy];
    }
    
    for (int i = 0; i < self.weChat.messages.count; i++)
    {
        RWWeChatMessage *msg = self.weChat.messages[self.weChat.messages.count-i-1];
        
        if (msg.message.isRead)
        {
            break;
        }
        
        msg.message.isRead = YES;
        
        [self.baseManager updateCacheMessage:msg];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_chatManager.faceSession)
    {
        [_chatManager createConversationWithID:_item.EMID
                                     extension:@{conversationTo:_item.EMID}];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_chatManager.faceSession)
    {
        [_chatManager removeFaceConversation];
    }
}

- (void)receiveMessage:(RWWeChatMessage *)message
{
    message.message.isRead = YES;
    
    
    [self.weChat addMessage:message];
}

@end
