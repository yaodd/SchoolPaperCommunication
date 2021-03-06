//
//  XXTMessageBase.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

@implementation XXTMessageBase

- (id) initWithContent:(NSString*) content imageObjects:(NSArray*) imagesArr audioObjects:(NSArray*) audiosArr
{
    if (self = [super init]){
        self.content = content;
        self.images = imagesArr;
        self.audios = audiosArr;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]){
        self.content = [dict objectForKey:@"content"];

        if ([dict objectForKey:@"images"] != nil){
            NSMutableArray* imageArr = [NSMutableArray array];
            NSArray* imageDicArr = [dict objectForKey:@"images"];
            for (NSDictionary* imageDic in imageDicArr){
                [imageArr addObject:[[XXTImage alloc] initWithDictionary:imageDic]];
            }
            self.images = imageArr;
        }

        if ([dict objectForKey:@"audios"] != nil){
            NSArray* audioDicArr = [dict objectForKey:@"audios"];
            NSMutableArray* audioArr = [NSMutableArray array];
            for (NSDictionary* audioDic in audioDicArr){
                [audioArr addObject:[[XXTAudio alloc] initWithDictionary:audioDic]];
            }
            self.audios = audioArr;
        }
        
        if ([dict objectForKey:@"dateTime"]!=nil){
            self.dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.msgId forKey:@"id"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.images forKey:@"images"];
    [aCoder encodeObject:self.audios forKey:@"audios"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.msgId = [aDecoder decodeObjectForKey:@"id"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.images =[aDecoder decodeObjectForKey:@"images"];
        self.audios =[aDecoder decodeObjectForKey:@"audios"];
        self.dateTime=[aDecoder decodeObjectForKey:@"dateTime"];
    }
    return self;
}

@end
