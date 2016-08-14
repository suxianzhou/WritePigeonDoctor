//
//  RWDataBaseManager.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RWObjectModels.h"
#import "RWWeiChatView.h"
#import "RWUserInformation+CoreDataProperties.h"
#import "RWChatCache+CoreDataProperties.h"
#import "RWConsultHistory+CoreDataProperties.h"
#import "RWCollectMessage+CoreDataProperties.h"
#import "RWNameCard+CoreDataProperties.h"

@interface RWDataBaseManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic,strong,readonly)NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong,readonly)NSManagedObjectModel *managedObjectModel;

@property (nonatomic,strong,readonly)NSPersistentStoreCoordinator *storeCoordinator;

- (BOOL)saveContext;
- (NSArray *)searchItemWithEntityName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

- (BOOL)addNewUesr:(RWUser *)user;
- (BOOL)updateUesr:(RWUser *)user;
- (BOOL)existUser:(NSString *)username;
- (BOOL)removeUser:(RWUser *)user;

- (RWUser *)getDefualtUser;
- (RWUser *)getUser:(NSString *)username;

+ (BOOL)perfectPersonalInformation;

@end
