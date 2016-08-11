//
//  RWDoctorDescriptionController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorDescriptionController.h"
#import "RWConsultViewController.h"
#import "RWDescriptionView.h"
#import "RWDataModels.h"
#import "RWDataBaseManager+ChatCache.h"

@interface RWDoctorDescriptionController ()

<
    RWDescriptionViewDelegate,
    RWRegisterOfficeViewDelegate
>

@property (nonatomic,strong)RWDescriptionView *descriptionView;
@property (nonatomic,strong)RWRegisterOfficeView *officeView;

@end

@implementation RWDoctorDescriptionController

+ (instancetype)doctorDescroptionWith:(RWDoctorItem *)doctorItem
{
    RWDoctorDescriptionController *doctordes =
                                        [[RWDoctorDescriptionController alloc] init];
    
    doctordes.doctorItem = doctorItem;
    
    return doctordes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    
    frame.size.height -= self.navigationController.navigationBar.bounds.size.height + 20;
    
    _descriptionView = [[RWDescriptionView alloc] initWithFrame:frame];
    [self.view addSubview:_descriptionView];

    _descriptionView.eventSource = self;
    _descriptionView.item = _doctorItem;
    
    frame.origin.y = frame.size.height - 40;
    frame.size.height = 40;
    
    _officeView = [[RWRegisterOfficeView alloc] initWithFrame:frame];
    [self.view addSubview:_officeView];
    
    _officeView.delegate = self;
    
    _officeView.contentLabel.text = _descriptionView.item.expenses.count?_descriptionView.item.expenses[0]:nil;
    
    self.navigationItem.title = _descriptionView.item.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_descriptionView.item)
    {
        [_descriptionView reloadData];
    }
}

- (void)setDoctorItem:(RWDoctorItem *)doctorItem
{
    _doctorItem = doctorItem;
    
    _descriptionView.item = doctorItem;
    
    if (_descriptionView.item)
    {
        [_descriptionView reloadData];
    }
}

#pragma mark - delegate

- (void)startConsultAtRegisterOffice:(RWRegisterOfficeView *)registerOffice
{
    RWChatManager *chatManager = [RWChatManager defaultManager];
    
    if (chatManager.connectionState)
    {
        [self.tabBarController toLoginViewController];
        
        return;
    }
    
    RWConsultViewController *chatView = [[RWConsultViewController alloc] init];
    
    chatView.item = _doctorItem;
    
    RWDataBaseManager *baseManager = [RWDataBaseManager defaultManager];
    
    if ([baseManager addConsultHistoryWithItem:chatView.item])
    {
        [self pushNextWithViewcontroller:chatView];
    }
}

- (void)consultWayAtRegisterOffice:(RWRegisterOfficeView *)registerOffice
{
    MESSAGE(@"资讯方式选择");
}

#pragma mark - event

- (void)isAttentionAtDescriptionView:(RWDescriptionView *)descriptionView
{
    MESSAGE(@"点击关注");
}

- (void)isShowDoctorDescription:(RWDescriptionView *)descriptionView
{
    if (descriptionView.isOpenDescription)
    {
        _officeView.hidden = YES;
    }
    else
    {
        _officeView.hidden = NO;
    }
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
