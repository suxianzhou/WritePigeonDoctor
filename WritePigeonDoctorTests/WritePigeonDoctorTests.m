//
//  WritePigeonDoctorTests.m
//  WritePigeonDoctorTests
//
//  Created by zhongyu on 16/7/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWRequsetManager+UserLogin.h"
#import "RWDataBaseManager+ChatCache.h"

@interface WritePigeonDoctorTests : XCTestCase

@end

@implementation WritePigeonDoctorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testRegister
{
    RWRequsetManager *manager = [[RWRequsetManager alloc] init];
    
    [manager registerWithUsername:@"iOSTest002"
                      AndPassword:@"iOSTest002"
                 verificationCode:@""];
    
    
//    [manager userinfoWithUsername:@"12345678121" AndPassword:@"123"];
    
    CFRunLoopRun();
}

- (void)testAddUser
{
    RWDataBaseManager *defaultManager = [RWDataBaseManager defaultManager];
    
    RWUser *user = [[RWUser alloc] init];
    
    user.username = @"12345678910";
    user.password = @"123456";
    user.age = @"30";
    user.gender = @"男";
    user.header = nil;
    user.name = @"new";
    
    XCTAssertTrue([defaultManager addNewUesr:user]);
    XCTAssertTrue([defaultManager existUser:user.username]);
    
    RWUser *defaultUser = [defaultManager getDefualtUser];
    
    XCTAssertNotNil(defaultUser);
    
    NSLog(@"username = %@ \n password = %@ \n age = %@ gender = %@ \n header = %@ \n name = %@ \n defaultUser = %d",  defaultUser.username,
          defaultUser.password,
          defaultUser.age,
          defaultUser.gender,
          defaultUser.header,
          defaultUser.name,
          defaultUser.defaultUser);
    
    user.username = @"12345678910";
    user.password = @"123456";
    user.age = @"21";
    user.gender = @"woman";
    user.header = nil;
    user.name = @"heooo";
    user.defaultUser = YES;
    
    XCTAssertTrue([defaultManager updateUesr:user]);
    
    defaultUser = [defaultManager getDefualtUser];
    
    XCTAssertNotNil(defaultUser);
    
    NSLog(@"username = %@ \n password = %@ \n age = %@ gender = %@ \n header = %@ \n name = %@ \n defaultUser = %d",  defaultUser.username,
          defaultUser.password,
          defaultUser.age,
          defaultUser.gender,
          defaultUser.header,
          defaultUser.name,
          defaultUser.defaultUser);
    
}

- (void)testChangeSettings
{
    RWDataBaseManager *defaultManager = [RWDataBaseManager defaultManager];
    
    XCTAssertTrue([defaultManager removeUser:[defaultManager getDefualtUser]]);
    
    RWUser *defaultUser = [defaultManager getDefualtUser];
    
    XCTAssertNil(defaultUser);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
