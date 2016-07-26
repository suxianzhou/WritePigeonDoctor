//
//  RWDeployManager.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWDeployIndex.h"

@interface RWDeployManager : NSObject

+ (RWDeployManager *)defaultManager;

- (void)addLocalNotificationWithClockString:(NSString *)clockString
                                    AndName:(NSString *)name;

- (void)cancelLocalNotificationWithName:(NSString *)name;

- (void)addAlarmClockWithTime:(NSDate *)date Cycle:(RWClockCycle)cycle
                    ClockName:(NSString *)name Content:(NSString *)content;

- (void)addLocalNotificationToRWMoment:(RWMoment)moment AndName:(NSString *)name;

@end
