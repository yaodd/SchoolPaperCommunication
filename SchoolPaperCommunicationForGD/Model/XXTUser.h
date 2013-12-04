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
#import "XXTMicroblog.h"

@interface XXTUser : XXTPersonBase

+(XXTUser*) sharedUser;

@property (copy,nonatomic) NSString* schoolName;
@property (copy,nonatomic) NSString* schoolId;
@property (copy,nonatomic) NSString* areaAbbr;  //地区简称

@property (copy,nonatomic) NSString* sessionId;
@property (copy,nonatomic) NSString* deviceToken;

@property (strong,nonatomic) NSArray* contactGroupArr;
@property (strong,nonatomic) NSMutableArray* allMessagesArr;

@property (strong,nonatomic) NSMutableArray* microblogsArr;

@property (strong,nonatomic) NSDate* lastUpdateTimeForMessageList;

-(void) initWithLoginInfoDictionary:(NSDictionary*) infoDic;

-(XXTGroup*) getGroupObjectById:(NSString*) groupId;
-(XXTPersonBase*) getPersonObjectById:(NSString*) pid;

@end
