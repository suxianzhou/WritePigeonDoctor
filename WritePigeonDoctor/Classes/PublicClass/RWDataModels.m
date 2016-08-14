//
//  RWDataModels.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataModels.h"
#import "XZUMComPullRequest.h"
#import "UMComUser.h"
#import "UMComMacroConfig.h"
#import "UMComImageUrl.h"

@implementation RWOfficeItem @end
@implementation RWDoctorItem

- (void)setEMID:(NSString *)EMID
{
    _EMID = EMID;
    
    if (_EMID && _umid && !_header)
    {
        [self requestInformation];
    }
}

- (void)setUmid:(NSString *)umid
{
    _umid = umid;
    
    if (_EMID && _umid && !_header)
    {
        [self requestInformation];
    }
}

- (void)requestInformation
{
    [XZUMComPullRequest fecthUserMessageWithUid:_umid source:nil source_uid:_EMID completion:^(NSDictionary *responseObject, NSError *error) {
        
        UMComUser *umuser = responseObject[UMComModelDataKey];
        
        if (umuser.icon_url)
        {
            UMComImageUrl * imageUrl = umuser.icon_url;
            NSString * small = imageUrl.small_url_string;
            
            _header = small;
            
            _relation = umuser.has_followed.integerValue;
        }
    }];
}

@end
@implementation RWWeekHomeVisit @end
@implementation RWHomeVisitItem @end