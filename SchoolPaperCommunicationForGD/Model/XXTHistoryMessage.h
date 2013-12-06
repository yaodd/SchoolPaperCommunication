//
//  XXTHistoryMessage.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

typedef enum{
    XXTHistoryTypeDefault   = 1,
    XXTHistoryTypeOAMessage = 2
} XXTHistoryType;

@interface XXTHistoryMessage : XXTMessageBase

@property (strong,nonatomic) NSMutableArray *receiverNames;

@property (nonatomic) NSInteger sendCount;
@property (nonatomic) NSInteger sendSuccessCount;
@property (nonatomic) NSInteger readCount;

- (XXTHistoryMessage*) initWithDictionary:(NSDictionary *)dict;
- (void) receivedGroupStateDictionary:(NSDictionary*) stateDic;
- (void) receivedReceiverNamesArray:(NSArray*) namesArr;

@end
