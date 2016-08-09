//
//  RWDoctorListCell.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWObjectModels.h"

@interface RWDoctorListCell : UITableViewCell

@property (nonatomic,strong)RWDoctorItem *doctor;
@property (nonatomic,strong)RWHistory *history;

@end
