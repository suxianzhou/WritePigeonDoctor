//
//  RegisterViewController.m
//  test3
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "RegisterViewController.h"
#import "FELoginTableCell.h"
#import "YYKit.h"
#import "InfoViewController.h"
#import "UIColor+Wonderful.h"
#import "RWRequsetManager+UserLogin.h"
#import "XZSettingWebViewController.h"


#define INTERVAL_KEYBOARD 130
#define __AgreeText__ @"<<白鸽医生的条款协议>>"

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,FEChecButtonCellDelegate,FEButtonCellDelegate,FETextFiledCellDelegate,FEAgreementCellDelegate,RWRequsetDelegate>
{
    BOOL isAgree;//是否同意该协议
}
@property(nonatomic,assign)int countDown;
@property(nonatomic,strong)UIButton * clickBtn;
@property (weak ,nonatomic)NSTimer *timer;
@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong)RWRequsetManager * requestManager;

@end
//
static NSString * const textFieldCell=@"textFieldCell";
static NSString *const buttonCell = @"buttonCell";
static NSString * const chickCell=@"chickCell";
static NSString * const agreementCell=@"agreementCell";
@implementation RegisterViewController

@synthesize clickBtn;
@synthesize countDown;
@synthesize facePlaceHolder;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect frame=_backview.frame;
    _backview.frame=CGRectMake(frame.origin.x
                              , -frame.size.height+frame.origin.y
                              , frame.size.width
                              , frame.size.height);
    [UIView animateWithDuration:1.5 animations:^{
        _backview.frame=frame;
    }];
[self registerForKeyboardNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (_requestManager && _requestManager.delegate == nil)
    {
        _requestManager.delegate = self;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     _requestManager.delegate = nil;
}

- (void)viewDidLoad {
    isAgree=YES;
    [super viewDidLoad];
    _requestManager = [[RWRequsetManager alloc] init];
    _backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/8)];
    _backview.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_backview];
    [_backview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
        make.top.equalTo(self.view).offset(self.view.bounds.size.height/7);
        
    }];

    [self initWithViewList];
    
    [self.viewList addGestureRecognizer:self.tap];

}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    
    
    if ([facePlaceHolder isEqualToString:@"请输入密码"]||[facePlaceHolder isEqualToString:@"请输入新密码"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0,-self.viewList.frame.size.height/7, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    if ([facePlaceHolder isEqualToString:@"请确认密码"]||[facePlaceHolder isEqualToString:@"请确认新密码"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0,-2*self.viewList.frame.size.height/7, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    
    //视图下沉恢复原状
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
#pragma mark    创建整体UI设计
-(void)initWithViewList{
    
    [self.backView removeFromSuperview];
        //  创建需要的毛玻璃特效类型
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //  毛玻璃view 视图
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    effectView.alpha = .8f;
    effectView.layer.cornerRadius=12;
    effectView.layer.masksToBounds=YES;
    [_backview addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backview);
        make.size.equalTo(_backview);
        
    }];
    

    self.viewList=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/8) style:UITableViewStylePlain];
    self.viewList.backgroundColor=[UIColor clearColor];
    self.viewList.delegate=self;
    self.viewList.dataSource=self;
    self.viewList.scrollEnabled=NO;
    self.viewList.allowsSelection = NO;
    self.viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_backview addSubview:self.viewList];
    [self.viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backview);
        make.size.equalTo(_backview);
    }];
    [self.viewList registerClass:[FEAgreementCell class] forCellReuseIdentifier:agreementCell];
    [self.viewList registerClass:[FEChecButtonCell class] forCellReuseIdentifier:chickCell];
    [self.viewList registerClass:[FETextFiledCell class] forCellReuseIdentifier:textFieldCell];
    [self.viewList registerClass:[FEButtonCell class] forCellReuseIdentifier:buttonCell];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_typePassWord==TypeRegisterPassWord) {
    return 7;
    }
    return 6;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
  
        if(section==0){
        return self.viewList.frame.size.height/7;
        }
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        if(_typePassWord==TypeRegisterPassWord){
        titleLabel.text = @"个人信息填写";
        }else{
            titleLabel.text=@"密码修改";
        }
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.shadowColor = [UIColor greenColor];
        
        [backView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(40);
            make.right.equalTo(backView.mas_right).offset(-40);
            make.top.equalTo(backView.mas_top).offset(20);
            make.bottom.equalTo(backView.mas_bottom).offset(-15);
        }];
        
        return backView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typePassWord==TypeRegisterPassWord) {

    if (indexPath.section==4) {
        return  self.viewList.frame.size.height/13.5;
    }
    
    if (indexPath.section==5||indexPath.section==6) {
        return self.viewList.frame.size.height/7.5;
    }
        return self.viewList.frame.size.height/8;
    }
    if (indexPath.section==4||indexPath.section==5) {
        return self.viewList.frame.size.height/7.5;
    }
    return self.viewList.frame.size.height/7.5;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
        cell.placeholder = @"请输入手机号";
        
        return cell;
    } else if (indexPath.section == 1){
        FEChecButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:chickCell forIndexPath:indexPath];
        cell.delegate=self;
        cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
        cell.placeholder=@"输入验证码";
        cell.button.tag=99997;
        
        [cell setTitle:@"获取验证码"];
        return cell;
    }

    if (_typePassWord==TypeRegisterPassWord) {
        
    
     if(indexPath.section==2){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.textField.secureTextEntry=YES;
         
        cell.placeholder = @"请输入密码";
        return cell;
    }
    else if(indexPath.section==3){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.textField.secureTextEntry=YES;
        
        cell.placeholder = @"请确认密码";
        return cell;
    }
    
    else if(indexPath.section==4){
        
        
        
        FEAgreementCell * cell=[tableView dequeueReusableCellWithIdentifier:agreementCell forIndexPath:indexPath];
        
        cell.delegate=self;
        NSMutableAttributedString *two=[[NSMutableAttributedString alloc]initWithString:@"我同意"];
        cell.agreementString=__AgreeText__;
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:cell.agreementString];
        two.font=[UIFont boldSystemFontOfSize:12];
        two.color=[UIColor whiteColor];
        one.font = [UIFont boldSystemFontOfSize:11];
        one.underlineStyle = NSUnderlineStyleSingle;
        
        [one setTextHighlightRange: one.rangeOfAll
                             color:[UIColor bronzeColor]
                   backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                         }];
        [two appendAttributedString:one];
        cell.bordLabel.attributedText =two;
        
        
        
        return cell;
        
        
    }
    else if(indexPath.section==5){
        FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        [cell setTitle:@"上一步"];
        cell.button.tag=99999;
        return cell;
    }
    else if(indexPath.section==6){
        FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        [cell setTitle:@"完善信息"];
        cell.button.tag=99998;
        return cell;
    }
    
    }else{
        
    if(indexPath.section==2){
            
            FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
            
            cell.delegate = self;
            cell.textField.secureTextEntry=YES;
            cell.placeholder = @"请输入新密码";
            return cell;
        }
        else if(indexPath.section==3){
            
            FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
            
            cell.delegate = self;
            cell.textField.secureTextEntry=YES;
            cell.placeholder = @"请确认新密码";
            return cell;
        }else if(indexPath.section==4){
            FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
            cell.delegate=self;
            [cell setTitle:@"上一步"];
            cell.button.tag=99999;
            return cell;
        }else if (indexPath.section==5){
            FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
            cell.delegate=self;
            [cell setTitle:@"完成修改"];
            cell.button.tag=99997;
            return cell;
        }

        
    }
    return nil;
}
/**
 *
 *按钮点击
 *
 */

