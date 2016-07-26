//
//  RWRequsetManager.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "RWRequestIndex.h"

@protocol RWRequsetDelegate <NSObject>

@required

/**
 *  一般网络连接失败会回调此方法
 *
 *  @param error 错误信息
 *  @param task  会话信息
 */
- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task;

@optional


@end

@interface RWRequsetManager : NSObject

@property (nonatomic,assign)id <RWRequsetDelegate> delegate;

@property (nonatomic,strong)AFHTTPSessionManager *requestManager;

@property (nonatomic,assign,readonly)AFNetworkReachabilityStatus reachabilityStatus;

@property (nonatomic,strong)NSDictionary *errorDescription;

@end
