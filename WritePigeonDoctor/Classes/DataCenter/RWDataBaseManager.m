//
//  RWDataBaseManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager.h"
#import "RWUserInformation+CoreDataProperties.h"
#import "RWChatCache+CoreDataProperties.h"
#import "RWConsultHistory+CoreDataProperties.h"

#define __BASE_NAME__ @"PigeonDoctorDatabase.sqlite"

@implementation RWDataBaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize storeCoordinator = _storeCoordinator;

+ (instancetype)defaultManager
{
    static RWDataBaseManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _defaultManager = [super allocWithZone:NULL];
    });
    
    return _defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [RWDataBaseManager defaultManager];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [RWDataBaseManager defaultManager];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [RWDataBaseManager defaultManager];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    [_managedObjectContext setPersistentStoreCoordinator:self.storeCoordinator];
    
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *baseModel = [[NSBundle mainBundle] URLForResource:@"PigeonDoctorDatabase" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:baseModel];
    
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_storeCoordinator!=nil)
    {
        return _storeCoordinator;
    }
    
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc]
                                initWithManagedObjectModel: self.managedObjectModel];
    NSString *basePath = [__SANDBOX_PATH__ stringByAppendingPathComponent:__BASE_NAME__];
    NSURL *storeURL= [NSURL URLWithString:basePath];
    NSError *error = nil;
    
    [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil
                                              URL:storeURL
                                          options:nil
                                            error:&error];
    
    if (_storeCoordinator.persistentStores.count != 1 ||
        ![_storeCoordinator.persistentStores lastObject])
    {
        NSLog(@"create Base Fail reason : %@",error.description);
        abort();
    }
    
    return _storeCoordinator;
}

- (BOOL)saveContext
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    if (context)
    {
        NSError *error = nil;
        
        if (context.hasChanges && ![context save:&error])
        {
            NSLog(@"%@",error.description);
            return NO;
        }
    }
    
    return YES;
}

- (NSArray *)searchItemWithEntityName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil)
    {
        return fetchedObjects;
    }
    
    if (error)
    {
        NSLog(@"%@",error.description);
    }
    
    return nil;
}

- (BOOL)addNewUesr:(RWUser *)user
{
    NSString *name = NSStringFromClass([RWUserInformation class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    RWUserInformation *userInformation =
                        [NSEntityDescription insertNewObjectForEntityForName:name
                                                      inManagedObjectContext:context];
    userInformation.name = user.name;
    userInformation.age = user.age;
    userInformation.gender = user.gender;
    userInformation.username = user.username;
    userInformation.password = user.password;
    userInformation.header = user.header;
    userInformation.defaultUser = @(YES);
    
//    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:name];
//    
//    if (!fetch.entity)
//    {
//        return NO;
//    }
//    
//    NSError *error = nil;
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:nil
                                     sortDescriptors:nil];
    
    for (RWUserInformation *userInfo in result)
    {
        userInfo.defaultUser = @(NO);
    }
    
    return [self saveContext];
}

- (BOOL)updateUesr:(RWUser *)user
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = '%@'",user.username];
    NSString *name = NSStringFromClass([RWUserInformation class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:name];
    
    fetch.predicate = predicate;
    
    if (!fetch.entity)
    {
        return NO;
    }
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:fetch
                                             error:&error];
    
    if (result.count != 1)
    {
        return NO;
    }
    
    for (RWUserInformation *userInfo in result)
    {
        userInfo.name = user.name;
        userInfo.age = user.age;
        userInfo.gender = user.gender;
        userInfo.username = user.username;
        userInfo.password = user.password;
        userInfo.header = user.header;
        userInfo.defaultUser = @(user.defaultUser);
    }
    
    return [self saveContext];
}



- (RWUser *)getDefualtUser
{
    NSString *name = NSStringFromClass([RWUserInformation class]);
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"defaultUser = 1"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count)
    {
        for (RWUserInformation *userInfo in fetchedObjects)
        {
            RWUser *user = [[RWUser alloc] init];
            
            user.name = userInfo.name;
            user.age = userInfo.age;
            user.gender = userInfo.gender;
            user.username = userInfo.username;
            user.password = userInfo.password;
            user.header = userInfo.header;
            user.defaultUser = userInfo.defaultUser.boolValue;
            
            return user;
        }
    }
    
    return nil;
}


@end
