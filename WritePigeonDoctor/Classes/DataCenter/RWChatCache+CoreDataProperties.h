//
//  RWChatCache+CoreDataProperties.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWChatCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWChatCache (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *content;
@property (nullable, nonatomic, retain) NSString *conversationId;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSString *from;
@property (nullable, nonatomic, retain) NSString *localPath;
@property (nullable, nonatomic, retain) NSString *messageid;
@property (nullable, nonatomic, retain) NSNumber *myMessage;
@property (nullable, nonatomic, retain) NSNumber *read;
@property (nullable, nonatomic, retain) NSString *remotePath;
@property (nullable, nonatomic, retain) NSNumber *success;
@property (nullable, nonatomic, retain) NSString *to;
@property (nullable, nonatomic, retain) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
