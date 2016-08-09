//
//  RWCustomizeNavigationBar.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCustomizeNavigationBar.h"

@implementation RWCustomizeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
            {
                [view removeFromSuperview];
            }
        }
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
