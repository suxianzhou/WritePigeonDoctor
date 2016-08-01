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

#define INTERVAL_KEYBOARD 130
@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,FEChecButtonCellDelegate,FEButtonCellDelegate,FETextFiledCellDelegate,FEAgreementCellDelegate>
{
    BOOL isAgree;
}
@property(nonatomic,assign)int countDown;
@property(nonatomic,strong)UIButton * clickBtn;
@property (weak ,nonatomic)NSTimer *timer;

@end

static NSString * const textFieldCell=@"textFieldCell";
static NSString *const buttonCell = @"buttonCell";
static NSString * const chickCell=@"chickCell";
static NSString * const agreementCell=@"agreementCell";
@implementation RegisterViewController

@synthesize clickBtn;
@synthesize countDown;
@synthesize viewList;
@synthesize facePlaceHolder;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self registerForKeyboardNotifications];
    CGRect frame=viewList.frame;
    
    viewList.frame=CGRectMake(frame.origin.x
                              , frame.origin.y-frame.size.height-20
                              , frame.size.width
                              , frame.size.height);
    [UIView animateWithDuration:3 animations:^{
        viewList.frame=frame;
    }];

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
    isAgree=YES;
    [viewList addGestureRecognizer:self.tap];

}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    if (_typePassWord==TypeRegisterPassWord) {
        
    
    if([facePlaceHolder isEqualToString:@"请输入密码"]){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            viewList.contentOffset=CGPointMake(0, 1*viewList.frame.size.height/11);
        }];
    }
    

    if ([facePlaceHolder isEqualToString:@"请确认密码"]) {
    
        
        [UIView animateWithDuration:0.3 animations:^{
            
            viewList.contentOffset=CGPointMake(0, 2*viewList.frame.size.height/11);
        }];
      
    }
    if ([facePlaceHolder isEqualToString:@"请输入昵称"]) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            viewList.contentOffset=CGPointMake(0, 3*viewList.frame.size.height/11);

        }];
        
    }
    if ([facePlaceHolder isEqualToString:@"请输入年龄"]) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            viewList.contentOffset=CGPointMake(0, 4*viewList.frame.size.height/11);
        }];
        
    }

    }
    
    if (_typePassWord==TypeForgetPassWord) {
        NSLog(@"%@",facePlaceHolder);
        if ([facePlaceHolder isEqualToString:@"输入验证码"]) {
            [UIView animateWithDuration:0.3 animations:^{
                
                viewList.contentOffset=CGPointMake(0, 1*viewList.frame.size.height/7.5);
            }];
        }
        
        if([facePlaceHolder isEqualToString:@"请输入新密码"]){
        
            [UIView animateWithDuration:0.3 animations:^{
                
                viewList.contentOffset=CGPointMake(0, 2*viewList.frame.size.height/7.5);
            }];
        }
        
        
        if ([facePlaceHolder isEqualToString:@"请确认新密码"]) {
            
            
            [UIView animateWithDuration:0.3 animations:^{
                
                viewList.contentOffset=CGPointMake(0, 3*viewList.frame.size.height/7.5);
            }];
            
        }

    }
    
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    
    //视图下沉恢复原状
    [UIView animateWithDuration:0.3 animations:^{
        viewList.contentOffset=CGPointMake(0, 0);
    }];
}



-(void)initWithViewList{
    [self.backView removeFromSuperview];
    viewList=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/8) style:UITableViewStylePlain];
    viewList.backgroundColor=[UIColor blackColor];
   if(_typePassWord==TypeRegisterPassWord){
    [self.view addSubview:viewList];
   
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
        make.top.equalTo(self.view.mas_top).offset(self.view.bounds.size.height/10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-self.view.bounds.size.height/18);
    }];
    }else{
        [self.view addSubview:viewList];
        [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.left.equalTo(self.view.mas_left).offset(self.view.frame.size.height/15);
            make.top.equalTo(self.view).offset(self.view.bounds.size.height/7);
            make.bottom.equalTo(self.view.mas_bottom).offset(-self.view.bounds.size.height/4.5);
        }];
    }
