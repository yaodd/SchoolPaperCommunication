//
//  XXTMessage.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

@interface XXTMessageReceive : XXTMessageBase

@property (strong,nonatomic) NSString* senderId;
@property BOOL  isGroupMessage;
@property BOOL  isRead;

@end
