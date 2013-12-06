//
//  XXTModelController.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTModelGlobal.h"
#import "XXTAppUpdateMessage.h"

@interface XXTModelController : NSObject

+ (void) loginSuccess:(NSDictionary*) receivedDic;
+ (void) selectUserRole:(XXTUserRole*) user;

+ (void) receivedNewMessages:(NSArray*) messagesDicArr;
+ (void) receivedAppUpdateMessage:(NSDictionary*) updateMessageDic;
+ (void) ReceiveMessageStatusUpdate:(NSArray*)messageObjects;

+ (void) prepareToSendGroupMessage:(XXTMessageSend*) messageSend;
+ (void) groupMessageSendSuccess:(XXTMessageSend*) messageSend
                  WithDictionary:(NSDictionary*) dict;

+ (void) prepareToInstantMessage:(XXTMessageSend*) messageSend;
+ (void) instantMessageSendSuccess:(XXTMessageSend*) messageSend
                    WithDictionary:(NSDictionary*) dict;

+ (void) receivedMicroblogDics:(NSArray*) microblogsDicArr
                      WithType:(XXTMicroblogCircleType)circleType;
+ (void) postMicroblogSuccess:(XXTMicroblog*) microblog
                      WithDic:(NSDictionary*) receivedDic;
+ (void) postCommentSuccess:(XXTComment*)comment
                ToMicroblog:(XXTMicroblog*) microblog
                    WithDic:(NSDictionary*) receivedDic;
+ (void) postLikeSuccessToMicroblog:(XXTMicroblog*) microblog
                            WithDic:(NSDictionary*) receivedDic;

+ (void) microblogDetail:(NSDictionary*) receivedDic
            forMicroblog:(XXTMicroblog*) microblog;

+ (void) getCommentsAndLikes:(NSArray*) commentsAndLikes;

+ (void) receivedMessageTemplatesDictionary:(NSDictionary*) receivedDictionary;
+ (void) receivedMessageHistoryDictionary:(NSDictionary*) receivedDic;
+ (void) receivedMessageHistoryReceiverDic:(NSDictionary*) receiverDic
                                ForMessage:(XXTHistoryMessage*) message;
+ (void) receivedModuleMessageDic:(NSDictionary*) receiveDic;
+ (void) receivedContactsListDicArr:(NSArray*) groupDicArr;

@end
