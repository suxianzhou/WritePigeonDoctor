//
//  FollowingTableViewController.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "FollowingTableViewController.h"
#import "RWDoctorListCell.h"
#import "RWDoctorDescriptionController.h"
#import "XZUMComPullRequest.h"
#import "FollowingModel.h"
#import "MJRefresh.h"
#import "UMComUser.h"
static NSString * TableViewCellIdentifier = @"TableViewCellIdentifier";

@interface FollowingTableViewController ()<UITableViewDelegate,UITableViewDataSource,RWRequsetDelegate>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *userList;
@property (nonatomic, strong) FollowingModel * model;
@property (nonatomic,strong)RWRequsetManager *requestManager;
@property (nonatomic, strong)RWDoctorItem * item;
@end

@implementation FollowingTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    
    _requestManager = [[RWRequsetManager alloc] init];
    _requestManager.delegate = self;
    
    [self initViews];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)initViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UITableView alloc]init];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [_tableView registerClass:[RWDoctorListCell class]
        forCellReuseIdentifier:NSStringFromClass([RWDoctorListCell class])];
    
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                       refreshingAction:@selector(refreshHeaderAction:)];
    _tableView.mj_header.tintColor=[UIColor blueColor];
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                           refreshingAction:@selector(refreshFooterAction:)];
    _tableView.mj_footer.hidden = YES;
    
    [self loadRequest];

}

- (void)loadRequest
{
   WEAKSELF
   RWUser * user  = [[RWDataBaseManager defaultManager] getDefualtUser];
    [XZUMComPullRequest fecthUserFollowingsWithUid:user.umid count:20 completion:^(NSDictionary *responseObject, NSError *error) {
       if (!error) {
            NSArray * listArr = responseObject[@"data"];
         if (listArr.count > 0) {
        
           for (UMComUser * umser in listArr) {
            
               if (umser.source_uid) {
                 
                   [weakSelf.userList addObject:umser.source_uid];
                   
               }
            }
          }
        
           [weakSelf.tableView reloadData];
       }
    }];

}

- (void)ferchFollowing
{
  
    
}

#pragma mark - Properties

- (FollowingModel*)model
{
    if (!_model)
    {
        _model=[FollowingModel new];
    }
    return _model;
}

- (NSMutableArray *)userList
{
    if (!_userList) {
        _userList = [[NSMutableArray alloc]init];
    }
    return _userList;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWDoctorListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDoctorListCell class]) forIndexPath:indexPath];
    
    [_requestManager obtainDoctorWithDoctorID:self.userList[indexPath.row]];
    
    cell.doctor = _item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_requestManager obtainDoctorWithDoctorID:self.userList[indexPath.row]];
    
    RWDoctorDescriptionController *doctor = [RWDoctorDescriptionController doctorDescroptionWith:_item];
    
   [self pushNextWithViewcontroller:doctor];
}

#pragma mark - Actions
-(void)refreshHeaderAction:(MJRefreshHeader *) header
{
    NSLog(@"%s",__func__);
    
    [self.tableView.mj_header endRefreshing];
}

-(void)refreshFooterAction:(MJRefreshFooter *) footer
{
    NSLog(@"%s",__func__);
    [self requestForNextPage];
}

-(void)requestForNextPage
{
    [self.tableView.mj_footer endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requsetOfficeDoctor:(RWDoctorItem *)doctor responseMessage:(NSString *)responseMessage
{
    if (doctor) {
        _item = doctor;
        return;
    }
    
    [RWSettingsManager promptToViewController:self Title:responseMessage response:nil];
}

@end
