//
//  RWMainViewController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainViewController.h"
#import "RWCustomizeToolBar.h"
#import <WebKit/WebKit.h>

@interface RWMainViewController ()

<
    UIAlertViewDelegate,
    WKNavigationDelegate,
    WKUIDelegate,
    RWCustomizeWebToolBarDelegate
>

@property (nonatomic,strong)WKWebView *informationView;

@end

@implementation RWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self.tabBarController.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:99 atIndex:1];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.alpha = 0.0f;
    
    self.navigationItem.title = @"白鸽医生";
    
    _informationView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    _informationView.UIDelegate = self;
    _informationView.navigationDelegate = self;
    
    [self.view addSubview:_informationView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:@"http://www.zhongyuedu.com/tgm/test/test18"];
    
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    
    [_informationView loadRequest:requset];
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
