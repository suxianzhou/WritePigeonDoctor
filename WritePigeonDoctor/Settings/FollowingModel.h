//
//  FollowingModel.h
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestCompletion)(NSDictionary *responseObject, NSError *error);

@interface FollowingModel : NSObject

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy)   NSDictionary *responseDic;
@property (nonatomic,assign) BOOL canLoadNextPage;
@property (nonatomic,copy,readonly) NSMutableArray *docList;

- (void)refreshWithcompletion:(RequestCompletion)completion;

@end
