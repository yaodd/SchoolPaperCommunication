//
//  XXTHomework.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTHomework.h"

@implementation XXTHomework

- (XXTHomework*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]){
        self.homeworkId = [dict objectForKey:@"homeworkId"];
        self.subject = [dict objectForKey:@"subject"];
        self.classId = [dict objectForKey:@"classId"];
        self.className = [dict objectForKey:@"className"];
        self.title = [dict objectForKey:@"title"];
        self.content = [dict objectForKey:@"content"];
        self.image = [[XXTImage alloc] initWithDictionary:dict];
        self.dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        self.finishTime = [NSDate dateFromString:[dict objectForKey:@"finishDateTime"]];
    }
    return self;
}

- (XXTHomework*) initNewHomeworkWithContent:(NSString *)content subjectId:(XXTSubjectType)subjectId classId:(int)classId image:(XXTImage *)image finishTime:(NSDate *)date
{
    if (self = [super init]){
        self.content = content;
        self.subjectId = [NSNumber numberWithInt:subjectId];
        self.classId = [NSNumber numberWithInt:classId];
        self.image = image;
        self.finishTime = date;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.homeworkId forKey:@"homeworkId"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeObject:self.subjectId forKey:@"subjectId"];
    [aCoder encodeObject:self.classId forKey:@"classId"];
    [aCoder encodeObject:self.className forKey:@"className"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeObject:self.finishTime forKey:@"finishTime"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.homeworkId = [aDecoder decodeObjectForKey:@"homeworkId"];
        self.subject    = [aDecoder decodeObjectForKey:@"subject"];
        self.subjectId  = [aDecoder decodeObjectForKey:@"subjectId"];
        self.classId    = [aDecoder decodeObjectForKey:@"classId"];
        self.className  = [aDecoder decodeObjectForKey:@"className"];
        self.title      = [aDecoder decodeObjectForKey:@"title"];
        self.content    = [aDecoder decodeObjectForKey:@"content"];
        self.image      = [aDecoder decodeObjectForKey:@"image"];
        self.dateTime   = [aDecoder decodeObjectForKey:@"dateTime"];
        self.finishTime = [aDecoder decodeObjectForKey:@"finishTime"];
    }
    return self;
}

@end
