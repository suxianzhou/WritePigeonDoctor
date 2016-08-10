//
//  NSDate+DateExtension.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,RWClockCycle) {
    
    RWClockCycleEveryDay    = 0,
    RWClockCycleEveryWeek   = 1,
    RWClockCycleOnce        = 2
};

typedef NS_ENUM(NSInteger ,RWClockWeek) {
    
    RWClockWeekOfNone       = 0     ,
    RWClockWeekOfMonday     = 1 << 1,
    RWClockWeekOfTuesday    = 1 << 2,
    RWClockWeekOfWednesday  = 1 << 3,
    RWClockWeekOfThursday   = 1 << 4,
    RWClockWeekOfFriday     = 1 << 5,
    RWClockWeekOfSaturday   = 1 << 6,
    RWClockWeekOfSunday     = 1 << 7
};

struct RWDate
{
    NSInteger year;
    NSInteger month;
    NSInteger day;
};

typedef struct RWDate RWDate;

RWDate RWDateMake(NSInteger year, NSInteger month, NSInteger day);

struct RWTime
{
    NSInteger hours;
    NSInteger minute;
    NSInteger second;
};

typedef struct RWTime RWTime;

RWTime RWTimeMake(NSInteger hours ,NSInteger minute ,NSInteger second);

struct RWMoment
{
    RWDate date;
    RWTime time;
    RWClockWeek week;
};

typedef struct RWMoment RWMoment;

RWMoment RWMomentMake(NSInteger year, NSInteger month, NSInteger day, NSInteger hours ,NSInteger minute ,NSInteger second,RWClockWeek week);

typedef struct RWClockAttribute RWClockAttribute;

struct RWClockAttribute {
    
    RWClockCycle cycleType;
    RWClockWeek  week;
    NSInteger    hours;
    NSInteger    minute;
};

RWClockAttribute RWClockAttributeMake(RWClockCycle cycleType ,
                                      RWClockWeek  week ,
                                      NSInteger    hours ,
                                      NSInteger    minute);

NSInteger Log(NSInteger number);

#pragma mark - grows

RWMoment growsYear(RWMoment moment,NSInteger growsTimes);

RWMoment growsMonth(RWMoment moment,NSInteger growsTimes);

RWMoment growsDay(RWMoment moment,NSInteger growsTimes);

RWMoment growsHour(RWMoment moment,NSInteger growsTimes);

RWMoment growsMinute(RWMoment moment,NSInteger growsTimes);

RWMoment growsSecond(RWMoment moment,NSInteger growsTimes);

#pragma mark - decrease

RWMoment decreaseYear(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseMonth(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseDay(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseHour(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseMinute(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseSecond(RWMoment moment,NSInteger decreaseTimes);

@interface NSDate (DateExtension)

+ (NSString *)stringClockAttribute:(RWClockAttribute)clockAttribute;
+ (RWClockAttribute)clockAttributeWithString:(NSString *)attributeString;

+ (NSString *)stringClockWeek:(RWClockWeek)clockWeek;
+ (RWClockWeek)clockWeekWithString:(NSString *)weekString;

+ (NSString *)stringClockCycle:(RWClockCycle)cycle;
+ (RWClockCycle)cycleWithString:(NSString *)cycleString;

+ (RWMoment)momentWithDate:(NSDate *)systemDate;
+ (NSDate *)dateWithRWMoment:(RWMoment)moment;

+ (NSString *)stringRWTime:(RWTime)time;
+ (RWTime)timeWithString:(NSString *)timeString;

+ (NSString *)stringRWDate:(RWDate)date;
+ (RWDate)dateWithString:(NSString *)dateString;

+ (NSString *)stringRWMoment:(RWMoment)moment;
+ (RWMoment)momentWithString:(NSString *)momentString;


+ (NSString *)stringTimeWithClockAttribute:(RWClockAttribute)attribute;
+ (NSDate *)buildClockDateWithAfterDays:(NSInteger)afterDays
                                  Hours:(NSInteger)hours
                              AndMinute:(NSInteger)minute;

+ (BOOL)isPastTime:(NSInteger)hours minute:(NSInteger)minute;

+ (NSInteger)daysFromClockTimeWithClockWeek:(RWClockWeek)week
                              AndWeekString:(NSString *)weekString;
+ (NSInteger)distanceWithBeginMoments:(RWMoment)beginMoments
                        AndEndMoments:(RWMoment)endMomends;

@end
