//
//  FeedBackModel.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "FeedBackModel.h"

@interface FeedBackModel ()

@property (nonatomic,strong)AFHTTPSessionManager *requestManager;
@property (nonatomic,copy)   NSDictionary *responseDic;
@end

@implementation FeedBackModel

-(void)uploadAdvice:(NSString *) advice
{
    __weak __block typeof(self) weakSelf=self;
    NSDictionary *body = @{@"advice":advice};
    [self.requestManager POST:@"www.zhongyuedu.com/api/advice.php" parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",task);
        
        NSDictionary *responseDic=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
        weakSelf.responseDic=responseDic;
        if ([self requestResultIsCorrect])
        {
          [weakSelf showSV];
        }
        else
        {
          [weakSelf showSV];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
         [weakSelf showSV];
        
    }];
    
}
-(BOOL)requestResultIsCorrect
{
    NSInteger resultCode=[self.responseDic[@"resultCode"] integerValue];
    BOOL isCorrect=NO;
    if (resultCode==0)
    {
        isCorrect=YES;
    }
    return isCorrect;
}
-(NSDictionary *)responseDic
{
    if (!_responseDic)
    {
        _responseDic=@{};
    }
    return _responseDic;
}
- (AFHTTPSessionManager *)requestManager
{
    if (_requestManager) {
        _requestManager = [AFHTTPSessionManager manager];
    }
    return _requestManager;
}

- (void)showSV
{
    [SVProgressHUD setMinimumDismissTimeInterval:1000];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showInfoWithStatus:@"感谢你的建议！"];
    
}


@end
