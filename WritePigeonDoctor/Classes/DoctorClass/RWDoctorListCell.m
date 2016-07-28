//
//  RWDoctorListCell.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDoctorListCell.h"

@interface RWDoctorListCell ()

@property (nonatomic,strong)UIImageView *header;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *professionalTitle;
@property (nonatomic,strong)UILabel *office;
@property (nonatomic,strong)UILabel *expenses;

@end

@implementation RWDoctorListCell

- (void)initViews
{
    _header = [[UIImageView alloc] init];
    [self addSubview:_header];
    
    _name = [[UILabel alloc] init];
    [self addSubview:_name];
    
    _professionalTitle = [[UILabel alloc] init];
    [self addSubview:_professionalTitle];
    
    _office = [[UILabel alloc] init];
    [self addSubview:_office];
    
    _expenses = [[UILabel alloc] init];
    [self addSubview:_expenses];
}

- (void)setDefaultSettings
{
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    CGFloat itemHeight = (self.frame.size.height - 40) / 3;
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(60));
        make.height.equalTo(@(itemHeight));
        make.left.equalTo(_header.mas_right).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [_professionalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_name.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_name.mas_top).offset(0);
        make.bottom.equalTo(_name.mas_bottom).offset(0);
    }];
    
    [_office mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_header.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_professionalTitle.mas_top).offset(0);
        make.height.equalTo(@(itemHeight));
    }];
    
    [_expenses mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_header.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_office.mas_top).offset(0);
        make.height.equalTo(@(itemHeight));
    }];
}

- (void)autoLayoutViews
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

- (void)setDoctor:(RWDoctorItem *)doctor
{
    _doctor = doctor;
    
    _header.image = doctor.header;
    _name.text = doctor.name;
    _professionalTitle.text = doctor.professionalTitle;
    _office.text = doctor.office;
    _expenses.text = doctor.expenses;
}

@end