#pragma mark    按钮点击（注册完成，修改完成的方法）

-(void)button:(UIButton *)button ClickWithTitle:(NSString *)title{
    

    if(button.tag==99999){
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        [tabBar toLoginViewController];
        
    }else if(button.tag==99998){
        
        [self isRegister:YES];
        
        
//        NSLog(@"完善信息");
        
    }else{
        [self isRegister:NO];
        
//        NSLog(@"点击了修改完成");
        
    }
    
}

/**
 *  点击注册或者修改密码
 *
 *  @param isRegister YES为注册  NO为修改密码
 */
-(void)isRegister:(BOOL)isRegister{
    
    FETextFiledCell * phoneCell=[self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    FETextFiledCell *verificationCell=
                                [self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    FETextFiledCell * passwordCell=
                                [self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    FETextFiledCell * againCell=
                                [self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    NSString *username=phoneCell.textField.text;
    //验证码
    NSString *verification = verificationCell.textField.text;
    
    NSString * password=passwordCell.textField.text;
    
    NSString *againPassWord = againCell.textField.text;
    
    if (![_requestManager verificationPhoneNumber:username])
    {
        [RWSettingsManager promptToViewController:self Title:@"手机号输入有误，请重新输入"  response:^{
            
            phoneCell.textField.text = nil;
            [phoneCell.textField becomeFirstResponder];
        }];
        
        return;
    }
    if ([_requestManager verificationPassword:password]) {
        
        if (![password isEqualToString:againPassWord])
        {
            [RWSettingsManager promptToViewController:self
                                                Title:@"密码输入不一致，请重新输入"
                                             response:^{
                
                passwordCell.textField.text = nil; againCell.textField.text = nil;
                [passwordCell.textField becomeFirstResponder];
                [againCell.textField becomeFirstResponder];
            }];
        }
        
    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:@"密码格式错误,请输入6~18位"
                                         response:^
        {
            passwordCell.textField.text = nil; againCell.textField.text = nil;
            [passwordCell.textField becomeFirstResponder];
            [againCell.textField becomeFirstResponder];
        }];
        
        return;
    }
    
    
    _requestManager.delegate=self;

    
    SHOWLOADING;
    if (isRegister)
    {
        [_requestManager registerWithUsername:username AndPassword:password verificationCode:verification];
    }
    else
    {
        [_requestManager replacePasswordWithUsername:username AndPassword:password verificationCode:verification];
    }
    
    
}
-(void)userRegisterSuccess:(BOOL)success responseMessage:(NSString *)responseMessage
{
    DISSMISS;
    if (success)
    {
        
        [RWSettingsManager promptToViewController:self
                                            Title:@"注册成功"
                                         response:^
         {
             [self dismissViewControllerAnimated:YES completion:nil];
             
             UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
             
             [tabBar toLoginViewController];
         }];
    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:responseMessage
                                         response:nil];
    }
    
}
-(void)userReplacePasswordResponds:(BOOL)success responseMessage:(NSString *)responseMessage
{
   DISSMISS;
    if (success)
    {
        
        [RWSettingsManager promptToViewController:self
                                            Title:@"修改成功"
                                         response:^
        {
            
            UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            [tabBar toLoginViewController];
            
        }];
    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:responseMessage
                                         response:nil];
    }
    
}

#pragma mark    验证码点击
-(void)button:(UIButton *)button FEChecClickWithTitle:(NSString *)title{
    if (button.tag==99997) {
        if ([button.titleLabel.text isEqualToString:@"获取验证码"] ||
            [button.titleLabel.text isEqualToString:@"重新验证码"])
        {
            countDown= 60;
            clickBtn=button;
            
          
            //定时器启动后的方法
            
            FETextFiledCell *userName = [self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (![_requestManager verificationPhoneNumber:userName.textField.text])
            {
                [RWSettingsManager promptToViewController:self Title:@"手机号输入有误，请重新输入" response:^{
                    
                    userName.textField.text = nil;
                    [userName.textField becomeFirstResponder];
                }];
                
                return;
            }
              [self timerStart];
            _requestManager.delegate = self;
            
            [_requestManager obtainVerificationWithPhoneNunber:userName.textField.text result:^(BOOL succeed, NSString *reason)
             {
                 if (!succeed)
                 {
                     
                     [RWSettingsManager promptToViewController:self Title:reason response:^{
                         
                         [clickBtn setTitle:@"重新验证码"
                                   forState:(UIControlStateNormal)];
                     }];
                 }
             }];
            
        }
        
    }
}
- (void)timerStart
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(renovateSecond) userInfo:nil repeats:YES];
}
/**
 *  计时器启动时的方法
 */
