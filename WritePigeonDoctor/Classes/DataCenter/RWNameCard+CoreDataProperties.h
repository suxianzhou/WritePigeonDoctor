//
//  RWNameCard+CoreDataProperties.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWNameCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWNameCard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *umid;
@property (nullable, nonatomic, retain) NSString *professionTitle;
@property (nullable, nonatomic, retain) NSString *office;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *header;
@property (nullable, nonatomic, retain) NSString *doctorid;
@property (nullable, nonatomic, retain) NSString *doctorDescription;

@end

NS_ASSUME_NONNULL_END
