//
//  Dao.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTUserRole.h"

@interface Dao : NSObject

+(Dao*) sharedDao;

@property BOOL reachbility;

#pragma mark 用户模块
- (NSInteger) requestForLogin:(NSString*) username password:(NSString*)pwd;
- (NSInteger) requestForLogoff;
- (NSInteger) requestForForgetPasswordForAccount:(NSString*) account;
- (NSInteger) requestForDynamicPasswordForAccount:(NSString*) account;
- (NSInteger) requestForChangeProfileWithName:(NSString*) name avatar:(XXTImage*) avatar;
- (NSInteger) requestForChangePasswordForAccount:(NSString*) account
                                     OldPassword:(NSString*) oldPwd
                                    ValidateCode:(NSString*) validCode
                                     NewPassword:(NSString*) newPwd;

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
- (NSInteger) requestForPostComment:(XXTComment*) comment microblog:(XXTMicroblog *)microblog;
- (NSInteger) requestForPostLike:(XXTMicroblog*) microblog;
- (NSInteger) requestForMicroblogDetail:(XXTMicroblog*) microblog;
- (NSInteger) requestForMyCommentAndLikes;

#pragma mark 通知公告
- (NSInteger) requestForBulletinListWithType:(XXTBulletinType) type
                                      isPull:(int) isPull
                                    pageSize:(int) pageSize;
- (NSInteger) requestForPostBulletin:(XXTBulletin*) bulletin;

#pragma mark 作业管理
- (NSInteger) requestForHomeworkListForTime:(NSDate*) dateTime isPull:(int) isPull pageSize:(int) pageSize;
- (NSInteger) requestForPostHomework:(XXTHomework*) homework;

#pragma mark 学生点评
- (NSInteger) requestForEvaluateListForTime:(NSDate*) dateTime
                                     isPull:(int) isPull
                                   pageSize:(int) pageSize;
- (NSInteger) requestForEvaluateDetail:(XXTEvaluate*) evaluate;
- (NSInteger) requestForEvaluateToPerson:(XXTPersonBase*) person
                                    time:(NSDate*) dateTime
                                  isPull:(int) isPull
                                pageSize:(int) pageSize;
- (NSInteger) requestForEvaluateTemplates;
- (NSInteger) requestForPostEvaluate:(XXTEvaluate*) evaluate;

#pragma mark 提问答疑
- (NSInteger) requestForQuestionListForSubjectId:(int) subjectId
                                           state:(int) state
                                      questioner:(int) questioner
                                           grade:(int) gradeId
                                            page:(int) page
                                        pageSize:(int) pageSize;
- (NSInteger) requestForQuestionDetail:(XXTQuestion*) question;
- (NSInteger) requestForPostQuestion:(XXTQuestion*) question;
- (NSInteger) requestForPostAnswer:(XXTAnswer*) answer forQuestion:(XXTQuestion*) question;
- (NSInteger) requestForGradeList;

#pragma mark 意见反馈
- (NSInteger) requestForFeedbackListWithPageNo:(int) page pageSize:(int) pageSize;
- (NSInteger) requestForPostFeedback:(NSString*) content;

#pragma mark 补充功能
- (NSInteger) requestForClassList;
- (NSInteger)

@end
