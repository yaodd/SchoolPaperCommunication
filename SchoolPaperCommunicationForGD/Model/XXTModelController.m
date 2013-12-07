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

@end
