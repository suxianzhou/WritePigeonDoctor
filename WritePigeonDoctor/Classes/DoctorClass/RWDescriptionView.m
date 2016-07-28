//
//  RWDescriptionView.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDescriptionView.h"

@interface RWDescriptionView ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@end

@implementation RWDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end

@interface RWDescriptionCell ()

@property (nonatomic,strong)UIImageView *header;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UIButton *attention;
@property (nonatomic,strong)UILabel *professionalTitle;
@property (nonatomic,strong)UILabel *office;
@property (nonatomic,strong)UITextView *descriptionView;

@end

@implementation RWDescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
    }
    
    return self;
}

@end

@interface RWPartitionView ()

@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIButton *textLabel;
@property (nonatomic,strong)UIImageView *arrowhead;

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *make);
@property (nonatomic,copy)void(^switchControl)(BOOL isOpen);

@end

@implementation RWPartitionView

+ (instancetype)partitionWithAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout switchControl:(void(^)(BOOL isOpen))switchControl
{
    RWPartitionView *view = [[RWPartitionView alloc] init];
    
    view.autoLayout = autoLayout;
    view.switchControl = switchControl;
    
    return view;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _line = [[UIView alloc] init];
        [self addSubview:_line];
        _line.backgroundColor = [UIColor grayColor];
        
        _textLabel = [[UIButton alloc] init];
        [self addSubview:_textLabel];
        [_textLabel setTitle:@"医生简介" forState:UIControlStateNormal];
        _textLabel.backgroundColor = [UIColor clearColor];
        
        _arrowhead = [[UIImageView alloc] init];
        [self addSubview:_arrowhead];
//        _arrowhead.image = [UIImage imageNamed:@""];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.equalTo(@(2));
            make.centerY.equalTo(self.mas_centerY).offset(0);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(40));
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.centerX.equalTo(self.mas_centerX).offset(-self.bounds.size.height);
        }];
        
        [_arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(self.bounds.size.height));
            make.height.equalTo(@(self.bounds.size.height));
            make.left.equalTo(_textLabel.mas_right).offset(0);
            make.centerX.equalTo(self.mas_centerY).offset(0);
        }];
    }
    
}

@end
