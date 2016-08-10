//
//  RWDataBaseManager.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager.h"

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
    if(_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    [_managedObjectContext setPersistentStoreCoordinator:self.storeCoordinator];
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel)
    {
        return _managedObjectModel;
    }
    
    NSURL *baseModel = [[NSBundle mainBundle] URLForResource:@"PigeonDoctorDatabase" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:baseModel];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
    if(_storeCoordinator)
    {
        return _storeCoordinator;
    }
    
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc]
                                initWithManagedObjectModel: self.managedObjectModel];

    NSError *error = nil;
    NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentURL URLByAppendingPathComponent:__BASE_NAME__];
    
    [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil
                                              URL:storeURL
                                          options:nil
                                            error:&error];
    
    if (_storeCoordinator.persistentStores.count != 1 ||
        ![_storeCoordinator.persistentStores lastObject])
    {
        NSLog(@"create Base Fail reason : %@",error.description);
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
    
    if (fetchedObjects)
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
    if ([self existUser:user.username])
    {
        return [self updateUesr:user];
    }
    
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
    userInformation.umid = user.umid;
    userInformation.defaultUser = @(YES);
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@",user.username];
    NSString *name = NSStringFromClass([RWUserInformation class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count != 1)
    {
        return NO;
    }
    
    for (RWUserInformation *userInfo in result)
    {
        if (user.defaultUser)
        {
            NSArray *result = [self searchItemWithEntityName:name
                                                   predicate:nil
                                             sortDescriptors:nil];
            
            for (RWUserInformation *userInfo in result)
            {
                userInfo.defaultUser = @(NO);
            }
        }
        
        userInfo.name = user.name;
        userInfo.age = user.age;
        userInfo.gender = user.gender;
        userInfo.username = user.username;
        userInfo.password = user.password;
        userInfo.header = user.header;
        userInfo.umid = user.umid;
        userInfo.defaultUser = @(user.defaultUser);
    }
    
    return [self saveContext];
}

- (BOOL)existUser:(NSString *)username
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                                        @"username = %@",username];
    NSString *name = NSStringFromClass([RWUserInformation class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    if (result.count)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)removeUser:(RWUser *)user
{
    NSPredicate *predicate = user?[NSPredicate predicateWithFormat:@"username = %@",user.username]:nil;
    NSString *name = NSStringFromClass([RWUserInformation class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        for (RWUserInformation *userInfo in result)
        {
            [context deleteObject:userInfo];
        }
    }
    
    return [self saveContext];
}

- (RWUser *)getUser:(NSString *)username
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@",username];
    
    NSString *name = NSStringFromClass([RWUserInformation class]);
    
    NSArray *result = [self searchItemWithEntityName:name
                                           predicate:predicate
                                     sortDescriptors:nil];
    
    if (result.count)
    {
        for (RWUserInformation *userInfo in result)
        {
            RWUser *user = [[RWUser alloc] init];
            
            user.name = userInfo.name;
            user.age = userInfo.age;
            user.gender = userInfo.gender;
            user.username = userInfo.username;
            user.password = userInfo.password;
            user.header = userInfo.header;
            user.umid = userInfo.umid;
            user.defaultUser = userInfo.defaultUser.boolValue;
            
            return user;
        }
    }
    return nil;
}

- (RWUser *)getDefualtUser
{
    NSString *name = NSStringFromClass([RWUserInformation class]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"defaultUser = 1"];

    NSArray *fetchedObjects = [self searchItemWithEntityName:name
                                                   predicate:predicate
                                             sortDescriptors:nil];
    
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
            user.umid = userInfo.umid;
            user.defaultUser = userInfo.defaultUser.boolValue;
            
            return user;
        }
    }
    
    return nil;
}


@end
