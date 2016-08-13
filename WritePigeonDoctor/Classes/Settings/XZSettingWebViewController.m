//
//  XZSettingWebViewController.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "XZSettingWebViewController.h"
#import <WebKit/WebKit.h>

#import "WPD_SVProgressHUD.h"
@interface XZSettingWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *web;

@end

@implementation XZSettingWebViewController

@synthesize web;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    web = [[WKWebView alloc] init];
    web.UIDelegate = self;
    web.navigationDelegate = self;
    
    [self.view addSubview:web];
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SHOWLOADING;
    
    if (_url)
    {
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        
        [web loadRequest:requset];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (web.isLoading)
        {
            DISSMISS;
        }
    });
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    if (self.view.window)
    {
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [web loadRequest:requset];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    DISSMISS;
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DISSMISS;
    [self.navigationController popViewControllerAnimated:YES];

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
