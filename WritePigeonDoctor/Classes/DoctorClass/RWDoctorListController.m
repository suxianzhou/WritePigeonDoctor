//
//  RWDoctorListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorListController.h"

@interface RWDoctorListController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *doctorList;
@property (nonatomic,strong)NSArray *officeList;

@end

@implementation RWDoctorListController

- (void)initViews
{
    _doctorList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_doctorList];
    
    _doctorList.showsVerticalScrollIndicator = NO;
    _doctorList.showsHorizontalScrollIndicator = NO;
    
    _doctorList.delegate = self;
    _doctorList.dataSource = self;
    
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
