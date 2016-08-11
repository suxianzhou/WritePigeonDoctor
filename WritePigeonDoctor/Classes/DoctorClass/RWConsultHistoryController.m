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
#import "RWMainTabBarController.h"
#import "RWConsultNotesController.h"

@interface RWConsultHistoryController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)UITableView *historyList;
@property (nonatomic,strong)NSArray *historys;

@property (nonatomic,strong)RWDataBaseManager *baseManager;

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
    RWConsultNotesController *notesController = [[RWConsultNotesController alloc] init];
    
    notesController.history = _historys[indexPath.row];
    
    [self pushNextWithViewcontroller:notesController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"咨询历史";
    _baseManager = [RWDataBaseManager defaultManager];
    
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([RWChatManager defaultManager].connectionState)
    {
        [self.tabBarController toLoginViewController];
        
        RWMainTabBarController *tabBar = (RWMainTabBarController *)self.tabBarController;
        
        [tabBar toRootViewController];
        
        return;
    }
    
    _historys = [_baseManager getConsultHistory];
    
    [_historyList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
