//
//  TIMManagerExt.h
//  ImSDK
//
//  Created by bodeng on 30/12/15.
//  Copyright © 2015 tencent. All rights reserved.
//

#ifndef TIMManagerExt_h
#define TIMManagerExt_h

#import "TIMConversation.h"
#import "TIMCallbackExt.h"
#import "TIMManager.h"
#import "TIMFriendshipProxy.h"
#import "TIMGroupAssistant.h"

@class TIMSendToUsersDetailInfo;

typedef void (^TIMSendToUsersFail)(int code, NSString *err, TIMSendToUsersDetailInfo *detailInfo);


@interface TIMManager() {
    
}

/**
 *  获取会话（TIMConversation*）列表
 *
 *  @return 会话列表
 */
-(NSArray*) getConversationList;

/**
 *  获取会话
 *
 *  @param type 会话类型，TIM_C2C 表示单聊 TIM_GROUP 表示群聊
 *  @param receiver C2C 为对方用户 identifier， GROUP 为群组Id
 *
 *  @return 会话对象
 */
-(TIMConversation*) getConversation: (TIMConversationType)type receiver:(NSString *)receiver;

/**
 *  删除会话
 *
 *  @param type 会话类型，TIM_C2C 表示单聊 TIM_GROUP 表示群聊
 *  @param receiver    用户identifier 或者 群组Id
 *
 *  @return TRUE:删除成功  FALSE:删除失败
 */
-(BOOL) deleteConversation:(TIMConversationType)type receiver:(NSString*)receiver;

/**
 *  删除会话和消息
 *
 *  @param type 会话类型，TIM_C2C 表示单聊 TIM_GROUP 表示群聊
 *  @param receiver    用户identifier 或者 群组Id
 *
 *  @return TRUE:删除成功  FALSE:删除失败
 */
-(BOOL) deleteConversationAndMessages:(TIMConversationType)type receiver:(NSString*)receiver;

/**
 *  获取会话数量
 *
 *  @return 会话数量
 */
-(int) ConversationCount;

/**
 *  通过索引获取会话
 *
 *  @param index 索引
 *
 *  @return 返回对应的会话
 */
-(TIMConversation*) getConversationByIndex:(int)index;

/**
 *  设置消息回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setMessageListener: (id<TIMMessageListener>)listener;

/**
 *  设置消息修改回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setMessageUpdateListener: (id<TIMMessageUpdateListener>)listener;

/**
 *  设置上传任务进度回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setUploadProgressListener: (id<TIMUploadProgressListener>)listener;

/**
 *  设置群组成员变更通知回调（已弃用，请使用setGroupTipsListener）
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setGroupMemberListener: (id<TIMGroupMemberListener>)listener DEPRECATED_ATTRIBUTE;

/**
 *  设置群组事件回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setGroupEventListener: (id<TIMGroupEventListener>)listener;

/**
 *  设置邀请回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
- (void)setAVInviteListener:(id<TIMAVInvitationListener>)listener;

/**
 * 禁用存储，在不需要消息存储的场景可以禁用存储，提升效率
 */
-(void) disableStorage;


/**
 *  获取好友管理器
 *
 *  @return 好友管理器
 */
-(TIMFriendshipManager *) friendshipManager;

/**
 *  获取群管理器
 *
 *  @return 群管理器
 */
-(TIMGroupManager *) groupManager;

/**
 *  获取好友代理
 *
 *  @return 好友代理
 */
-(TIMFriendshipProxy *) friendshipProxy;

/**
 *  设置TIMFriendshipManager和TIMFriendshipProxy默认拉取的字段（不设置：默认拉取所有基本字段，不拉取自定义字段）
 *
 *  @param setting 设置参数
 *
 *  @return 0 成功
 */
-(int) initFriendshipSetting:(TIMFriendshipSetting*)setting;

/**
 *  设置好友代理回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setFriendshipProxyListener:(id<TIMFriendshipProxyListener>)listener;

/**
 *  开启好友代理功能
 *
 *  @return 0 成功
 */
-(int) enableFriendshipProxy;

/**
 *  获取群组助手
 *
 *  @return 群组助手
 */
-(TIMGroupAssistant *) groupAssistant;

/**
 *  设置TIMGroupManager和TIMGroupAssistant默认拉取的字段（不设置：默认拉取所有基本字段，不拉取自定义字段）
 *
 *  @param setting 设置参数
 *
 *  @return 0 成功
 */
-(int) initGroupSetting:(TIMGroupSetting*)setting;

/**
 *  设置群组助手回调
 *
 *  @param listener 回调
 *
 *  @return 0 成功
 */
-(int) setGroupAssistantListener:(id<TIMGroupAssistantListener>)listener;

/**
 *  开启群组助手
 *
 *  @return 0 成功
 */
-(int) enableGroupAssistant;

/**
 *  发送消息给多个用户
 *
 *  @param msg   发送的消息
 *  @param users 目标用户的id列表
 *  @param succ  成功回调
 *  @param fail  失败回调
 *
 *  @return 0 发送成功
 */
-(int) sendMessage:(TIMMessage*)msg toUsers:(NSArray*)users succ:(TIMSucc)succ fail:(TIMSendToUsersFail)fail;

/**
 *  禁止未读自动上报，默认启用
 */
-(void) disableAutoReport;

/**
 *  登录时禁止拉取最近联系人列表
 */
-(void) disableRecentContact;

@end

#endif /* TIMManagerExt_h */
