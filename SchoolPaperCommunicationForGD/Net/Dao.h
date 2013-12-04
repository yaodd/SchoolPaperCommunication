//
//  Dao.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTMessageSend.h"

@interface Dao : NSObject

+(Dao*) sharedDao;

@property BOOL reachbility;

- (NSInteger) requestForLogin:(NSString*) username password:(NSString*)pwd;

- (NSInteger) requestForMessageList;
- (NSInteger) requestForMessageStatusUpdateWithMessageObjects:(NSArray*)messageObjects;

- (NSInteger) requestForSendGroupMessage:(XXTMessageSend*) messageToSend;
//群发消息, 只有教师版才可以调用这个接口
- (NSInteger) requestForSendInstantMessage:(XXTMessageSend*) messageToSend;

- (NSInteger) requestForGetContactList;

@end
