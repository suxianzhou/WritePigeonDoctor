//
//  LoginViewController.m
//  LoginTest
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "LoginViewController.h"
#import "FELoginTableCell.h"
#import "RegisterViewController.h"
#import "SXColorGradientView.h"
#import "UIColor+Wonderful.h"
#import "RWRequsetManager+UserLogin.h"
#import "InfoViewController.h"
#import "RWDataBaseManager.h"
#define INTERVAL_KEYBOARD 5

@interface LoginViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    FETextFiledCellDelegate,
    FEButtonCellDelegate,
    RWRequsetDelegate
>

@property (strong, nonatomic)RWRequsetManager *requestManager;


@end


static NSString * const textFieldCell=@"textFieldCell";
static NSString *const buttonCell = @"buttonCell";
@implementation LoginViewController

@synthesize facePlaceHolder;
@synthesize requestManager;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (requestManager && requestManager.delegate == nil)
    {
        requestManager.delegate = self;
    }

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    requestManager.delegate = nil;
    

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initWithViewList];
    [self.viewList addGestureRecognizer:self.tap];
    [self createBottomView];
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat offset = (self.viewList.frame.origin.y+self.viewList.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - keyboardSize.height);
    
    if(offset > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
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
-(void)initWithViewList
{
    UIView *backview=[[UIView alloc]init];
    backview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:backview];
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
        make.top.equalTo(self.backView.mas_bottom);
        
    }];
    //  创建需要的毛玻璃特效类型
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //  毛玻璃view 视图
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    effectView.alpha = .8f;
    effectView.layer.cornerRadius=12;
    effectView.layer.masksToBounds=YES;
        [backview addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backview);
        make.size.equalTo(backview);

    }];
    
    
//    NSLog(@"--------->%f",grv3.frame.size.width);
    
    self.viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.viewList.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.viewList];
    [self.viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
        make.top.equalTo(self.backView.mas_bottom);
    }];
    self.viewList.scrollEnabled=NO;
    self.viewList.allowsSelection = NO;
    self.viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.viewList.delegate = self;
    self.viewList.dataSource = self;
    [self.viewList registerClass:[FETextFiledCell class] forCellReuseIdentifier:textFieldCell];
    [self.viewList registerClass:[FEButtonCell class] forCellReuseIdentifier:buttonCell];
}

#pragma mark    -------UITableViewDataSource代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        
        return self.viewList.frame.size.height/5.5;
    }
    
    return self.viewList.frame.size.height/6;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RWUser *user = [[RWDataBaseManager defaultManager] getDefualtUser];
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
        cell.placeholder = @"请输入账号";
        
        cell.textField.text = user?user.username:nil;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.placeholder = @" 请输入密码";
        cell.textField.secureTextEntry=YES;
        
        if ([SETTINGS_VALUE(__AUTO_LOGIN__) boolValue])
        {
            RWUser *user = [[RWDataBaseManager defaultManager] getDefualtUser];
            cell.textField.text = user?user.password:nil;
        }
        
        return cell;
    }
    else
    {
        FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        [cell setTitle:@"登录"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.viewList.frame.size.height/4;
    }
    if (section==2) {
        return self.viewList.frame.size.height/10;
    }
    
    return 0;
}



/**
 *  组透视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        titleLabel.text = @"登录窗口";
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
            make.bottom.equalTo(backView.mas_bottom).offset(-20);
        }];
        
        return backView;
    }
    
    if (section==2) {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UIButton * ForgotButton=[[UIButton alloc]init];
        [ForgotButton setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        ForgotButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
        
        UIButton *registerButton=[[UIButton alloc]init];
        
        registerButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
        
        [registerButton setTitle:@"新用户注册" forState:(UIControlStateNormal)];
        
        
        
        [ForgotButton addTarget:self action:@selector(jumpForgotController) forControlEvents:(UIControlEventTouchUpInside)];
        
        [registerButton addTarget:self action:@selector(jumpRegisterController) forControlEvents:(UIControlEventTouchUpInside)];
        
        [backView addSubview:ForgotButton];
        
        [backView addSubview:registerButton];
        
        [ForgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-(self.viewList.frame.size.width/1.5));
            make.left.equalTo(backView).offset(10);
            make.top.equalTo(backView).offset(10);
            make.height.equalTo(@(30));

        }];
        
        
        
        [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-10);
            make.left.equalTo(ForgotButton).offset(self.viewList.frame.size.width/1.7);
            make.top.equalTo(backView).offset(10);
            make.height.equalTo(@(30));
        }];
        
        
        
        return backView;
    }
    
    return nil;
}




-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==2){
        UIView * backgroundView=[[UIView alloc]init];
        
        UIButton * chickButton=[[UIButton  alloc]init];
        
        if ([SETTINGS_VALUE(__AUTO_LOGIN__ )boolValue])
        {
             [chickButton setImage:[UIImage imageNamed:@"duihao"] forState:(UIControlStateNormal)];
        }else{
             [chickButton setImage:[UIImage imageNamed:@"duihao_nil"] forState:(UIControlStateNormal)];
        }
        
        [chickButton addTarget:self action:@selector(chickAutoButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [backgroundView addSubview:chickButton];
        
        [chickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backgroundView).offset(-20);
            make.centerY.equalTo(backgroundView);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        UILabel * label=[[UILabel alloc]init];
        
        label.text=@" 自动登录";
        
        label.textColor=[UIColor whiteSmoke];
        
        label.font=[UIFont systemFontOfSize:12];
        
        [backgroundView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(chickButton.mas_right);
            make.right.equalTo(backgroundView);
            make.height.equalTo(@(20));
            make.top.equalTo(chickButton);
        }];
        
        
        return backgroundView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return self.viewList.frame.size.height/11;
    }
    return 0;
}


-(void)chickAutoButton:(UIButton *)button
{
    if ([SETTINGS_VALUE(__AUTO_LOGIN__) boolValue])
    {
        if (SETTINGS(__AUTO_LOGIN__, @(NO)))
        {
            [button setImage:[UIImage imageNamed:@"duihao_nil"]
                    forState:(UIControlStateNormal)];
        }
        else
        {
            MESSAGE(@"变更失败");
        }
    }
    else
    {
        if (SETTINGS(__AUTO_LOGIN__, @(YES)))
        {
            [button setImage:[UIImage imageNamed:@"duihao"]
                    forState:(UIControlStateNormal)];
        }
        else
        {
            MESSAGE(@"变更失败");
        }
    }
}
/**
 *  跳转到忘记密码的页面
 */
