//
//  RWDoctorDescriptionController.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWPDBaseController.h"

@interface RWDoctorDescriptionController : RWWPDBaseController

+ (instancetype)doctorDescroptionWith:(RWDoctorItem *)doctorItem;

@property (nonatomic,strong)RWDoctorItem *doctorItem;

@end
