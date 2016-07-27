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
@property (nonatomic,strong)UILabel *price;

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
    
    _price = [[UILabel alloc] init];
    [self addSubview:_price];
}

- (void)setDefaultSettings
{
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
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

@end
