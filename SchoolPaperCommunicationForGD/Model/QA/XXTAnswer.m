//
//  XXTAnswer.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTAnswer.h"

@implementation XXTAnswer

- (XXTAnswer*) initWithDicitionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.aid = [dict objectForKey:@"id"];
        self.content = [dict objectForKey:@"content"];
        self.aImage = [[XXTImage alloc] init];
        self.aImage.originPicURL = [dict objectForKey:@"original"];
        self.aImage.thumbPicURL = [dict objectForKey:@"thumb"];
        self.answererAvatar = [[XXTImage alloc] init];
        self.answererAvatar.thumbPicURL = [dict objectForKey:@"avatarThumb"];
        self.answererName = [dict objectForKey:@"answerer"];
        NSMutableArray* audios = [NSMutableArray array];
        for (NSMutableDictionary* audioDic in [dict objectForKey:@"audio"]){
            XXTAudio *audio = [[XXTAudio alloc] initWithDictionary:audioDic];
            [audios addObject:audio];
        }
        self.aAudios = audios;
        self.dateTime= [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
    }
    return self;
}

- (XXTAnswer*) initNewAnswer:(NSString *)content image:(XXTImage *)image audio:(XXTAudio *)audio
{
    if (self = [super init]){
        self.content = content;
        self.aImage = image;
        self.aAudios = [NSArray arrayWithObjects:audio, nil];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.aid forKey:@"id"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.aImage forKey:@"image"];
    [aCoder encodeObject:self.answererAvatar forKey:@"avatar"];
    [aCoder encodeObject:self.answererName forKey:@"name"];
    [aCoder encodeObject:self.aAudios forKey:@"audios"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.aid = [aDecoder decodeObjectForKey:@"id"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.aImage=[aDecoder decodeObjectForKey:@"image"];
        self.answererAvatar=[aDecoder decodeObjectForKey:@"avatar"];
        self.answererName = [aDecoder decodeObjectForKey:@"name"];
        self.aAudios = [aDecoder decodeObjectForKey:@"audios"];
        self.dateTime= [aDecoder decodeObjectForKey:@"dateTime"];
    }
    return self;
}

@end
