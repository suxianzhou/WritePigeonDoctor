//
//  FEShareViewController.m
//  shareViewDemo
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 zhongyu. All rights reserved.
//


#import "FEShareViewController.h"

/***************************友盟微信数据***************************/
#define UMWeChatAppId @"wxdc1e388c3822c80b"
#define UMWeChatAppSecret @"a393c1527aaccb95f3a4c88d6d1455f6"
#define UMWeChatUrl @"http://www.baidu.com/"
/***************************友盟QQ数据***************************/
#define UMQQAppId @"1105532245"
#define UMQQAppKey @"xgyo9yI8aV5DBaJg"
//#define UMQQAppUrl @"http://www.baidu.com/"
/***************************友盟微博数据***************************/
#define UMWeiboAppKey @"3921700954"
#define UMWeiboAppSecret @"04b48b094faeb16683c32669824ebdad"
#define UMWeiboAppRedirectURL @"http://sns.whalecloud.com/sina2/callback"



#define VIEWWEIGHT [UIScreen mainScreen].bounds.size.width //分享界面的宽
#define LETFDISTANCE 30 //左边距
#define TOPDISTANCE 40 //上边距
#define ICONHEIGHT 56  //icon 高
#define ICONWEIGHT 56  //icon 宽
#define ICONFONTHEIGHT 15 //icon与文字的距离
#define LINEHEIGHT 25  //行间距blackViewTap
@interface FEShareViewController ()

@property(nonatomic,strong)UIView * centerView;
@property(nonatomic,copy)NSMutableArray * ShareNameArray;

@property(nonatomic,copy)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;

@property(nonatomic,assign)int ViewHight;


@property(nonatomic,strong)UMSocialUrlResource * urlResou;
@property(nonatomic,copy)NSString *contentText;
@property(nonatomic,copy)NSString *titleText;
@property(nonatomic,copy)id images;
@property(nonatomic,copy)NSString *shareUrl;
@end

@implementation FEShareViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self createShareViewNameTitle];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
   
}
/**
 *
 typedef enum {
 UMSocialUrlResourceTypeDefault,             //无
 UMSocialUrlResourceTypeImage,               //图片
 UMSocialUrlResourceTypeVideo,               //视频
 UMSocialUrlResourceTypeMusic,                //音乐
 UMSocialUrlResourceTypeWeb,                //网页
 UMSocialUrlResourceTypeCount
 }UMSocialUrlResourceType;

 */

-(void)shareAppParamsByContentText:(NSString*)contentText title:(NSString *)title images:(id)images  ShareUrl :(NSString *) shareUrl  urlResource:(UMSocialUrlResourceType )UMSocialUrlType{
    _contentText=contentText;
    _titleText=title;
    _images=images;
    _shareUrl=shareUrl;
    _urlResou=[[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlType url:_shareUrl];
}


-(void)createShareViewNameTitle{
    
    
    
    //    _titleArray=[NSArray arrayWithObjects:@"朋友圈",@"QQ好友",@"QQ空间",@"微博",@"微信好友", nil];
    _titleArray=[NSArray arrayWithObjects:@"QQ好友",@"QQ空间", nil];
    //   _imageArray=[NSArray arrayWithObjects:@"icon_share_moment",@"icon_share_qq",@"icon_share_qzone",@"icon_share_webo",@"icon_share_wechat",nil];
    
    _imageArray=[NSArray arrayWithObjects:@"icon_share_qq",@"icon_share_qzone",nil];
    _ViewHight=133;
    self.view.frame=[UIScreen mainScreen].bounds;
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.9];
    if (!_centerView) {
        _centerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _centerView.backgroundColor=[UIColor clearColor];
    }
    //这个是分享Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    titleLabel.text = @"分享到";
    titleLabel.textColor=[UIColor blueColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_centerView addSubview:titleLabel];
    
    [self.view addSubview:_centerView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top).offset(5);
        make.width.equalTo(_centerView.mas_width);
        make.height.equalTo(@(15));
    }];
    
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        
        CGFloat fontHeight = 12;//文字高度
        
        CGFloat iconX = LETFDISTANCE + i%4 * ((VIEWWEIGHT - 4 *ICONWEIGHT - 2 * LETFDISTANCE) / 3 + ICONWEIGHT);
        
        CGFloat iconY = TOPDISTANCE + i/4 * (ICONHEIGHT +ICONFONTHEIGHT + fontHeight + LINEHEIGHT);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor clearColor];
        button.frame = CGRectMake(iconX,iconY , ICONWEIGHT, ICONHEIGHT);
        button.alpha=0;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(iconX-2 , iconY + ICONHEIGHT + ICONFONTHEIGHT, ICONWEIGHT + 4, fontHeight)];
        label.textColor=[UIColor whiteColor];
        label.text = _titleArray[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha=0;
        if (i<=4-1) {
            CGRect endFrame = button.frame;
            button.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y+10, endFrame.size.width, endFrame.size.height);
            CGRect MoveFrame=button.frame;
            button.frame=CGRectMake(MoveFrame.origin.x, endFrame.origin.y-endFrame.size.height, MoveFrame.size.width, MoveFrame.size.height);
            
            
            
            [UIView animateWithDuration:i%2+0.5 animations:^{
                button.alpha=1;
                button.frame=MoveFrame;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    button.frame=endFrame;
                    label.alpha=1;
                }];
            }];
            
        }
        if (i<=8-1&&i>4-1) {
            CGRect endFrame = button.frame;
            button.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y-10, endFrame.size.width, endFrame.size.height);
            
            CGRect MoveFrame=button.frame;
            
            button.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y+endFrame.size.height, endFrame.size.width, endFrame.size.height);
            
            [UIView animateWithDuration:i%2+1 animations:^{
                button.alpha=1;
                [button setFrame:MoveFrame];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    button.frame=endFrame;
                    label.alpha=1;
                }];
            }];
        }
        button.tag = i + 1;
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:button];
        [_centerView addSubview:label];
        
    }
    
    
    
    
    if (_titleArray.count<=4) {
        
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-30);
            make.width.equalTo(self.view);
            make.height.equalTo(@(133));
        }];
        
    }else if (_titleArray.count<=8&&_titleArray.count>4){
        
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-30);
            make.width.equalTo(self.view);
            make.height.equalTo(@(244));
        }];
    }
}

