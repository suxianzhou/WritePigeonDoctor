//
//  RWOfficeListController.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWOfficeListController.h"
#import "RWDoctorListController.h"
#import "RWRequsetManager.h"
#import "RWTestDataSource.h"

@interface RWOfficesCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation RWOfficesCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
    }
    
    return self;
}

@end

@interface RWOfficeListController ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    RWRequsetDelegate
>

@property (nonatomic,strong)UICollectionView *offices;
@property (nonatomic,strong)NSArray *officeList;
@property (nonatomic,strong)RWRequsetManager *requestManager;

@end

@implementation RWOfficeListController

- (void)initViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _offices = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                  collectionViewLayout:flowLayout];
    [self.view addSubview:_offices];
    
    [_offices mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _offices.backgroundColor = [UIColor whiteColor];
    
    _offices.delegate = self;
    _offices.dataSource = self;
    
    _offices.showsVerticalScrollIndicator = NO;
    _offices.showsHorizontalScrollIndicator = NO;
    
    [_offices registerClass:[RWOfficesCell class] forCellWithReuseIdentifier:NSStringFromClass([RWOfficesCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _officeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWOfficesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWOfficesCell class]) forIndexPath:indexPath];
    
    RWOfficeItem *item = _officeList[indexPath.row];
    
//    cell.imageView.image = item.image;
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:item.image]
                        placeholder:[UIImage imageNamed:@"image-placeholder"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/4, collectionView.bounds.size.width/4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWOfficeItem *item = _officeList[indexPath.row];
    
    RWDoctorListController *doctorList = [[RWDoctorListController alloc] init];
    
//    doctorList.doctorResource = item.doctorList;
    doctorList.doctorListUrl = item.doctorList;
    
    [self pushNextWithViewcontroller:doctorList];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找医生";
//    _officeList = [RWTestDataSource getResource];
    
    _requestManager = [[RWRequsetManager alloc] init];
    _requestManager.delegate = self;
    
    [_requestManager obtainOfficeList];
    
    [self initViews];
}

- (void)requsetOfficeList:(NSArray *)officeList responseMessage:(NSString *)responseMessage
{
    if (officeList)
    {
        _officeList = officeList;
        [_offices reloadData];
    }
    else
    {
        [RWSettingsManager promptToViewController:self
                                            Title:responseMessage
                                         response:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
