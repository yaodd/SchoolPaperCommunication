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

@interface XXTUserRole : XXTPersonBase

@property (copy,nonatomic) NSString* schoolName;
@property (copy,nonatomic) NSString* schoolId;
@property (copy,nonatomic) NSString* areaAbbr;  //地区简称

@property (strong,nonatomic) NSArray* contactGroupArr;
@property (strong,nonatomic) NSMutableArray* allMessagesArr;
@property (strong,nonatomic) NSMutableArray* messageTemplatesArr;
@property (strong,nonatomic) NSMutableArray* messageHistoryArr;
@property (strong,nonatomic) NSMutableArray* moduleMessagesArr;

@property (strong,nonatomic) NSArray* microblogsArrOfArr;  //

@property (strong,nonatomic) NSDate* lastUpdateTimeForMessageList;
@property (strong,nonatomic) NSMutableArray* lastUpdateTimeForMicroblogListArr;
@property (strong,nonatomic) NSDate* lastUpdateTimeForCommentsAndLikes;
@property (strong,nonatomic) NSDate* lastUpdateTimeForMessageTemplates;
@property (strong,nonatomic) NSDate* lastUpdateTimeForModuleMessage;

-(XXTGroup*) getGroupObjectById:(NSString*) groupId;
-(XXTPersonBase*) getPersonObjectById:(NSString*) pid;

@property (strong,nonatomic) NSMutableArray *myCommentsAndLikes;
@property NSInteger commentAndLikesReadCount; //已经读过的comment和like数,未读数为当前总数-已读数

@end
