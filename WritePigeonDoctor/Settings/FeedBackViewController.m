//
//  FeedBackViewController.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "FeedBackViewController.h"
#import "YYTextView.h"
#import "FeedBackModel.h"
@interface FeedBackViewController ()<YYTextViewDelegate>

@property (nonatomic, strong) YYTextView * TV;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic) FeedBackModel *model;
@end

@implementation FeedBackViewController

#pragma --- life cycle

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.TV];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(subMit)];
}

- (YYTextView *)TV
{
    if (!_TV) {
        _TV = [[YYTextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 200)];
        _TV.layer.backgroundColor = [[UIColor clearColor] CGColor];
        _TV.layer.borderColor = Wonderful_BlueColor2.CGColor;
        _TV.delegate = self;
        _TV.layer.borderWidth = 2.0;
        _TV.layer.cornerRadius = 8.0f;
        [_TV.layer setMasksToBounds:YES];
        _TV.placeholderText = @"您在使用中有遇到什么问题?可以向我们及时反馈噢!";
        _TV.placeholderFont = [UIFont systemFontOfSize:18];
        _TV.placeholderTextColor = Wonderful_GrayColor6;
        _TV.font = [UIFont systemFontOfSize:18];
    }
    return _TV;
}
-(FeedBackModel *)model
{
    if (!_model)
    {
        _model=[FeedBackModel new];
    }
    return _model;
}

- (void)subMit
{
    [_TV resignFirstResponder];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showInfoWithStatus:@"感谢你的建议！"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UITextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView
{
    NSInteger number = [textView.text length];
    if (number > 128) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于128" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:128];
        number = 128;
        
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(textView.frame.size.width-80, textView.frame.size.height-30, 80, 30)];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [textView addSubview:self.label];
    
    self.label.backgroundColor = [UIColor whiteColor];

    self.label.text = [NSString stringWithFormat:@"%ld/128",(long)number];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self.view endEditing:YES];
    
}


@end
