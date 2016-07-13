//
//  RWChatManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/12.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChatManager.h"

@interface RWChatManager ()

<
    TIMMessageListener
>

@property (nonatomic,strong)TIMManager *iMManager;

@end

@implementation RWChatManager

- (void)onNewMessage:(NSArray*) msgs
{
    
}

- (void)initIMManagerItems
{
    _iMManager = [TIMManager sharedInstance];
    [[TIMManager sharedInstance] setMessageListener:self];
}

#pragma mark - init singleton object

+ (instancetype)defaultManager
{
    static RWChatManager *_singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _singleton = [super allocWithZone:NULL];
        [_singleton initIMManagerItems];
    });
    
    return _singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWChatManager defaultManager];
}


@end
