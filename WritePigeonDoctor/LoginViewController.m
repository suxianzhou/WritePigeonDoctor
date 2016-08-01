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

#define INTERVAL_KEYBOARD 5
@interface LoginViewController ()<UITableViewDataSource,
UITableViewDelegate,
FETextFiledCellDelegate,
FEButtonCellDelegate
>


@end


static NSString * const textFieldCell=@"textFieldCell";
static NSString *const buttonCell = @"buttonCell";
@implementation LoginViewController

@synthesize viewList;
@synthesize facePlaceHolder;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initWithViewList];
    [viewList addGestureRecognizer:self.tap];
    
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
    
    CGFloat offset = (viewList.frame.origin.y+viewList.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - keyboardSize.height);
    
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
-(void)initWithViewList{

    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    viewList.backgroundColor=[UIColor blackColor];
    [self.view addSubview:viewList];
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
        make.top.equalTo(self.backView.mas_bottom);
    }];
    viewList.scrollEnabled=NO;
    viewList.allowsSelection = NO;
    viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    viewList.delegate = self;
    viewList.dataSource = self;
    [viewList registerClass:[FETextFiledCell class] forCellReuseIdentifier:textFieldCell];
    [viewList registerClass:[FEButtonCell class] forCellReuseIdentifier:buttonCell];
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
        
        return viewList.frame.size.height/5.5;
    }
    
    return viewList.frame.size.height/6;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.placeholder = @"请输入账号";
        
        return cell;
    } else if (indexPath.section == 1)
    {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.placeholder = @" 请输入密码";
        cell.textField.secureTextEntry=YES;
        
        return cell;
    }
    else{
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
        return viewList.frame.size.height/4;
    }
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==2) {
        return viewList.frame.size.height/5.5;
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
        
        titleLabel.text = @"ZHONGYU · 中域";
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"STXingkai-SC-Bold"size:20];
        titleLabel.textColor = [UIColor yellowColor];
//        titleLabel.shadowOffset = CGSizeMake(1, 1);
//        titleLabel.shadowColor = [UIColor yellowColor];
        
        [backView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(40);
            make.right.equalTo(backView.mas_right).offset(-40);
            make.top.equalTo(backView.mas_top).offset(20);
            make.bottom.equalTo(backView.mas_bottom).offset(-20);
        }];
        
        return backView;
    }
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UIButton * ForgotButton=[[UIButton alloc]init];
        [ForgotButton setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        ForgotButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];

        UIButton *registerButton=[[UIButton alloc]init];
        
         registerButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        
        [registerButton setTitle:@"新用户注册" forState:(UIControlStateNormal)];
        
        
        
        [ForgotButton addTarget:self action:@selector(jumpForgotController) forControlEvents:(UIControlEventTouchUpInside)];
        
        [registerButton addTarget:self action:@selector(jumpRegisterController) forControlEvents:(UIControlEventTouchUpInside)];
        
        [backView addSubview:ForgotButton];
        
        [backView addSubview:registerButton];
        
        [ForgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-(viewList.frame.size.width/1.5));
            make.left.equalTo(backView).offset(10);
            make.top.equalTo(backView).offset(10);
            make.height.equalTo(@(30));
        }];
        
        
        
        [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-10);
            make.left.equalTo(ForgotButton).offset(viewList.frame.size.width/1.7);
            make.top.equalTo(backView).offset(10);
            make.height.equalTo(@(30));
        }];
        
        
        
        return backView;
    }
    
    return nil;
}
/**
 *  跳转到忘记密码的页面
 */
-(void)jumpForgotController{
    
    RegisterViewController * registerVC=[[RegisterViewController alloc]init];
    registerVC.typePassWord=TypeForgetPassWord;
    [self presentViewController:registerVC animated:NO completion:^{

    }];
    
}

-(void)jumpRegisterController{
    RegisterViewController * registerVC=[[RegisterViewController alloc]init];
    registerVC.typePassWord=TypeRegisterPassWord;
    [self presentViewController:registerVC animated:NO completion:^{
        
    }];
}

-(void)textFiledCell:(FETextFiledCell *)cell DidBeginEditing:(NSString *)placeholder{
    facePlaceHolder = placeholder;
}

-(void)button:(UIButton *)button ClickWithTitle:(NSString *)title{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
