//
//  XXTMessageTemplate.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageTemplate.h"

@implementation XXTMessageTemplate

- (XXTMessageTemplate*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]){
        self.msgId = [dict objectForKey:@"id"];
        self.type  = [[dict objectForKey:@"type"] intValue];
    }
    return self;
}

@end
