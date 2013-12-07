//
//  XXTHistoryMessage.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTHistoryMessage.h"

@implementation XXTHistoryMessage

- (XXTHistoryMessage*) initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]){
        self.msgId = [dict objectForKey:@"msgId"];
        NSString* name = [dict objectForKey:@"receiver"];
        self.receiverNames  = [NSMutableArray arrayWithObject:name];
    }
    return self;
}

- (void) receivedGroupStateDictionary:(NSDictionary *)stateDic{
    if ([self.msgId isEqualToString:[stateDic objectForKey:@"msgId"]]){
        self.sendCount = [[stateDic objectForKey:@"smsSendCount"] intValue];
        self.sendSuccessCount = [[stateDic objectForKey:@"smsSuccessCount"] intValue];
    }
}

- (void) receivedReceiverNamesArray:(NSArray *)namesArr{
    [self.receiverNames removeAllObjects];
    [self.receiverNames addObjectsFromArray:namesArr];
}

@end
