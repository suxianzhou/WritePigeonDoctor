//
//  RWConsultNotesController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultNotesController.h"
#import "RWDoctorDescriptionController.h"

@interface RWConsultNotesController ()

@end

@implementation RWConsultNotesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self compositionConsultAgain];
    
    self.weChat.messages = [[self.baseManager getMessageWith:_history.doctorid] mutableCopy];
    
    for (int i = 0; i < self.weChat.messages.count; i++)
    {
        RWWeChatMessage *msg = self.weChat.messages[self.weChat.messages.count-i-1];
        
        if (msg.message.isRead)
        {
            break;
        }
        
        msg.message.isRead = YES;
        
        [self.baseManager updateCacheMessage:msg];
    }
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
    RWWeekHomeVisit *visit = [[RWWeekHomeVisit alloc] init];
    
    RWHomeVisitItem *visititem = [[RWHomeVisitItem alloc] init];
    
    visititem.morning = @"在 XXXX 路 XX 号 XXXXXX 坐诊";
    visititem.afternoon = @"在 XXXX 路 XX 号 XXXXXX 坐诊";
    visititem.night = @"在 XXXX 路 XX 号 XXXXXX 坐诊";
    
    visit.Monday = visititem;
    visit.Tuesday = visititem;
    visit.Wednesday = nil;
    visit.Thursday = nil;
    visit.Friday = nil;
    visit.Saturday = visititem;
    visit.Sunday = visititem;
    
    RWDoctorItem *item = [[RWDoctorItem alloc] init];
    
    item.umid = @"57a956b87019c94b65fc4d98";
    item.name = @"路人甲";
    item.professionalTitle = @"青岛市 XXX医院 著名医师";
    item.office = @"测试科室";
    item.announcement = @"这是一个测试公告";
    item.homeVisitList = visit;
    item.expenses = @[@"￥50.00元 / 2小时"];
    item.EMID = @"13792441528";
    item.doctorDescription = @"测试医生简介！！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！测试医生简介！";
    
    RWDoctorDescriptionController *doctor = [RWDoctorDescriptionController doctorDescroptionWith:item];
    
    [self.navigationController pushViewController:doctor animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
