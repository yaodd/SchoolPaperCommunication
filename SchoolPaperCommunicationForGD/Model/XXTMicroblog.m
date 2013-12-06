//
//  XXTMicroblog.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMicroblog.h"

@implementation XXTMicroblog

- (id) initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]){
        self.msgId = [dict objectForKey:@"id"];
        self.likeCount = [[dict objectForKey:@"goodCount"] intValue];
        self.commentCount = [[dict objectForKey:@"commentCount"] intValue];
        self.commentsArr = [NSMutableArray array];
        for (NSDictionary* commentDic in [dict objectForKey:@"comments"]){
            [self.commentsArr addObject:[[XXTComment alloc] initWithDictionary:commentDic]];
        }
    }
    return self;
}

- (XXTMicroblog*) initWithContent:(NSString *)content imageObjects:(NSArray *)imageObjects audioObjects:(NSArray *)audioObjects
{
    if (self = [super initWithContent:content imageObjects:imageObjects audioObjects:audioObjects]){
        self.commentsArr = [NSMutableArray array];
    }
    return self;
}

@end
