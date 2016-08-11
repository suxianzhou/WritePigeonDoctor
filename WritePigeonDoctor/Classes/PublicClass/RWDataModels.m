//
//  RWDataModels.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataModels.h"
#import "XZUMComPullRequest.h"

@implementation RWOfficeItem @end
@implementation RWDoctorItem

- (void)setEMID:(NSString *)EMID
{
    _EMID = EMID;
    
    if (_EMID && _umid && !_header)
    {
        [self requestImage];
    }
}

- (void)setUmid:(NSString *)umid
{
    _umid = umid;
    
    if (_EMID && _umid && !_header)
    {
        [self requestImage];
    }
}

- (void)requestImage
{
    [XZUMComPullRequest fecthUserProfileWithUid:_umid
                                         source:nil
                                     source_uid:_EMID
                                     completion:^(NSString *imageStr)
     {
         _header = imageStr;
     }];
}

@end
@implementation RWWeekHomeVisit @end
@implementation RWHomeVisitItem @end