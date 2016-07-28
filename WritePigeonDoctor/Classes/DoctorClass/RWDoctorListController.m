//
//  RWDoctorListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorListController.h"
#import "RWDoctorListCell.h"

@interface RWDoctorListController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *doctorList;
@property (nonatomic,strong)NSArray *doctorResource;

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
    
    [_doctorList registerClass:[RWDoctorListCell class]
        forCellReuseIdentifier:NSStringFromClass([RWDoctorListCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _doctorResource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDoctorListCell class]) forIndexPath:indexPath];
    
    cell.doctor = _doctorResource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
