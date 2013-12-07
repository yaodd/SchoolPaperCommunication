//
//  XXTMessage.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageReceive.h"

@implementation XXTMessageReceive

- (XXTMessageReceive*) initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super initWithDictionary:dict]){
        self.msgId = [dict objectForKey:@"msgId"];
        self.senderId = [dict objectForKey:@"senderId"];
        self.isGroupMessage = [[dict objectForKey:@"isGroupSend"] intValue];
        
        
        self.isRead = FALSE;
    }
    return self;
}

@end
