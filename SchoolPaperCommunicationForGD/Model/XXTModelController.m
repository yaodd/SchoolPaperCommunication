//
//  XXTModelController.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTModelController.h"
#import "Dao.h"

@implementation XXTModelController

+ (void) loginSuccess:(NSDictionary *)receivedDic{
    [[XXTModelGlobal sharedModel] initWithLoginInfoDictionary:receivedDic];
}

+ (void) logoffSuccess{
    [[XXTModelGlobal sharedModel].currentUser save];
}

+ (void) selectUserRole:(XXTUserRole *)user{
    [[Dao sharedDao] performSelectorInBackground:@selector(setTimerForMessageList) withObject:nil];
    [XXTModelGlobal sharedModel].currentUser = user;
}

+(void) receivedNewMessages:(NSArray *)messagesDicArr{
    for (NSDictionary* messageDic in messagesDicArr){
        XXTMessageReceive* message = [[XXTMessageReceive alloc] initWithDictionary:messageDic];
        [[XXTModelGlobal sharedModel].currentUser.allMessagesArr addObject:message];
    }
    [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMessageList = [NSDate date];
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
    [[XXTModelGlobal sharedModel].currentUser.allMessagesArr addObject:messageSend];
}

+ (void) groupMessageSendSuccess:(XXTMessageSend *)messageSend WithDictionary:(NSDictionary *)dict{
    messageSend.msgId = [dict objectForKey:@"msgId"] ;
    messageSend.dateTime = [NSDate date];
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
    [[XXTModelGlobal sharedModel].currentUser.allMessagesArr addObject:messageSend];
}

+ (void) instantMessageSendSuccess:(XXTMessageSend *)messageSend WithDictionary:(NSDictionary*) dict{
    messageSend.msgId = [dict objectForKey:@"msgId"];
    messageSend.dateTime = [NSDate date];
}

+ (void) receivedMicroblogDics:(NSArray *)microblogsDicArr WithType:(XXTMicroblogCircleType)circleType{
    for (NSDictionary* microblogDic in microblogsDicArr){
        XXTMicroblog* microblog = [[XXTMicroblog alloc] initWithDictionary:microblogDic];
        [[[XXTModelGlobal sharedModel].currentUser.microblogsArrOfArr objectAtIndex:circleType] addObject:microblog];
    }
//    [[[XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMicroblogListArr set[NSDate date]];
    [[XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMicroblogListArr setObject:[NSDate date] atIndexedSubscript:circleType];
}

+ (void) postMicroblogSuccess:(XXTMicroblog *)microblog WithDic:(NSDictionary *)receivedDic{
    microblog.msgId = [receivedDic objectForKey:@"id"];
    
    [[[XXTModelGlobal sharedModel].currentUser.microblogsArrOfArr objectAtIndex:XXTMicroblogCircleTypeMine] addObject:microblog];
    
    [[XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMicroblogListArr setObject:[NSDate date] atIndexedSubscript:XXTMicroblogCircleTypeMine];
}

+ (void) postCommentSuccess:(XXTComment *)comment ToMicroblog:(XXTMicroblog *)microblog WithDic:(NSDictionary *)receivedDic
{
    microblog.commentCount = [[receivedDic objectForKey:@"count"] intValue];
    [microblog.commentsArr addObject:comment];
}

+ (void) postLikeSuccessToMicroblog:(XXTMicroblog *)microblog WithDic:(NSDictionary *)receivedDic
{
    microblog.likeCount = [[receivedDic objectForKey:@"count"] intValue];
}

+ (void) microblogDetail:(NSDictionary *)receivedDic forMicroblog:(XXTMicroblog *)microblog{
    NSArray* commentDicArr = [receivedDic objectForKey:@"items"];
    [microblog.commentsArr removeAllObjects];
    for (NSDictionary* commentDic in commentDicArr){
        XXTComment* comment = [[XXTComment alloc] initWithDictionary:commentDic];
        [microblog.commentsArr addObject:comment];
    }
    microblog.commentCount = [commentDicArr count];
}

+ (void) getCommentsAndLikes:(NSArray *)commentsAndLikes
{
    [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForCommentsAndLikes = [NSDate date];
    for (NSDictionary* commendAndLikeDic in commentsAndLikes){
        XXTComment* newComment = [[XXTComment alloc] initWithDictionary:commendAndLikeDic];
        [[XXTModelGlobal sharedModel].currentUser.myCommentsAndLikes addObject:newComment];
    }
}

+ (void) receivedMessageTemplatesDictionary:(NSDictionary *)receivedDictionary{
    NSDate* lastUpdateTime = [NSDate dateFromString:[receivedDictionary objectForKey:@"dateTime"]];
    [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMessageTemplates = lastUpdateTime;
    
    NSArray* templateDicArr = [receivedDictionary objectForKey:@"items"];
    [[XXTModelGlobal sharedModel].currentUser.messageTemplatesArr removeAllObjects];
    for (NSDictionary* templateDic in templateDicArr){
        XXTMessageTemplate* template = [[XXTMessageTemplate alloc] initWithDictionary:templateDic];
        [[XXTModelGlobal sharedModel].currentUser.messageTemplatesArr addObject:template];
    }
}

+ (void) receivedMessageHistoryDictionary:(NSDictionary *)receivedDic{
    
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    
    for (NSDictionary* messageDic in [receivedDic objectForKey:@"items"]){
        XXTHistoryMessage* historyMessage = [[XXTHistoryMessage alloc] initWithDictionary:messageDic];
        
        XXTHistoryMessage* theSameMessage = nil;
        for (XXTHistoryMessage* message in currentUser.messageHistoryArr){
            if ([message.msgId isEqualToString:historyMessage.msgId]){
                theSameMessage = message;
                break;
            }
        }
        
        if (theSameMessage != nil){
            [currentUser.messageHistoryArr removeObject:theSameMessage];
        }
        [currentUser.messageHistoryArr addObject:historyMessage];
    }
}

+ (void) receivedMessageHistoryReceiverDic:(NSDictionary *)receiverDic ForMessage:(XXTHistoryMessage *)message{
    NSArray* receiversArr = [receiverDic objectForKey:@"items"];
    [message receivedReceiverNamesArray:receiversArr];
}

+ (void) receivedModuleMessageDic:(NSDictionary *)receiveDic{
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    currentUser.lastUpdateTimeForModuleMessage = [NSDate date];
    
    NSArray* moduleMessageDicArr = [receiveDic objectForKey:@"items"];
    for (NSDictionary* dict in moduleMessageDicArr){
        XXTModuleMessage* msg = [[XXTModuleMessage alloc] initWithDictionary:dict];
        
        NSMutableArray* originMessageArr = currentUser.moduleMessagesArr;
        for (XXTModuleMessage *originMsg in originMessageArr){
            if ([originMsg.type isEqualToString:msg.type]){
                [originMessageArr removeObject:originMsg];
                break;
            }
        }
        
        [originMessageArr addObject:msg];
    }
}

+ (void) receivedContactsListDicArr:(NSArray *)groupDicArr{
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSMutableArray *groupArr = [NSMutableArray array];
    for (NSDictionary* groupDic in groupDicArr){
        XXTGroup* group = [[XXTGroup alloc] initWithDictionary:groupDic];
        [groupArr addObject:group];
    }
    currentUser.contactGroupArr = groupArr;
}

+ (void) receivedBulletinListDicArr:(NSArray *)bulletinDicArr type:(XXTBulletinType)type{
    XXTUserRole *currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSMutableArray* bulletinArr = [currentUser.bulletinArrOfArr objectAtIndex:type];
    for (NSDictionary* bulletinDic in bulletinDicArr){
        XXTBulletin *bulletin = [[XXTBulletin alloc] initWithDictionary:bulletinDic];
        for (XXTBulletin* oldBulletin in bulletinArr){
            if ([oldBulletin.bid isEqualToNumber:bulletin.bid])
            {
                [bulletinArr removeObject:oldBulletin];
                break;
            }
        }
        [bulletinArr addObject:bulletin];
    }
}

+ (void) prepareToPostBulletin:(XXTBulletin *)bulletin{
    NSMutableArray* arr = [[XXTModelGlobal sharedModel].currentUser.bulletinArrOfArr objectAtIndex:XXTBulletinTypeClass];
    [arr addObject:bulletin];
    //既然只有教师端,那应该都是加在Class通知里面吧
}

+ (void) postBulletinSuccess:(XXTBulletin *)bulletin WithDic:(NSDictionary *)recievedDic{
    bulletin.bid = [recievedDic objectForKey:@"id"];
}

+ (void) receivedHomeworkListDicArr:(NSArray *)homeworkDicArr{
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSMutableArray* homeworkArr = currentUser.homeworkArr;
    for (NSDictionary* homeworkDic in homeworkDicArr){
        XXTHomework* homework = [[XXTHomework alloc] initWithDictionary:homeworkDic];
        for (XXTHomework* oldHmwork in homeworkArr){
            if ([oldHmwork.homeworkId isEqualToNumber:homework.homeworkId]){
                [homeworkArr removeObject:oldHmwork];
                break;
            }
        }
        [homeworkArr addObject:homework];
    }
}

+ (void) prepareToPostHomework:(XXTHomework *)homework{
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    [currentUser.homeworkArr addObject:homework];
}

+ (void) postHomeworkSuccess:(XXTHomework *)homework WithDic:(NSDictionary *)receivedDic{
    homework.homeworkId = [receivedDic objectForKey:@"id"];
    homework.dateTime = [NSDate date];
}

+ (void) receivedEvaluateListDicArr:(NSArray*)evaluateDicArr{
    XXTUserRole *currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSMutableArray* evaluateList = currentUser.evaluateArr;
    for (NSDictionary* evaluateDic in  evaluateDicArr){
        XXTEvaluate* newEvaluate = [[XXTEvaluate alloc] initWithDictionary:evaluateDic];
        for (XXTEvaluate* oldEvaluate in evaluateList){
            if ([oldEvaluate.eid isEqualToNumber:newEvaluate.eid]){
                [evaluateList removeObject:oldEvaluate];
                break;
            }
        }
        [evaluateList addObject:newEvaluate];
    }
}

+ (void) receivedEvaluateDetailFor:(XXTEvaluate *)evaluate PersonDicArr:(NSArray *)personDicArr
{
    NSMutableArray* personArr = [NSMutableArray array];
    for (NSDictionary* dict in personDicArr){
        XXTEvaluatedPerson* person = [[XXTEvaluatedPerson alloc] initWithDictionary:dict];
        [personArr addObject:person];
    }
    
    evaluate.evaluatedPersonArr = personArr;
}

+ (void) receivedEvaluateHistory2Person:(XXTPersonBase *)person
                         evaluateDicArr:(NSArray *)evaluateDicArr
{
    for (NSDictionary* evaluateDic in evaluateDicArr){
        XXTEvaluate* evaluate = [[XXTEvaluate alloc] initWithDictionary:evaluateDic];
        for (XXTEvaluate* oldEva in person.evaluateArr){
            if ([oldEva.eid isEqual:evaluate.eid]){
                [person.evaluateArr removeObject:oldEva];
                break;
            }
        }
        [person.evaluateArr addObject:evaluate];
    }
}

+ (void) receivedEvaluateTemplatesWithDic:(NSDictionary *)dict{
    XXTUserRole *currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSDate* updateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
    currentUser.lastUpdateTimeForEvaluateTemplates = updateTime;
    
    NSArray* tempDicArr = [dict objectForKey:@"items"];
    [currentUser.evaluateTemplatesArr removeAllObjects];
    
    for (NSDictionary* tempDic in tempDicArr){
        XXTEvaluateTemplate* temp = [[XXTEvaluateTemplate alloc] initWithDictionary:tempDic];
        [currentUser.evaluateTemplatesArr addObject:temp];
    }
}

+ (void) prepareToPostEvaluate:(XXTEvaluate *)evaluate{
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    
    for (XXTEvaluatedPerson* person in evaluate.evaluatedPersonArr){
        NSNumber *pid = person.pid;
        XXTPersonBase *evaPerson = [currentUser getPersonObjectById:pid.stringValue];
        [evaPerson.evaluateArr addObject:evaluate];
    }
}

+ (void) postEvaluateSuccess:(XXTEvaluate *)evaluate WithDictionary:(NSDictionary *)receivedDic
{
    evaluate.eid = [receivedDic objectForKey:@"id"];
}

+ (void) receivedFeedbackDic:(NSDictionary *)receivedDic{
    NSArray* feedbackDicArr = [receivedDic objectForKey:@"items"];
    NSMutableArray *feedbacks = [NSMutableArray array];
    for (NSDictionary* feedbackDic in feedbackDicArr){
        XXTFeedback* feedback = [[XXTFeedback alloc] initWithDictionary:feedbackDic];
        [feedbacks addObject:feedback];
    }
    
    [XXTModelGlobal sharedModel].feedbackArr = feedbacks;
    [XXTModelGlobal sharedModel].feedbackCount = [[receivedDic objectForKey:@"total"] intValue];
}

@end
