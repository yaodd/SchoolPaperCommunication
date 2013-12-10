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

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.type forKey:@"moduleType"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeInteger:self.count forKey:@"count"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.type    = [aDecoder decodeObjectForKey:@"moduleType"];
        self.icon    = [aDecoder decodeObjectForKey:@"icon"];
        self.title   = [aDecoder decodeObjectForKey:@"title"];
        self.dateTime= [aDecoder decodeObjectForKey:@"dateTime"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.count   = [aDecoder decodeIntegerForKey:@"count"];
    }
    return self;
}

@end
