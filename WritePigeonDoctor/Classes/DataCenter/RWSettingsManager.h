//
//  RWSettingsManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWSettingsIndex.h"
#import "NSDate+DateExtension.h"

#ifndef __SYS_SETTINGS__
#define __SYS_SETTINGS__ [RWSettingsManager systemSettings]
#endif

#ifndef SETTINGS
#define SETTINGS(key,value) [__SYS_SETTINGS__ setSettingsValue:value forKey:key]
#endif

#ifndef SETTINGS_VALUE
#define SETTINGS_VALUE(key) [__SYS_SETTINGS__ settingsValueForKey:key]
#endif

@interface RWSettingsManager : NSObject

+ (instancetype)systemSettings;

@property (nonatomic,strong,readonly)NSMutableDictionary *settings;
/**
 *  添加一条设置信息
 *
 *  @param value
 *  @param key
 *
 *  @return
 */
- (BOOL)setSettingsValue:(id)value forKey:(NSString *)key;
/**
 *  取出一条设置信息
 *
 *  @param key
 *
 *  @return
 */
- (id)settingsValueForKey:(NSString *)key;
/**
 *  移除一条设置信息
 *
 *  @param key
 *
 *  @return
 */
- (BOOL)removeSettingsValueForKey:(NSString *)key;

/**
 *  AddLocalNotification
 *
 *  @param clockString time string
 *  @param name NotificationName
 *  @param content Notification content
 */
- (void)addLocalNotificationWithClockString:(NSString *)clockString
                                    AndName:(NSString *)name
                                    content:(NSString *)content;
/**
 *  cancelLocalNotification
 *
 *  @param name NotificationName
 */
- (void)cancelLocalNotificationWithName:(NSString *)name;
/**
 *  AddLocalNotification
 *
 *  @param date    Notification date
 *  @param cycle   Notification cycle
 *  @param name    Notification name
 *  @param content Notification content
 */
- (void)addAlarmClockWithTime:(NSDate *)date
                        Cycle:(RWClockCycle)cycle
                    ClockName:(NSString *)name
                      Content:(NSString *)content;

@end
