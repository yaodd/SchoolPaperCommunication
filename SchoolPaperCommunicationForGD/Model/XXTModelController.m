//
//  XXTModelController.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTModelController.h"

@implementation XXTModelController

+ (void) loginSuccess:(NSDictionary *)receivedDic{
    [[XXTUser sharedUser] initWithLoginInfoDictionary:receivedDic];
}

+(void) receivedNewMessages:(NSArray *)messagesDicArr{
    for (NSDictionary* messageDic in messagesDicArr){
        XXTMessageReceive* message = [[XXTMessageReceive alloc] initWithDictionary:messageDic];
        [[XXTUser sharedUser].allMessagesArr addObject:message];
    }
    
}

+(void) receivedAppUpdateMessage:(NSDictionary *)updateMessageDic{
    XXTAppUpdateMessage *updateMessage = [[XXTAppUpdateMessage alloc] initWithDictionary:updateMessageDic];
    
    NSLog(@"%@",updateMessage);
}

+ (void) ReceiveMessageStatusUpdate:(NSArray *)messageObjects{
    for (XXTMessageReceive* message in messageObjects)
        message.isRead = TRUE;
}

+ (void) prepareToSendGroupMessage:(XXTMessageSend *)messageSend{
    [[XXTUser sharedUser].allMessagesArr addObject:messageSend];
}

+ (void) groupMessageSendSuccess:(XXTMessageSend *)messageSend WithDictionary:(NSDictionary *)dict{
    messageSend.msgId = [dict objectForKey:@"msgId"] ;
    messageSend.sendTime = [NSDate date];
    int smsSuccessCount = [[dict objectForKey:@"smsSuccessCount"] intValue];
    int smsUnSuccessCount = [[dict objectForKey:@"smsUnSuccessCount"] intValue];
    int msgReadCount = [[dict objectForKey:@"msgReadCount"] intValue];
    int msgUnReadCount = [[dict objectForKey:@"msgUnReadCount"] intValue];
    
    messageSend.sendCount = smsSuccessCount+smsUnSuccessCount == 0?
                            msgReadCount+msgUnReadCount : smsSuccessCount+smsUnSuccessCount;
    messageSend.sendSuccessCount = smsSuccessCount;
    messageSend.readCount = msgReadCount;
}

+ (void) prepareToInstantMessage:(XXTMessageSend *)messageSend{
    [[XXTUser sharedUser].allMessagesArr addObject:messageSend];
}

+ (void) instantMessageSendSuccess:(XXTMessageSend *)messageSend WithDictionary:(NSDictionary*) dict{
    messageSend.msgId = [dict objectForKey:@"msgId"];
    messageSend.sendTime = [NSDate date];
}

@end
