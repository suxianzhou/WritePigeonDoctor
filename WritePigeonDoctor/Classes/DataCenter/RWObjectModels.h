//
//  RWObjectModels.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/7.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWUser : NSObject

@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSData *header;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *umid;
@property (nonatomic, assign) BOOL defaultUser;

@end

@interface RWHistory : NSObject

@property (nonatomic, retain) NSString *doctorDescription;
@property (nonatomic, retain) NSString *doctorid;
@property (nonatomic, retain) NSData *header;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *office;
@property (nonatomic, retain) NSString *professionTitle;
@property (nonatomic, retain) NSString *umid;

@end
