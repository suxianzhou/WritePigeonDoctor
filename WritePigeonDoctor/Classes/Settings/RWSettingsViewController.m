//
//  RWSettingsViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSettingsViewController.h"
#import "UMComSimplicityDiscoverViewController.h"
#import "UMComSession.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComNotificationMacro.h"
#import "UITabBar+badge.h"
@interface RWSettingsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) UIView *userMessageView;//通知的小红点
@end

@implementation RWSettingsViewController

#pragma --- life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews:) name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        
        self.userMessageView.hidden = NO;
        [self.tabBarController.tabBar setBadgeStyle:1 value:12 atIndex:3];
    }
    else
    {
        self.userMessageView.hidden = YES;
        [self.tabBarController.tabBar setBadgeStyle:2 value:0 atIndex:3];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人中心";
    [self.view addSubview:self.tableView];
}

#pragma --- Lazy loading

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.frame = self.view.bounds;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma --- TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"我的社区";
    CGFloat padding = 2;
    CGFloat defaultNoticeViewOriginX = 115;
    CGSize nameSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
    CGFloat noticeViewOriginX = cell.textLabel.frame.origin.x + nameSize.width + padding;
    if (noticeViewOriginX >= cell.contentView.bounds.size.width) {
        //大于cell的宽度就减去padding
        noticeViewOriginX = cell.contentView.bounds.size.width - padding;
    }
    else if (noticeViewOriginX <= 0)
    {
        //小于0就用默认
        noticeViewOriginX = defaultNoticeViewOriginX;
    }
    self.userMessageView = [self creatNoticeViewWithOriginX:noticeViewOriginX];
    self.userMessageView.center = CGPointMake(self.userMessageView.center.x+11, cell.textLabel.frame.origin.y+11);
    [cell.contentView addSubview:self.userMessageView];
    return cell;
}

#pragma --- TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComSimplicityDiscoverViewController * VC = [[UMComSimplicityDiscoverViewController alloc] init];
    [self pushNextWithViewcontroller:VC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX
{
    CGFloat noticeViewWidth = 7;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,0, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        itemNoticeView.hidden = NO;
    }
    else
    {
        itemNoticeView.hidden = YES;
    }
    return itemNoticeView;
}
- (void)refreshNoticeItemViews:(NSNotification*)notification
{
    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount > 0) {
        self.userMessageView.hidden = NO;
    }
    else
    {
        self.userMessageView.hidden = YES;
    }
    
}

@end
