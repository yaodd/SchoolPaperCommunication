//
//  XXTMessage.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageReceive.h"

@implementation XXTMessageReceive

- (XXTMessageReceive*) initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]){
        self.msgId = [dict objectForKey:@"msgId"];
        self.senderId = [dict objectForKey:@"senderId"];
        self.content = [dict objectForKey:@"content"];
        self.isGroupMessage = [[dict objectForKey:@"isGroupSend"] intValue];
        NSMutableArray* imageArr = [NSMutableArray array];
        NSArray* imageDicArr = [dict objectForKey:@"images"];
        for (NSDictionary* imageDic in imageDicArr){
            [imageArr addObject:[[XXTImage alloc] initWithDictionary:imageDic]];
        }
        self.images = imageArr;
        NSArray* audioDicArr = [dict objectForKey:@"audios"];
        NSMutableArray* audioArr = [NSMutableArray array];
        for (NSDictionary* audioDic in audioDicArr){
            [audioArr addObject:[[XXTAudio alloc] initWithDictionary:audioDic]];
        }
        self.audios = audioArr;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.sendTime = [formatter dateFromString:[dict objectForKey:@"dateTime"]];
        
        self.isRead = FALSE;
    }
    return self;
}

@end
