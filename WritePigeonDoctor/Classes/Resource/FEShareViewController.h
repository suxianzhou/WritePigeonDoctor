//
//  FEShareViewController.h
//  shareViewDemo
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "UMSocialConfig.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"

@interface FEShareViewController : UIViewController<UMSocialUIDelegate>

/**
 *  分享界面(如果分享为QQ空间，必须传入Url,否则会跳转到QQ分享界面)
 *
 *  @param contentText         文字内容
 *  @param title               文字标题
 *  @param images              图片、音频或者视频(NSData类型)
 *  @param shareUrl            点击分享后跳转的Url
 *  @param UMSocialUrlType     分享类型:     UMSocialUrlResourceTypeDefault,             //无
                                            UMSocialUrlResourceTypeImage,               //图片
                                            UMSocialUrlResourceTypeVideo,               //视频
                                            UMSocialUrlResourceTypeMusic,                //音乐
                                            UMSocialUrlResourceTypeWeb,                //网页

 */
-(void)shareAppParamsByContentText:(NSString*)contentText title:(NSString *)title images:(id)images  ShareUrl :(NSString *) shareUrl  urlResource:(UMSocialUrlResourceType )UMSocialUrlType;

@end
