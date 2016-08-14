//
//  RWRequsetManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWDataModels.h"
#import <objc/runtime.h>

@interface RWRequsetManager ()


@end

@implementation RWRequsetManager

#pragma mark - init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _errorDescription = @{@"200":@"操作成功",
                              @"201":@"客户端版本不对，需升级sdk",
                              @"301":@"被封禁",
                              @"302":@"用户名或密码错误",
                              @"315":@"IP限制",
                              @"403":@"非法操作或没有权限",
                              @"404":@"对象不存在",
                              @"405":@"参数长度过长",
                              @"406":@"对象只读",
                              @"408":@"客户端请求超时",
                              @"413":@"验证失败(短信服务)",
                              @"414":@"参数错误",
                              @"415":@"客户端网络问题",
                              @"416":@"频率控制",
                              @"417":@"重复操作",
                              @"418":@"通道不可用(短信服务)",
                              @"419":@"数量超过上限",
                              @"422":@"账号被禁用",
                              @"431":@"HTTP重复请求"};
    }
    
    return self;
}

- (void)obtainOfficeList
{
    [_requestManager GET:__OFFICE_LIST__ parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *JsonArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (JsonArr)
        {
            NSMutableArray *offices = [[NSMutableArray alloc] init];
            
            for (NSDictionary *item in JsonArr)
            {
                RWOfficeItem *office = [[RWOfficeItem alloc] init];
                
                office.image = item[@"officeimage"];
                office.doctorList = item[@"doctorlist"];
                
                [offices addObject:office];
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeList:responseMessage:)])
            {
                [_delegate requsetOfficeList:offices responseMessage:nil];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeList:responseMessage:)])
            {
                [_delegate requsetOfficeList:nil responseMessage:@"服务器信息获取失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeList:responseMessage:)])
            {
                [_delegate requsetOfficeList:nil responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeList:responseMessage:)])
            {
                [_delegate requsetOfficeList:nil responseMessage:@"服务器连接失败"];
            }
        }
    }];
}

- (void)obtainOfficeDoctorListWithURL:(NSString *)url page:(NSInteger)page
{
    [_requestManager POST:url parameters:@{@"udid":__TOKEN_KEY__,@"page":@(page)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultcode"] integerValue] == 200)
        {
            NSArray *doctors = Json[@"result"];
            
            NSMutableArray *doctorItem = [[NSMutableArray alloc] init];
            
            for (NSDictionary *doctor in doctors)
            {
                RWDoctorItem *item = [[RWDoctorItem alloc] init];
                
                item.name = @"";
                item.doctorDescription = doctor[@"docdp"];
                item.expenses = [doctor[@"expenses"] isKindOfClass:[NSArray class]]?
                                doctor[@"expenses"]:
                                @[@"￥0.00元/小时"];
                item.EMID = doctor[@"username"];
                item.office = doctor[@"grouptitle"];
                item.umid = @"";
                item.professionalTitle = [NSString stringWithFormat:@"%@  %@",doctor[@"hos"],doctor[@"title"]];
                item.announcement = doctor[@"notice"];
                
                if (doctor[@"homevisitlist"] && [doctor[@"homevisitlist"] length] != 0)
                {
                    RWWeekHomeVisit *home = [[RWWeekHomeVisit alloc] init];
                    
                    NSArray *homeKeys = [RWSettingsManager obtainAllKeysWithObjectClass:[RWWeekHomeVisit class]];
                    
                    for (NSString *homeKey in homeKeys)
                    {
                        if (doctor[@"homevisitlist"][homeKey])
                        {
                            RWHomeVisitItem *visitItem;
                            
                            NSArray *itemKeys = [RWSettingsManager obtainAllKeysWithObjectClass:[RWWeekHomeVisit class]];
                            
                            for (NSString *itemKey in itemKeys)
                            {
                                if (doctor[@"homevisitlist"][homeKey][itemKey])
                                {
                                    visitItem = visitItem?visitItem:[[RWHomeVisitItem alloc] init];
                                    
                                    [visitItem setValue:doctor[@"homevisitlist"][homeKey][itemKey] forKey:itemKey];
                                }
                                
                                if (visitItem)
                                {
                                    [home setValue:visitItem forKey:homeKey];
                                }
                            }
                        }
                    }
                    
                    item.homeVisitList = home;
                }
                
                [doctorItem addObject:item];
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctorList:responseMessage:)])
            {
                [_delegate requsetOfficeDoctorList:doctorItem responseMessage:nil];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctorList:responseMessage:)])
            {
                [_delegate requsetOfficeDoctorList:nil responseMessage:Json[@"result"]];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctorList:responseMessage:)])
            {
                [_delegate requsetOfficeDoctorList:nil
                                   responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctorList:responseMessage:)])
            {
                [_delegate requsetOfficeDoctorList:nil
                                   responseMessage:@"服务器连接失败"];
            }
        }

    }];
}

- (void)obtainDoctorWithDoctorID:(NSString *)doctorID
{
    [_requestManager POST:__SEARCH_DOCTOR__
               parameters:@{@"username":doctorID}
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([Json[@"resultcode"] integerValue] == 200)
        {
            NSDictionary *doctor = Json[@"result"];
            
            RWDoctorItem *item = [[RWDoctorItem alloc] init];
            
            item.name = @"";
            item.doctorDescription = doctor[@"docdp"];
            item.expenses = [doctor[@"expenses"] isKindOfClass:[NSArray class]]?
            doctor[@"expenses"]:
            @[@"￥0.00元/小时"];
            item.EMID = doctor[@"username"];
            item.office = doctor[@"grouptitle"];
            item.umid = @"";
            item.professionalTitle = [NSString stringWithFormat:@"%@  %@",doctor[@"hos"],doctor[@"title"]];
            item.announcement = doctor[@"notice"];
            
            if (doctor[@"homevisitlist"] && [doctor[@"homevisitlist"] length] != 0)
            {
                RWWeekHomeVisit *home = [[RWWeekHomeVisit alloc] init];
                
                NSArray *homeKeys = [RWSettingsManager obtainAllKeysWithObjectClass:[RWWeekHomeVisit class]];
                
                for (NSString *homeKey in homeKeys)
                {
                    if (doctor[@"homevisitlist"][homeKey])
                    {
                        RWHomeVisitItem *visitItem;
                        
                        NSArray *itemKeys = [RWSettingsManager obtainAllKeysWithObjectClass:[RWWeekHomeVisit class]];
                        
                        for (NSString *itemKey in itemKeys)
                        {
                            if (doctor[@"homevisitlist"][homeKey][itemKey])
                            {
                                visitItem = visitItem?visitItem:[[RWHomeVisitItem alloc] init];
                                
                                [visitItem setValue:doctor[@"homevisitlist"][homeKey][itemKey] forKey:itemKey];
                            }
                            
                            if (visitItem)
                            {
                                [home setValue:visitItem forKey:homeKey];
                            }
                        }
                    }
                }
                
                item.homeVisitList = home;
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctor:responseMessage:)])
            {
                [_delegate requsetOfficeDoctor:item
                                responseMessage:nil];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctor:responseMessage:)])
            {
                [_delegate requsetOfficeDoctor:nil
                               responseMessage:Json[@"result"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!__NET_STATUS__)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctor:responseMessage:)])
            {
                [_delegate requsetOfficeDoctor:nil
                               responseMessage:@"网络连接失败，请检查网络"];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requsetOfficeDoctor:responseMessage:)])
            {
                [_delegate requsetOfficeDoctor:nil
                               responseMessage:@"服务器连接失败"];
            }
        }
    }];
}

@end
