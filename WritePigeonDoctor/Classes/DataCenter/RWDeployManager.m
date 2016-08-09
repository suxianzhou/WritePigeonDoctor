//
//  RWDeployManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDeployManager.h"
#import "RWDeployManager+DateProcess.h"

@interface RWDeployManager ()

@end

@implementation RWDeployManager

+ (RWDeployManager *)defaultManager
{
    static RWDeployManager *_Only = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _Only = [super allocWithZone:NULL];
    });
    
    return _Only;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWDeployManager defaultManager];
    
}

- (void)addLocalNotificationWithClockString:(NSString *)clockString AndName:(NSString *)name
{
    RWClockAttribute attribute = [self clockAttributeWithString:clockString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *week = [dateFormatter stringFromDate:[NSDate date]];
    
    NSInteger afterDays;
    
    if (attribute.week == RWClockWeekOfNone)
    {
        BOOL isPast = [self isPastTime:attribute.hours minute:attribute.minute];
        
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
        afterDays =
                [self daysFromClockTimeWithClockWeek:attribute.week AndWeekString:week];
    }
    
    NSDate *clockDate = [self buildClockDateWithAfterDays:afterDays
                                                    Hours:attribute.hours
                                                AndMinute:attribute.minute];
    
    NSString *content = @"\n再不答题我们就老了 【中域教育】每周免费直播";
 
    [self addAlarmClockWithTime:clockDate
                          Cycle:attribute.cycleType
                      ClockName:name
                        Content:content];
}



- (void)addLocalNotificationToRWMoment:(RWMoment)moment AndName:(NSString *)name
{
//    NSString *testDate = [sharedDelegate.deployInformation objectForKey:TEST_DATE];
//    
//    NSArray *testDates = [testDate componentsSeparatedByString:@"()"];
//    
//    if (testDates.count != 2)
//    {
//        return;
//    }
//    
//    RWMoment testMoment = [self momentWithString:[testDates lastObject]];
//    
//    NSInteger distanceDays = [self distanceWithBeginMoments:moment
//                                              AndEndMoments:testMoment];
//    
//    RWMoment faceMoment = [self momentWithDate:[NSDate date]];
//    
//    faceMoment.time = RWTimeMake(0,0,0);
//    
//    NSInteger daysGap = [self distanceWithBeginMoments:faceMoment
//                                         AndEndMoments:moment];
//    
//    if (daysGap >= 0)
//    {
//        NSString *title = [NSString stringWithFormat:
//                @"\n【考试提醒】距离 %@ 考试，还有%d天,加油哦！",name,(int)distanceDays];
//        
//        if (distanceDays == 0)
//        {
//            title = [NSString stringWithFormat:
//                     @"\n【考试提醒】今天是 %@ 考试时间，加油哦！",name];
//        }
//        
//        [self addAlarmClockWithTime:[self dateWithRWMoment:moment]
//                              Cycle:RWClockCycleOnce
//                          ClockName:TEST_CLOCK
//                            Content:title];
//        
//        RWMoment nextMoment = moment;
//        
//        nextMoment.date.day--;
//        
//        [self addLocalNotificationToRWMoment:nextMoment AndName:name];
//    }
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
        
        notification.userInfo = @{CLOCK_NAMES:name};
        
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
        if ([[[notifications[i] valueForKey:@"userInfo"]
                                objectForKey:CLOCK_NAMES] isEqualToString:name])
        {
            [[UIApplication sharedApplication]
                                        cancelLocalNotification:notifications[i]];
        }
    }
}

@end