- (void)renovateSecond
{
    if (countDown <= 0)
    {
        [_timer setFireDate:[NSDate distantFuture]];
        
        [clickBtn setTitle:@"重新验证码" forState:(UIControlStateNormal)];
        
        return;
    }
    
    countDown --;
    
    [clickBtn setTitle:[NSString stringWithFormat:@"%dS",(int)countDown]
              forState:UIControlStateNormal];
    
}

-(void)textFiledCell:(FETextFiledCell *)cell DidBeginEditing:(NSString *)placeholder{
    
        facePlaceHolder = placeholder;
    
    
}
-(void)FEChectextFiledCell:(FEChecButtonCell *)cell DidBeginEditing:(NSString *)placeholder{
    
      facePlaceHolder = placeholder;
    
}

#pragma mark 条款协议

- (void)button:(UIButton *)button ClickWithImage:(UIImage *)image
{
    UIButton * overButton=[self.view viewWithTag:99998];
    
    if (isAgree)
    {
        [button setImage:[UIImage imageNamed:@"duihao_nil"] forState:(UIControlStateNormal)];
        isAgree=NO;
        overButton.backgroundColor=[UIColor lightGrayColor];
        [overButton setTitle:@"请阅读协议" forState:(UIControlStateNormal)];
        overButton.userInteractionEnabled=NO;
        
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"duihao"] forState:(UIControlStateNormal)];
        isAgree=YES;
        overButton.backgroundColor=__WPD_MAIN_COLOR__;
        [overButton setTitle:@"完善信息" forState:(UIControlStateNormal)];
        overButton.userInteractionEnabled=YES;
    }
}

#pragma mark  点击条约
-(void)Agreement
{

    XZSettingWebViewController * web=[[XZSettingWebViewController alloc]init];
    
    web.url=@"http://www.zhongyuedu.com/tgm/test/test19/";
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:web];

    [navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"渐变"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *title = [[UILabel alloc] initWithFrame:navigation.navigationBar.bounds];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"白鸽医生用户协议";
    [navigation.navigationBar addSubview:title];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textColor = [UIColor whiteColor];
   
    navigation.navigationBar.barTintColor = [UIColor whiteColor];
    navigation.navigationBar.translucent = NO;
    navigation.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    navigation.navigationBar.tintColor = [UIColor whiteColor];
    
    [self presentViewController:navigation animated:YES completion:^{
       
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnSelf)];
        
        web.navigationItem.leftBarButtonItem = item;
    }];
}

- (void)returnSelf
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
