//
//  RWDataBaseManager+ChatCache.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager.h"

@interface RWDataBaseManager (ChatCache)

- (BOOL)addConsultHistory:(RWHistory *)history;
- (BOOL)updateConsultHistory:(RWHistory *)history;
- (BOOL)removeConsultHistory:(RWHistory *)history;

- (NSArray *)getConsultHistory;


- (BOOL)cacheMessage:(RWWeChatMessage *)message;
- (BOOL)updateCacheMessage:(RWWeChatMessage *)message;
- (BOOL)existCacheMessage:(RWWeChatMessage *)message;
- (BOOL)removeCacheMessage:(RWWeChatMessage *)message;
- (BOOL)removeCacheMessageWith:(RWHistory *)history;
- (NSArray *)getMessageWith:(NSString *)emid;

@end
