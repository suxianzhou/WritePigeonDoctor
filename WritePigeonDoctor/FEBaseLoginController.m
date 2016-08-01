//
//  FEBaseLoginController.m
//  LoginTest
//
//  Created by zhongyu on 16/7/28.
//  Copyright © 2016年 zhongyu. All rights reserved.
//

#import "FEBaseLoginController.h"
@interface FEBaseLoginController ()
@property(nonatomic,strong)UIImageView * backImageView;

@end



@implementation FEBaseLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackImageView];
    [self createHeaderView];
    _tap=[self addTapGesture];
    
}

-(void)createBackImageView{
    
    _backImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"311f1acbe389dbe322ffcf5305bc98d4.jpg"]];
    _backImageView.frame=[UIScreen mainScreen].bounds;
    _backImageView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backImageView];
}
-(void)createHeaderView{
    
    _backView=[[UIView alloc]init];
    
    
    [self.view addSubview:_backView];
    
    UIView *backView = [[UIView alloc]init];
    
    backView.backgroundColor = [UIColor clearColor];
    [_backView addSubview:backView];
    UILabel *titleLabel = [[UILabel alloc]init];
    
    titleLabel.text = @"白鸽 · Doctor";
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    titleLabel.font=[UIFont systemFontOfSize:30];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.shadowColor = [UIColor yellowColor];
    
    [backView addSubview:titleLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_backView.mas_left).offset(40);
        make.right.equalTo(_backView.mas_right).offset(-40);
        make.top.equalTo(_backView.mas_top).offset(20);
        make.bottom.equalTo(_backView.mas_bottom).offset(-20);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(backView.mas_top);
        make.bottom.equalTo(backView.mas_bottom);
    }];

    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(self.view.frame.size.height-self.view.frame.size.height/4));
        make.width.equalTo(self.view);
    }];
    
    
}
- (UITapGestureRecognizer *)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;

    return tap;
}
/**
 *  触摸时后的事件
 */
- (void)releaseFirstResponder
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
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
