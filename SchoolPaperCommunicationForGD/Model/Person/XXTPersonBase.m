//
//  XXTPerson.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTPersonBase.h"

@implementation XXTPersonBase

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.pid forKey:@"personId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.evaluateArr forKey:@"evaluateArr"];
    [aCoder encodeObject:self.lastUpdateTimeForEvaluateArr forKey:@"lastUpdateTimeForEvaluateArr"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.pid = [aDecoder decodeObjectForKey:@"personId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.avatar=[aDecoder decodeObjectForKey:@"avatar"];
        self.evaluateArr=[aDecoder decodeObjectForKey:@"evaluateArr"];
        self.lastUpdateTimeForEvaluateArr = [aDecoder decodeObjectForKey:@"lastUpdateTimeForEvaluateArr"];
    }
    return self;
}

@end
