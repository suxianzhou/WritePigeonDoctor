//
//  RWDoctorListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorListController.h"
#import "RWDoctorListCell.h"
#import "RWDoctorDescriptionController.h"

@interface RWDoctorListController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *doctorList;

@end

@implementation RWDoctorListController

- (void)initViews
{
    _doctorList = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    [self.view addSubview:_doctorList];
    
    [_doctorList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorDescriptionController *doctor = [RWDoctorDescriptionController doctorDescroptionWith:_doctorResource[indexPath.row]];
    
    [self pushNextWithViewcontroller:doctor];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"医生列表";
    
    [self initViews];
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:__IMAGE_FINISH__
//                                                      object:nil
//                                                       queue:[NSOperationQueue mainQueue]
//                                                  usingBlock:^(NSNotification * _Nonnull note)
//    {
//        if (_doctorList)
//        {
//            [_doctorList reloadData];
//        }
//    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_doctorList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