//    viewList.scrollEnabled=NO;
    viewList.allowsSelection = NO;
    viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    viewList.delegate = self;
    viewList.dataSource = self;
    [viewList registerClass:[FETextFiledCell class] forCellReuseIdentifier:textFieldCell];
    [viewList registerClass:[FEButtonCell class] forCellReuseIdentifier:buttonCell];
    [viewList registerClass:[FEChecButtonCell class] forCellReuseIdentifier:chickCell];
    [viewList registerClass:[FEAgreementCell class] forCellReuseIdentifier:agreementCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_typePassWord==TypeRegisterPassWord) {
    return 10;
    }
    return 6;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(_typePassWord==TypeRegisterPassWord){
    if (section == 0)
    {
        return viewList.frame.size.height/10;
    }
    }else
    {
        if(section==0){
        return viewList.frame.size.height/7;
        }
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

    if (indexPath.section==7) {
        return  viewList.frame.size.height/13.5;
    }
    
    if (indexPath.section==8||indexPath.section==9) {
        return viewList.frame.size.height/10.8;
    }
        return viewList.frame.size.height/11;
    }
    if (indexPath.section==4||indexPath.section==5) {
        return viewList.frame.size.height/7.5;
    }
    return viewList.frame.size.height/7.5;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typePassWord==TypeRegisterPassWord) {
        
    
    
    if (indexPath.section == 0)
    {
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
        cell.placeholder = @"请输入手机号";
        
        return cell;
    } else if (indexPath.section == 1)
    {FEChecButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:chickCell forIndexPath:indexPath];
        cell.delegate=self;
        cell.placeholder=@"输入验证码";
        cell.button.tag=99997;
        
        [cell setTitle:@"获取验证码"];
    return cell;
    }
    else if(indexPath.section==2){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.placeholder = @"请输入密码";
        return cell;
    }
    else if(indexPath.section==3){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.placeholder = @"请确认密码";
        return cell;
    }
    else if(indexPath.section==4){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.placeholder = @"请输入昵称";
        return cell;
    }
    else if(indexPath.section==5){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
        cell.placeholder = @"请输入年龄";
        return cell;
    }
    else if(indexPath.section==6){
        
        FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
        
        
        UIButton * button=[[UIButton alloc]init];
        
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(chickGender) forControlEvents:(UIControlEventTouchUpInside)];

        [cell addSubview:button];
        
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
            make.size.equalTo(cell);
        }];
        
        cell.delegate = self;
        
        cell.placeholder = @"请输入性别";
       
        
        return cell;
    }else if(indexPath.section==7){
        FEAgreementCell * cell=[tableView dequeueReusableCellWithIdentifier:agreementCell forIndexPath:indexPath];
        
        cell.delegate=self;
        NSMutableAttributedString *two=[[NSMutableAttributedString alloc]initWithString:@"我同意"];
        cell.agreementString=@"白鸽医生的条款协议";
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:cell.agreementString];
        two.font=[UIFont boldSystemFontOfSize:13];
        two.color=[UIColor whiteColor];
        one.font = [UIFont boldSystemFontOfSize:12];
        one.underlineStyle = NSUnderlineStyleSingle;
        one.color = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
        
        
        [one setTextHighlightRange: one.rangeOfAll
                             color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                   backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                         }];
        [two appendAttributedString:one];
        cell.bordLabel.attributedText =two;
        
        
        
        return cell;
        
        
    }
    else if(indexPath.section==8){
        FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        [cell setTitle:@"上一步"];
        cell.button.tag=99999;
        return cell;
    }
    else if(indexPath.section==9){
        FEButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        cell.delegate=self;
        [cell setTitle:@"完成注册"];
        cell.button.tag=99998;
        return cell;
    }
    
    }else{
        
        if (indexPath.section==0) {
            FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
            
            cell.delegate = self;
            cell.textField.keyboardType=UIKeyboardTypeDecimalPad;
            cell.placeholder = @"请输入手机号";
            
            return cell;
        } else if (indexPath.section == 1){
            FEChecButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:chickCell forIndexPath:indexPath];
            cell.delegate=self;
            cell.placeholder=@"输入验证码";
            cell.button.tag=99997;
            
            [cell setTitle:@"获取验证码"];
            return cell;
        }
        else if(indexPath.section==2){
            
            FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
            
            cell.delegate = self;
            
            cell.placeholder = @"请输入新密码";
            return cell;
        }
        else if(indexPath.section==3){
            
            FETextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCell forIndexPath:indexPath];
            
            cell.delegate = self;
            
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
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if(button.tag==99998){
        
        NSLog(@"点击了完成注册");
        
    }else{
            //完成修改的方法
        NSLog(@"点击了修改完成");
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
            [self timerStart];
            //定时器启动后的方法
            
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

- (void)button:(UIButton *)button ClickWithImage:(UIImage *)image{
    UIButton * overButton=[self.view viewWithTag:99998];
    if (isAgree) {
         button.backgroundColor=[UIColor greenColor];
        isAgree=NO;
        overButton.backgroundColor=[UIColor lightGrayColor];
        overButton.userInteractionEnabled=NO;
        
    }else{
        button.backgroundColor=[UIColor orangeColor];
        isAgree=YES;
        overButton.backgroundColor=[UIColor blueColor];
        overButton.userInteractionEnabled=YES;
    }
}
-(void)Agreement{
    NSLog(@"点击条约");
    
}





//选择性别
-(void)chickGender{
     FETextFiledCell * cell=[viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"性别选择" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        cell.textField.text=@"男";
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        cell.textField.text=@"女";
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
      [self presentViewController:alert animated:true completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
