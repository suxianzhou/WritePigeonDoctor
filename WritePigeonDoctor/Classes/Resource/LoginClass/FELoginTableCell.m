//
//  FELoginTableCells.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "FELoginTableCell.h"
@interface FETextFiledCell ()<UITextFieldDelegate>
@end

@implementation FETextFiledCell
@synthesize bankgroundView;
@synthesize textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
        
    }
    
    return self;
}
-(void)initUI{
    
    bankgroundView=[[UIView alloc]init];
    
    [self addSubview:bankgroundView];
    
    textField=[[UITextField alloc]init];
    

    textField.backgroundColor=[UIColor clearColor];
    
    textField.textColor = [UIColor blackColor];
    
    textField.textAlignment=NSTextAlignmentCenter;
    
    textField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    textField.delegate = self;
    bankgroundView.backgroundColor=[UIColor whiteColor];
    
    bankgroundView.layer.cornerRadius=10;
    
    [bankgroundView addSubview:textField];
    
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    __weak typeof(self) weakSelf = self;
    [bankgroundView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(weakSelf).offset(5);
        make.bottom.equalTo(weakSelf).offset(-5);
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(bankgroundView).offset(3);
        make.bottom.equalTo(bankgroundView).offset(-3);
        make.left.equalTo(bankgroundView).offset(10);
        make.right.equalTo(bankgroundView).offset(-10);
    }];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.delegate textFiledCell:self DidBeginEditing:_placeholder];
    
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    textField.placeholder = _placeholder;
}
@end





/****************************************************************/





@implementation FEButtonCell

@synthesize button;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        button = [[UIButton alloc]init];
        
        button.backgroundColor = __WPD_MAIN_COLOR__;
        
        button.layer.cornerRadius = 10;
        
        button.clipsToBounds = YES;
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)btnClick
{
    [self.delegate button:button ClickWithTitle:_title];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [button setTitle:_title forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    
}

@end




/****************************************************************/





@interface FEChecButtonCell ()<UITextFieldDelegate>

@end

@implementation FEChecButtonCell

@synthesize bankgroundView;

@synthesize textField;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
        
    }
    
    return self;
}
-(void)initUI{
    
    bankgroundView=[[UIView alloc]init];
    
    [self addSubview:bankgroundView];
    
    textField=[[UITextField alloc]init];
    
    textField.backgroundColor=[UIColor clearColor];
    
    textField.textColor = [UIColor blackColor];
    
    textField.textAlignment=NSTextAlignmentCenter;
    
    textField.font = [UIFont systemFontOfSize:12];
    
    textField.delegate = self;
    bankgroundView.backgroundColor=[UIColor whiteColor];
    bankgroundView.layer.cornerRadius=6;
    [bankgroundView addSubview:textField];
    
    _button=[[UIButton alloc]init];
    
    _button.backgroundColor=__WPD_MAIN_COLOR__;
    _button.layer.cornerRadius = 8;
    
    _button.clipsToBounds = YES;
    
    _button.titleLabel.font = [UIFont systemFontOfSize:10];
    
    
    [_button addTarget:self action:@selector(FEbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addSubview:_button];
    
   }

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.delegate FEChectextFiledCell:self DidBeginEditing:_placeholder];
    
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    textField.placeholder = _placeholder;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [_button setTitle:_title forState:UIControlStateNormal];
}

- (void)FEbtnClick
{
     [self.delegate button:_button FEChecClickWithTitle:_title];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    __weak typeof(self) weakSelf = self;
    [bankgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(8);
        make.bottom.equalTo(weakSelf).offset(-8);
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-self.frame.size.width/3-20);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankgroundView).offset(2);
        make.bottom.equalTo(bankgroundView).offset(-2);
        make.left.equalTo(bankgroundView).offset(10);
        make.right.equalTo(bankgroundView);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankgroundView);
        make.bottom.equalTo(bankgroundView);
        make.left.equalTo(textField.mas_right).offset(10);
        make.right.equalTo(weakSelf).offset(-25);
        
    }];
}
@end



/****************************************************************/




@interface FEAgreementCell ()
{
    NSString * firstString;
    
    NSString * secondString;
    UIButton * button;
}
@end

@implementation FEAgreementCell
@synthesize bankgroundView;
@synthesize agreementButton;
@synthesize bordLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
        
    }
    
    return self;
}
-(void)initUI
{
    bankgroundView=[[UIView alloc]init];
    
    [self addSubview:bankgroundView];
    
    agreementButton=[[UIButton alloc]init];
//    agreementButton.backgroundColor=[UIColor orangeColor];
    [agreementButton setImage:[UIImage imageNamed:@"duihao"] forState:(UIControlStateNormal)];
    [agreementButton addTarget:self action:@selector(FEbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [bankgroundView addSubview:agreementButton];
    
   
    bordLabel=[[YYLabel alloc]init];
    [bankgroundView addSubview:bordLabel];
    button=[[UIButton alloc]initWithFrame:bordLabel.frame];
    [button addTarget:self action:@selector(buttonwithAgreement) forControlEvents:(UIControlEventTouchUpInside)];
    
    [bankgroundView addSubview:button];
}

-(void)setAgreementString:(NSString *)string{
    
    _agreementString=string;
}

- (void)setBankgroundImage:(UIImage *)image
{
    _bankgroundImage = image;
    
    [agreementButton setImage:_bankgroundImage forState:UIControlStateNormal];
}

-(void)FEbuttonClick{
    [self.delegate button:agreementButton ClickWithImage:_bankgroundImage];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    __weak typeof(self) weakSelf = self;
    [bankgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(5);
        make.bottom.equalTo(weakSelf).offset(-2);
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf);
    }];
    
    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(bankgroundView).offset(10);
        make.centerY.equalTo(bankgroundView);
        make.height.equalTo(@(20));
        make.width.equalTo(@(20));
    }];
    
    [bordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankgroundView);
        make.bottom.equalTo(bankgroundView);
        make.left.equalTo(agreementButton.mas_right).offset(10);
        make.right.equalTo(bankgroundView);
        
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bordLabel);
        make.size.equalTo(bordLabel);
    }];
    
}
-(void)buttonwithAgreement{
    [self.delegate Agreement];
}


@end

