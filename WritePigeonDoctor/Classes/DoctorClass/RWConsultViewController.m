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
@property (nonatomic,strong)RWDataBaseManager *baseManager;

@end

@implementation RWConsultViewController

- (void)sendMessage:(EMMessage *)message type:(RWMessageType)type LocalResource:(id)resource
{
    message.to = _item.EMID;
    
    [_chatManager.chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
       
        if (error)
        {
            NSLog(@"%@",error.errorDescription);
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
    
    [_chatManager createConversationWithID:_item.EMID];
    
    _baseManager = [RWDataBaseManager defaultManager];
    
    self.weChat.messages = [[_baseManager getMessageWith:_item.EMID] mutableCopy];
    
    for (int i = 0; i < self.weChat.messages.count; i++)
    {
        RWWeChatMessage *msg = self.weChat.messages[self.weChat.messages.count-i-1];
        
        if (msg.message.isRead)
        {
            break;
        }
        
        msg.message.isRead = YES;
        
        [_baseManager updateCacheMessage:msg];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_chatManager.faceSession)
    {
        [_chatManager createConversationWithID:_item.EMID];
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
