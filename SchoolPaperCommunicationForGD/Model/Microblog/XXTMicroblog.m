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
        self.name = [dict objectForKey:@"name"];
    }
    return self;
}

- (XXTMicroblog*) initWithContent:(NSString *)content imageObjects:(NSArray *)imageObjects audioObjects:(NSArray *)audioObjects posterName:(NSString*) posterName
{
    if (self = [super initWithContent:content imageObjects:imageObjects audioObjects:audioObjects]){
        self.commentsArr = [NSMutableArray array];
        self.name = posterName;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.likeCount forKey:@"likeCount"];
    [aCoder encodeInteger:self.commentCount forKey:@"commentCount"];
    [aCoder encodeObject:self.commentsArr forKey:@"commentsArr"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.likeCount = [aDecoder decodeIntegerForKey:@"likeCount"];
        self.commentCount=[aDecoder decodeIntegerForKey:@"commentCount"];
        self.commentsArr=[aDecoder decodeObjectForKey:@"commentsArr"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
