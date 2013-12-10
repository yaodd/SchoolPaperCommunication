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
        self.qImage.thumbPicURL = [dict objectForKey:@"thumb"];
        self.qImage.originPicURL =[dict objectForKey:@"original"];
        self.questionerName = [dict objectForKey:@"questioner"];
        self.questionerAvatar = [[XXTImage alloc] init];
        self.questionerAvatar.thumbPicURL = [dict objectForKey:@"avatarThumb"];
        self.qAudio = [[XXTAudio alloc] initWithDictionary:[dict objectForKey:@"audio"]];
        self.subjectName = [dict objectForKey:@"subject"];
        self.state = [[dict objectForKey:@"status"] intValue];
        NSDate *dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        self.dateTime = dateTime;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.qid forKey:@"qid"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.qImage forKey:@"qImage"];
    [aCoder encodeObject:self.qAudio forKey:@"qAudio"];
    [aCoder encodeObject:self.subjectName forKey:@"subjectName"];
    [aCoder encodeObject:self.subjectId forKey:@"subjectId"];
    [aCoder encodeInteger:self.state forKey:@"state"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeObject:self.questionerName forKey:@"qName"];
    [aCoder encodeObject:self.questionerAvatar forKey:@"qAvatar"];
    [aCoder encodeObject:self.answersArr forKey:@"answerArr"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.qid = [aDecoder decodeObjectForKey:@"qid"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.qImage=[aDecoder decodeObjectForKey:@"qImage"];
        self.qAudio=[aDecoder decodeObjectForKey:@"qAudio"];
        self.subjectName=[aDecoder decodeObjectForKey:@"subjectName"];
        self.subjectId = [aDecoder decodeObjectForKey:@"subjectId"];
        self.state = [aDecoder decodeIntegerForKey:@"state"];
        self.dateTime = [aDecoder decodeObjectForKey:@"dateTime"];
        self.questionerName=[aDecoder decodeObjectForKey:@"qName"];
        self.questionerAvatar=[aDecoder decodeObjectForKey:@"qAvatar"];
        self.answersArr=[aDecoder decodeObjectForKey:@"answerArr"];
    }
    return self;
}

@end
