//
//  RWDataModels.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RWOfficeItem : NSObject

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,strong)NSString *doctorList;

@end

@interface RWDoctorItem : NSObject

@property (nonatomic,strong)UIImage *header;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *professionalTitle;

@property (nonatomic,strong)NSString *office;

@property (nonatomic,strong)NSString *announcement;

@property (nonatomic,strong)NSDictionary *homeVisitList;

@property (nonatomic,strong)NSString *expenses;

@property (nonatomic,strong)NSString *EMID;

@property (nonatomic,strong)NSString *doctorDescription;

@end