//
//  RWRequsetManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager.h"
#import "RWRequsetManager+UserLogin.h"

@interface RWRequsetManager ()


@end

@implementation RWRequsetManager

- (void)addNetworkStatusObserver
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    
    [statusManager startMonitoring];
    
    [statusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        _reachabilityStatus = status;
        
//        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
//        [notificationCenter postNotificationName:REACHABILITY_STATUS_MESSAGE
//                                          object:[NSNumber numberWithInteger:status]];
    }];
}

#pragma mark - init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _errorDescription = @{@"200":@"操作成功",
                              @"201":@"客户端版本不对，需升级sdk",
                              @"301":@"被封禁",
                              @"302":@"用户名或密码错误",
                              @"315":@"IP限制",
                              @"403":@"非法操作或没有权限",
                              @"404":@"对象不存在",
                              @"405":@"参数长度过长",
                              @"406":@"对象只读",
                              @"408":@"客户端请求超时",
                              @"413":@"验证失败(短信服务)",
                              @"414":@"参数错误",
                              @"415":@"客户端网络问题",
                              @"416":@"频率控制",
                              @"417":@"重复操作",
                              @"418":@"通道不可用(短信服务)",
                              @"419":@"数量超过上限",
                              @"422":@"账号被禁用",
                              @"431":@"HTTP重复请求"};
    }
    
    return self;
}
+ (void)warningToViewController:(__kindof UIViewController *)viewController Title:(NSString *)title Click:(void(^)(void))click{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (click)
        {
            click();
        }
    }];
    
    [alert addAction:registerAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];

}

@end
