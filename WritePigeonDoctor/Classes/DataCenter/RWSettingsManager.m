//
//  RWSettingsManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSettingsManager.h"
#import "NSData+Base64.h"

#ifndef __SETTINGS_NAME__
#define __SETTINGS_NAME__ @"Settings.plist"
#endif

#ifndef __SETTINGS_PATH__
#define __SETTINGS_PATH__ [__SANDBOX_PATH__ stringByAppendingPathComponent:__SETTINGS_NAME__]
#endif

@implementation RWSettingsManager

+ (instancetype)systemSettings
{
    static RWSettingsManager *_Settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _Settings = [super allocWithZone:NULL];
        [_Settings setDefaultSettings];
    });
    
    return _Settings;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWSettingsManager systemSettings];
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
    BOOL isDerectory = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isFileExist = [fileManager fileExistsAtPath:__SETTINGS_PATH__ isDirectory:&isDerectory];
    
    if (!isFileExist)
    {
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        
        [settings setObject:@(YES)
                     forKey:FIRST_OPEN_APPILCATION];
        [settings setObject:@(YES)
                     forKey:__AUTO_LOGIN__];
        
        if ([settings writeToFile:__SETTINGS_PATH__ atomically:YES])
        {
            MESSAGE(@"设置列表配置失败");
        }
    }
    
    NSDictionary *settings =
                        [NSDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__];
    
    _settings = [settings mutableCopy];
}

- (BOOL)setSettingsValue:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *settings = [[NSMutableDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__] mutableCopy];
        
    if ([value isKindOfClass:[NSString class]])
    {
        [settings setObject:[RWSettingsManager encryptionString:value]
                         forKey:key];
    }
    else
    {
        [settings setObject:value forKey:key];
    }
    
    _settings = settings;
        
    return [settings writeToFile:__SETTINGS_PATH__ atomically:YES];
}

- (id)settingsValueForKey:(NSString *)key
{
    NSDictionary *settings =
                [NSDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__];
    
    if ([[settings objectForKey:key] isKindOfClass:[NSString class]])
    {
        return [RWSettingsManager declassifyString:[settings objectForKey:key]];
    }
    
    return [settings objectForKey:key];
}

- (BOOL)removeSettingsValueForKey:(NSString *)key
{
    NSMutableDictionary *settings = [[NSMutableDictionary dictionaryWithContentsOfFile:__SETTINGS_PATH__] mutableCopy];
    
    [settings removeObjectForKey:key];
    
    _settings = settings;
    
    return [settings writeToFile:__SETTINGS_PATH__ atomically:YES];
}

+ (NSString *)encryptionString:(NSString *)string
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [stringData base64EncodedString];
}

+ (NSString *)declassifyString:(NSString *)string
{
    NSData *stringData = [NSData dataFromBase64String:string];
    
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (void)addLocalNotificationWithClockString:(NSString *)clockString AndName:(NSString *)name content:(NSString *)content
{
    RWClockAttribute attribute = [NSDate clockAttributeWithString:clockString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *week = [dateFormatter stringFromDate:[NSDate date]];
    
    NSInteger afterDays;
    
    if (attribute.week == RWClockWeekOfNone)
    {
        BOOL isPast = [NSDate isPastTime:attribute.hours minute:attribute.minute];
        
        if (isPast)
        {
            afterDays = 1;
        }
        else
        {
            afterDays = 0;
        }
    }
    else
    {
        afterDays = [NSDate daysFromClockTimeWithClockWeek:attribute.week
                                             AndWeekString:week];
    }
    
    NSDate *clockDate = [NSDate buildClockDateWithAfterDays:afterDays
                                                      Hours:attribute.hours
                                                  AndMinute:attribute.minute];
    
    [self addAlarmClockWithTime:clockDate
                          Cycle:attribute.cycleType
                      ClockName:name
                        Content:content];
}

- (void)addAlarmClockWithTime:(NSDate *)date Cycle:(RWClockCycle)cycle ClockName:(NSString *)name Content:(NSString *)content
{
    UIUserNotificationType types =  UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    if (notification!=nil) {
        
        notification.fireDate = date;
        
        switch (cycle) {
                
            case RWClockCycleOnce:
                
                notification.repeatInterval = kCFCalendarUnitEra;
                
                break;
                
            case RWClockCycleEveryDay:
                
                notification.repeatInterval = kCFCalendarUnitDay;
                
                break;
                
            case RWClockCycleEveryWeek:
                
                notification.repeatInterval = kCFCalendarUnitWeekday;
                
                break;
                
            default:
                break;
        }
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = content;
        notification.applicationIconBadgeNumber = 0;
        //        notification.userInfo = @{CLOCK_NAMES:name};
        notification.soundName = @"ClockSound2.mp3";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)cancelLocalNotificationWithName:(NSString *)name
{
    NSArray *notifications =
    [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < notifications.count; i++)
    {
        //        if ([[[notifications[i] valueForKey:@"userInfo"]
        //                                objectForKey:CLOCK_NAMES] isEqualToString:name])
        //        {
        //            [[UIApplication sharedApplication]
        //                                        cancelLocalNotification:notifications[i]];
        //        }
    }
}

@end
