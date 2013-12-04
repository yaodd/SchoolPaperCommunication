//
//  XXTModelController.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTUser.h"
#import "XXTAppUpdateMessage.h"

@interface XXTModelController : NSObject

+ (void) loginSuccess:(NSDictionary*) receivedDic;

+ (void) receivedNewMessages:(NSArray*) messagesDicArr;
+ (void) receivedAppUpdateMessage:(NSDictionary*) updateMessageDic;
+ (void) ReceiveMessageStatusUpdate:(NSArray*)messageObjects;

+ (void) prepareToSendGroupMessage:(XXTMessageSend*) messageSend;
+ (void) groupMessageSendSuccess:(XXTMessageSend*) messageSend WithDictionary:(NSDictionary*) dict;

+ (void) prepareToInstantMessage:(XXTMessageSend*) messageSend;
+ (void) instantMessageSendSuccess:(XXTMessageSend*) messageSend WithDictionary:(NSDictionary*) dict;

@end
