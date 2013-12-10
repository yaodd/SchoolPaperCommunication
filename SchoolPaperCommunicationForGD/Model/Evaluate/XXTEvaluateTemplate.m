//
//  XXTEvaluateTemplate.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTEvaluateTemplate.h"

@implementation XXTEvaluateTemplate

- (XXTEvaluateTemplate*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]){
        self.type = [[dict objectForKey:@"type"] intValue];
        self.content=[dict objectForKey:@"content"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeInteger:self.type forKey:@"type"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
    }
    return self;
}
@end
