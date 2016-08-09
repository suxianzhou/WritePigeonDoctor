//
//  RWConsultHistoryController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWConsultHistoryController.h"
#import "RWDoctorListCell.h"
#import "RWDoctorDescriptionController.h"
#import "RWDataBaseManager+ChatCache.h"

@interface RWConsultHistoryController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *historyList;
@property (nonatomic,strong)NSArray *historys;

@end

@implementation RWConsultHistoryController

- (void)initViews
{
    _historyList = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    [self.view addSubview:_historyList];
    
    _historyList.showsVerticalScrollIndicator = NO;
    _historyList.showsHorizontalScrollIndicator = NO;
    
    _historyList.delegate = self;
    _historyList.dataSource = self;
    
    [_historyList registerClass:[RWDoctorListCell class]
        forCellReuseIdentifier:NSStringFromClass([RWDoctorListCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDoctorListCell class]) forIndexPath:indexPath];
    
    cell.history = _historys[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"咨询历史";
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    RWDataBaseManager *baseManager = [RWDataBaseManager defaultManager];
    _historys = [baseManager getConsultHistory];
    
    [_historyList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
