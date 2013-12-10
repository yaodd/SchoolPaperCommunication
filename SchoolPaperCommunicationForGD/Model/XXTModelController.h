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

#pragma mark 客户端需要调用的接口
+ (void) selectUserRole:(XXTUserRole*) user;

+ (void) prepareToSendGroupMessage:(XXTMessageSend*) messageSend;
+ (void) prepareToInstantMessage:(XXTMessageSend*) messageSend;
+ (void) prepareToPostBulletin:(XXTBulletin*) bulletin;
+ (void) prepareToPostHomework:(XXTHomework*) homework;
+ (void) prepareToPostEvaluate:(XXTEvaluate*) evaluate;

#pragma mark 网络端用的接口, 客户端可以不用理
+ (void) loginSuccess:(NSDictionary*) receivedDic;
+ (void) logoffSuccess;
+ (void) receivedNewMessages:(NSArray*) messagesDicArr;
+ (void) receivedAppUpdateMessage:(NSDictionary*) updateMessageDic;
+ (void) ReceiveMessageStatusUpdate:(NSArray*)messageObjects;
+ (void) groupMessageSendSuccess:(XXTMessageSend*) messageSend
                  WithDictionary:(NSDictionary*) dict;
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

+ (void) receivedBulletinListDicArr:(NSArray*) bulletinDicArr type:(XXTBulletinType) type;
+ (void) postBulletinSuccess:(XXTBulletin*) bulletin WithDic:(NSDictionary*) receivedDic;

+ (void) receivedHomeworkListDicArr:(NSArray*) homeworkDicArr;
+ (void) postHomeworkSuccess:(XXTHomework*) homework WithDic:(NSDictionary*) receivedDic;

+ (void) receivedEvaluateListDicArr:(NSArray*) evaluateDicArr;
+ (void) receivedEvaluateDetailFor:(XXTEvaluate*) evaluate PersonDicArr:(NSArray*) personDicArr;

+ (void) receivedEvaluateHistory2Person:(XXTPersonBase*) person evaluateDicArr:(NSArray*) evaluateDicArr;

+ (void) receivedEvaluateTemplatesWithDic:(NSDictionary*) dict;

+ (void) postEvaluateSuccess:(XXTEvaluate*) evaluate WithDictionary:(NSDictionary*) receivedDic;
+ (void) receivedFeedbackDic:(NSDictionary*) receivedDic;
+ (void) receivedQuestionListDicArr:(NSArray*) questionDicArr;
@end
