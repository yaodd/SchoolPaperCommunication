//
//  XXTUser.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTPersonBase.h"
#import "XXTGroup.h"
#import "XXTMessageReceive.h"
#import "XXTMessageSend.h"
#import "XXTMessageTemplate.h"
#import "XXTMicroblog.h"
#import "XXTHistoryMessage.h"
#import "XXTModuleMessage.h"
#import "XXTModelConfig.h"
#import "XXTBulletin.h"
#import "XXTHomework.h"
#import "XXTEvaluateTemplate.h"

@interface XXTUserRole : XXTPersonBase

@property (copy,nonatomic) NSString* schoolName;
@property (copy,nonatomic) NSString* schoolId;
@property (copy,nonatomic) NSString* areaAbbr;  //地区简称

@property (strong,nonatomic) NSArray* contactGroupArr;
@property (strong,nonatomic) NSMutableArray* allMessagesArr;
@property (strong,nonatomic) NSMutableArray* messageTemplatesArr;
@property (strong,nonatomic) NSMutableArray* messageHistoryArr;
@property (strong,nonatomic) NSMutableArray* moduleMessagesArr;
@property (strong,nonatomic) NSMutableArray* microblogsArrOfArr;
@property (strong,nonatomic) NSMutableArray* bulletinArrOfArr;
@property (strong,nonatomic) NSMutableArray* homeworkArr;
@property (strong,nonatomic) NSMutableArray* evaluateTemplatesArr;

@property (strong,nonatomic) NSDate* lastUpdateTimeForMessageList;
@property (strong,nonatomic) NSMutableArray* lastUpdateTimeForMicroblogListArr;
@property (strong,nonatomic) NSDate* lastUpdateTimeForCommentsAndLikes;
@property (strong,nonatomic) NSDate* lastUpdateTimeForMessageTemplates;
@property (strong,nonatomic) NSDate* lastUpdateTimeForModuleMessage;
@property (strong,nonatomic) NSMutableArray* lastUpdateTimeForBulletinArr;
@property (strong,nonatomic) NSDate* lastUpdateTimeForHomework;
@property (strong,nonatomic) NSDate* lastUpdateTimeForEvaluateTemplates;

@property (strong,nonatomic) NSMutableArray *myCommentsAndLikes;
@property NSInteger commentAndLikesReadCount; //已经读过的comment和like数,未读数为当前总数-已读数

- (id) initLoad;
- (void) save;

-(XXTGroup*) getGroupObjectById:(NSString*) groupId;
-(XXTPersonBase*) getPersonObjectById:(NSString*) pid;
-(NSArray*) getMessagesBetweenMeAndPerson:(NSString*) pid;

@end
