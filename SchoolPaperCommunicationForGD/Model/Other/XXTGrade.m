//
//  XXTGrade.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/10/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTGrade.h"

@implementation XXTGrade

- (XXTGrade*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.gid = [dict objectForKey:@"id"];
        self.name =[dict objectForKey:@"name"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.gid forKey:@"gid"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self  = [super init]){
        self.gid = [aDecoder decodeObjectForKey:@"id"];
        self.name =[aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
