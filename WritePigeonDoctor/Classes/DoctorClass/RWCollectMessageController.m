//
//  RWCollectMessageController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCollectMessageController.h"
#import "RWDoctorDescriptionController.h"
#import "RWDataBaseManager+NameCardCollectMessage.h"

@interface RWCollectMessageController ()

<
    RWRequsetDelegate
>

@property (nonatomic,strong)RWRequsetManager *requestManager;

@end

@implementation RWCollectMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self compositionConsultAgain];
    
    self.weChat.messages = [[self.baseManager getCollectMessageWith:_card.doctorid] mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.weChat reloadData];
}

- (void)compositionConsultAgain
{
    UIView *coverLayer = [[UIView alloc] init];
    [self.view addSubview:coverLayer];
    
    [coverLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@(49));
    }];
    
    coverLayer.backgroundColor = [UIColor whiteColor];
    coverLayer.layer.borderColor = [[UIColor grayColor] CGColor];
    coverLayer.layer.borderWidth = 0.5f;
    coverLayer.layer.shadowColor = [[UIColor colorWithWhite:0.3f alpha:1.0f] CGColor];
    coverLayer.layer.shadowOffset = CGSizeMake(0, 0);
    coverLayer.layer.shadowRadius = 10.f;
    coverLayer.layer.shadowOpacity = 0.3f;
    
    UIButton *consultAgain = [[UIButton alloc] init];
    [coverLayer addSubview:consultAgain];
    
    [consultAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(coverLayer.mas_left).offset(50);
        make.right.equalTo(coverLayer.mas_right).offset(-50);
        make.bottom.equalTo(coverLayer.mas_bottom).offset(-5);
        make.top.equalTo(coverLayer.mas_top).offset(5);
    }];
    
    consultAgain.layer.cornerRadius = 10.f;
    consultAgain.backgroundColor = __WPD_MAIN_COLOR__;
    
    [consultAgain setTitle:@"再次咨询" forState:UIControlStateNormal];
    [consultAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [consultAgain addTarget:self
                     action:@selector(toConsultAgain)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)toConsultAgain
{
    [_requestManager obtainDoctorWithDoctorID:_card.doctorid];
}

- (void)requsetOfficeDoctor:(RWDoctorItem *)doctor responseMessage:(NSString *)responseMessage
{
    if (doctor)
    {
        [[RWDataBaseManager defaultManager] addNameCardWithItem:doctor
                                                     completion:^(BOOL success)
        {
            if (!success)
            {
                [MBProgressHUD Message:@"名片更新失败" For:self.tabBarController.view];
            }
        }];
        
        RWDoctorDescriptionController *doctorView = [RWDoctorDescriptionController doctorDescroptionWith:doctor];
        
        [self.navigationController pushViewController:doctorView animated:YES];
        
        return;
    }
    
    [RWSettingsManager promptToViewController:self Title:responseMessage response:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
