//
//  FollowingModel.m
//  WritePigeonDoctor
//
//  Created by ZYJY on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "FollowingModel.h"
#import "XZUMComPullRequest.h"
@interface FollowingModel ()

@property (nonatomic,copy) NSMutableArray * docList;

@end

@implementation FollowingModel

-(id)init
{
    if (self=[super init])
    {
        
    }
    return self;
}

-(NSMutableArray*)newsList
{
    if (!_docList)
    {
        _docList=[NSMutableArray new];
    }
    return _docList;
}

-(NSDictionary *)infoAtIndexPath:(NSIndexPath *) indexPath
{
    if (self.docList.count>0)
    {
        return self.docList[indexPath.row];
    }
    return @{};
}

- (void)refreshWithcompletion:(RequestCompletion)completion
{
    WEAKSELF
   [XZUMComPullRequest fecthUserFollowingsWithUid:@"57a956b87019c94b65fc4d98" count:20 completion:^(NSDictionary *responseObject, NSError *error) {
       
       completion (responseObject,error);
       if (!error) {
        NSArray * arr = responseObject[@"data"];
        [weakSelf.newsList addObjectsFromArray:arr];
       }
   }];
    
}


@end