-(void)shareBtnClick:(UIButton *)button{
    
    UIButton * shareButton=button;
    
    shareButton.userInteractionEnabled=NO;
    
    UIView * NextView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSArray *subviews = [_centerView subviews];
    
    for (UIView * view in subviews) {
        
        if (view.tag!=shareButton.tag) {
            if ([view isKindOfClass:[UILabel class]]) {
                view.alpha=0;
            }
            [UIView animateWithDuration:2 animations:^{
                [self.view addSubview:NextView];
                shareButton.frame=CGRectMake(shareButton.frame.origin.x-100, shareButton.frame.origin.y-100, shareButton.frame.size.width+200, shareButton.frame.size.height+200);
                shareButton.userInteractionEnabled=NO;
                shareButton.alpha=0;
                self.view.alpha=0;
                view.frame=CGRectMake(view.frame.origin.x, self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
            } completion:^(BOOL finished) {
                [NextView removeFromSuperview];
                
                [shareButton removeFromSuperview];
            }];
            
        }
    }
    
    [self chick:shareButton];
}


-(void)chick:(UIButton *)button{
    NSInteger whichone=button.tag-1;
    //QQ好友
    if (whichone==0) {
        [UMSocialControllerService defaultControllerService].socialUIDelegate=self;
        
        if ([QQApiInterface isQQInstalled] ) {
            [UMSocialQQHandler setQQWithAppId:UMQQAppId appKey:UMQQAppKey url:_shareUrl];
            [UMSocialData defaultData].extConfig.qqData.title =_titleText;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_contentText image:_images location:nil urlResource:_urlResou presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功");
                    [self alertErrorOne:@"分享成功"];
                }else{
                    [self alertErrorOne:@"分享失败"];
                }
            }];
        }else{
            [self alertErrorOne:@"分享失败！您未安装QQ"];
        }

    }
    //空间
    if (whichone==1) {
        if ([QQApiInterface isQQInstalled]) {
            [UMSocialQQHandler setQQWithAppId:UMQQAppId appKey:UMQQAppKey url:_shareUrl];
            [UMSocialData defaultData].extConfig.qzoneData.title = _titleText;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_contentText image:_images location:nil urlResource:_urlResou presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功");
                     [self alertErrorOne:@"分享成功"];
                }else{
                     [self alertErrorOne:@"分享失败"];
                }
            }];
        }else{
            [self alertErrorOne:@"分享失败！您未安装QQ"];
        }
    }
    
}
- (void)alertErrorOne:(NSString *)error{
    // 1.弹框
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
