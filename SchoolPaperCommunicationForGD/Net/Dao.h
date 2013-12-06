//
//  Dao.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTMessageSend.h"
#import "XXTMicroblog.h"
#import "XXTHistoryMessage.h"

@interface Dao : NSObject

+(Dao*) sharedDao;

@property BOOL reachbility;

- (NSInteger) requestForLogin:(NSString*) username password:(NSString*)pwd;

#pragma mark 消息模块
- (void) setTimerForMessageList;
//在调用该函数的进程中创建一个刷新消息的定时器
- (NSInteger) requestForMessageList;
- (NSInteger) requestForMessageStatusUpdateWithMessageObjects:(NSArray*)messageObjects;
- (NSInteger) requestForSendGroupMessage:(XXTMessageSend*) messageToSend;
//群发消息, 只有教师版才可以调用这个接口
- (NSInteger) requestForMessageTemplates;
- (NSInteger) requestForMessageHistoryWithDate:(NSDate*) date
                                        isPull:(BOOL) isPull
                                      pageSize:(int) pageSize
                                       keyword:(NSString*) keyword
                                          type:(XXTHistoryType) type;
- (NSInteger) requestForMessageReceivers:(XXTHistoryMessage*) message;
- (NSInteger) requestForModuleMessages;
#pragma mark 通讯录
- (NSInteger) requestForSendInstantMessage:(XXTMessageSend*) messageToSend;
- (NSInteger) requestForGetContactList; //返回404表示通讯录zip文件尚未生成,需要重新生成

#pragma mark 家校圈
- (NSInteger) requestForMicroblogsListWithType:(XXTMicroblogCircleType) circleType
                                        isPull:(NSInteger) isPull
                                      pageSize:(NSInteger) pageSize;
//isPull:1为下拉更新, 0为上拉获取
- (NSInteger) requestForPostMicroblog:(XXTMicroblog*) microblog;
- (NSInteger) requestforPostComment:(XXTComment*) comment microblog:(XXTMicroblog *)microblog;
- (NSInteger) requestForPostLike:(XXTMicroblog*) microblog;
- (NSInteger) requestForMicroblogDetail:(XXTMicroblog*) microblog;
- (NSInteger) requestForMyCommentAndLikes;

@end