-(void)jumpForgotController{
    
    RegisterViewController * registerVC=[[RegisterViewController alloc]init];
    registerVC.typePassWord=TypeForgetPassWord;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window.rootViewController presentViewController:registerVC
                                            animated:NO
                                          completion:nil];
    
}

-(void)jumpRegisterController{
    RegisterViewController * registerVC=[[RegisterViewController alloc]init];
    registerVC.typePassWord=TypeRegisterPassWord;
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window.rootViewController presentViewController:registerVC
                                            animated:NO
                                          completion:nil];
}

-(void)textFiledCell:(FETextFiledCell *)cell DidBeginEditing:(NSString *)placeholder{
    facePlaceHolder = placeholder;
}

#pragma mark     ---登录按钮事件
-(void)button:(UIButton *)button ClickWithTitle:(NSString *)title{
    [self userLogin];

}

-(void)createBottomView{
    
    UIView * bottomView=[[UIView alloc]init];
    
    bottomView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:bottomView];
    
    UIButton * bottomButton=[[UIButton alloc]init];
    
    bottomButton.backgroundColor=[UIColor clearColor];
    
    bottomButton.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [bottomButton setTitle:@"跳过登录使用" forState:(UIControlStateNormal)];
  
    [bottomButton addTarget:self action:@selector(jumpMain) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:bottomButton];

    __weak typeof (self) weakself =self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.left.equalTo(weakself.view.mas_left);
        make.height.equalTo(@(30));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-weakself.view.frame.size.height/10);
    }];
    
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.center.equalTo(bottomView);
        make.left.equalTo(bottomView.mas_left).offset(40);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
        
    }];
    
    
}

-(void)jumpMain{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 登录触发
#pragma mark - views

- (void)obtainRequestManager
{
    
    if (!requestManager)
    {
        requestManager = [[RWRequsetManager alloc]init];
        requestManager.delegate = self;
    }
}

-(void)userLogin
{
    [self obtainRequestManager];
    __block FETextFiledCell *textCell = [self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *phoneNumber = textCell.textField.text;
    
    __block FETextFiledCell *verCell = [self.viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *userPassword = verCell.textField.text;
    
    if ([requestManager verificationPhoneNumber:phoneNumber])
    {
        
        if ([requestManager verificationPassword:userPassword])
        
        {
            SHOWLOADING;
             [requestManager userinfoWithUsername:phoneNumber AndPassword:userPassword];
        
        }
        else{
            
            [RWSettingsManager promptToViewController:self Title:@"密码输入错误" response:^{
                
                textCell.textField.text = nil;
                [textCell.textField becomeFirstResponder];
            }];
        }
    }else{
        
        [RWSettingsManager promptToViewController:self
                                            Title:@"手机号输入错误，请重新输入"
                                         response:^{
            
            verCell.textField.text = nil;
            [verCell.textField becomeFirstResponder];
        }];
    }
}
-(void)userLoginSuccess:(BOOL)success responseMessage:(NSString *)responseMessage
{
    DISSMISS;
    
    if (success) {
        
        if ([RWDataBaseManager perfectPersonalInformation])
        {
            InfoViewController * ifVC=[[InfoViewController alloc]init];
            RWUser * user=[[RWDataBaseManager defaultManager] getDefualtUser];
            ifVC.name=user.name;
            ifVC.age=user.age;
            ifVC.headerImage=user.header;
            ifVC.gender=user.gender;
            [self presentViewController:ifVC animated:YES completion:nil];
        }
        else
        {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }

    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:responseMessage
                                         response:nil];
    }
    
}


@end
