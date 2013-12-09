//
//  XXTQuestion.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTQuestion.h"

@implementation XXTQuestion

- (XXTQuestion*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]){
        self.qid = [dict objectForKey:@"id"];
        self.content = [dict objectForKey:@"content"];
        self.qImage = [[XXTImage alloc] init];
        //TODO FIXME 
    }
    return self;
}

@end
