//
//  RWDataBaseManager+NameCardCollectMessage.h
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/8/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager.h"

@interface RWDataBaseManager (NameCardCollectMessage)

- (BOOL)addNameCard:(RWCard *)card;
- (void)addNameCardWithItem:(RWDoctorItem *)item completion:(void(^)(BOOL success))completion;
- (BOOL)updateNameCard:(RWCard *)card;
- (BOOL)removeNameCard:(RWCard *)card;
- (NSArray *)getNameCards;

- (BOOL)hasNameCard:(RWWeChatMessage *)message;

- (BOOL)collectMessage:(RWWeChatMessage *)message;
- (BOOL)updateCollectMessage:(RWWeChatMessage *)message;
- (BOOL)existCollectMessage:(RWWeChatMessage *)message;
- (BOOL)removeCollectMessage:(RWWeChatMessage *)message;
- (BOOL)removeCollectMessageWithCard:(RWCard *)card;
- (NSArray *)getCollectMessageWith:(NSString *)emid;

@end
