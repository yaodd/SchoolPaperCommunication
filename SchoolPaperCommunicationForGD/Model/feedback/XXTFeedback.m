//
//  XXTFeedback.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTFeedback.h"

@implementation XXTFeedback

- (XXTFeedback*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.fid = [dict objectForKey:@"id"];
        self.content = [dict objectForKey:@"content"];
        NSDate* dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        self.dateTime = dateTime;
        self.answer = [dict objectForKey:@"answer"];
        self.answerTime = [NSDate dateFromString:[dict objectForKey:@"answerTime"]];
    }
    return self;
}

@end
