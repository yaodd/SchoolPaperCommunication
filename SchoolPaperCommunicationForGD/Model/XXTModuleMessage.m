//
//  XXTModuleMessage.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/6/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTModuleMessage.h"

@implementation XXTModuleMessage

- (XXTModuleMessage*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.type = [dict objectForKey:@"type"];
        self.icon = [dict objectForKey:@"icon"];
        self.title = [dict objectForKey:@"title"];
        self.dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        self.content = [dict objectForKey:@"content"];
        self.count = [[dict objectForKey:@"count"] intValue];
    }
    return self;
}

@end
