//
//  RWDoctorDescriptionController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorDescriptionController.h"
#import "RWDescriptionView.h"
#import "RWDataModels.h"

@interface RWDoctorDescriptionController ()

@property (nonatomic,strong)RWDescriptionView *descriptionView;
@property (nonatomic,copy)RWDoctorItem *(^doctorItem)();

@end

@implementation RWDoctorDescriptionController

+ (instancetype)doctorDescroptionWith:(RWDoctorItem *(^)())doctorItem
{
    RWDoctorDescriptionController *doctordes =
                                        [[RWDoctorDescriptionController alloc] init];
    
    doctordes.doctorItem = doctorItem;
    
    return doctordes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _descriptionView = [[RWDescriptionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_descriptionView];
    
    _descriptionView.item = _doctorItem();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_descriptionView reloadData];
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
