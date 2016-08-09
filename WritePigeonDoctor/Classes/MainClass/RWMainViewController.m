//
//  RWMainViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainViewController.h"
#import "RWCustomizeToolBar.h"
#import "RWOfficeListController.h"
#import <WebKit/WebKit.h>

@interface RWMainViewController ()

<
    UIAlertViewDelegate,
    WKNavigationDelegate,
    WKUIDelegate,
    WKScriptMessageHandler,
    RWCustomizeWebToolBarDelegate
>

@property (nonatomic,strong)WKWebView *informationView;

@end

@implementation RWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"白鸽医生";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 0;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addScriptMessageHandler:self name:@"LookForDoctor"];
    [config.userContentController addScriptMessageHandler:self name:@"MakeQuestion"];
    
    _informationView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                          configuration:config];
    [self.view addSubview:_informationView];
    
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _informationView.UIDelegate = self;
    _informationView.navigationDelegate = self;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"LookForDoctor"])
    {
        RWOfficeListController *office = [[RWOfficeListController alloc] init];
        
        [self pushNextWithViewcontroller:office];
    }
    else if ([message.name isEqualToString:@"MakeQuestion"])
    {
        NSLog(@"question");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSURL *url = [NSURL URLWithString:@"http://www.zhongyuedu.com/tgm/test/test18"];
    
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    
    [_informationView loadRequest:requset];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
{
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//    
//    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
//    
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    
//    if ([webView.URL.absoluteString isEqualToString:MAIN_INDEX.absoluteString])
//    {
//        [self removeWebToolBar];
//    }
//    else
//    {
//        [self addWebToolBar];
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_informationView.isLoading)
        {
            [SVProgressHUD dismiss];
        }
    });
}

- (void)removeWebToolBar
{
    UIView *view = [self.tabBarController.tabBar viewWithTag:160701];
    
    if (view)
    {
        [view removeFromSuperview];
    }
}

- (void)webToolBar:(RWCustomizeWebToolBar *)webToolBar didClickWithType:(RWWebToolBarType)type
{
    switch (type)
    {
        case RWWebToolBarTypeOfPrevious:
        {
            [_informationView goBack];
            
            break;
        }
        case RWWebToolBarTypeOfIndex:
        {
//            NSURLRequest *requset = [NSURLRequest requestWithURL:MAIN_INDEX];
//            
//            [_informationView loadRequest:requset];
            
            break;
        }
        case RWWebToolBarTypeOfShared:
            
            break;
            
        default:
            break;
    }
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
