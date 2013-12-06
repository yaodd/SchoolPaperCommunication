//
//  XXTContactPerson.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTContactPerson.h"

@implementation XXTContactPerson

- (XXTContactPerson*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.pid = [dict objectForKey:@"contactId"];
        self.name = [dict objectForKey:@"contactName"];
        self.avatar = [[XXTImage alloc] initWithDictionary:dict];
        self.type = [[dict objectForKey:@"contactType"] intValue];
        self.remark = [dict objectForKey:@"remarks"];
        self.phone = [dict objectForKey:@"phone"];
        self.dialReq = [dict objectForKey:@"dialReq"];
        self.messageEnable = [[dict objectForKey:@"messageEnable"] intValue];
    }
    return self;
}

@end
