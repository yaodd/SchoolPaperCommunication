//
//  XXTBulletin.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/7/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTBulletin.h"

@implementation XXTBulletin

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]){
        self.bid = [dict objectForKey:@"id"];
        self.senderId = [dict objectForKey:@"senderId"];
        self.senderName=[dict objectForKey:@"senderName"];
        self.title    = [dict objectForKey:@"title"];
        self.content  = [dict objectForKey:@"content"];
        self.image    = [[XXTImage alloc] initWithDictionary:dict];
        self.startDate= [NSDate dateFromString:[dict objectForKey:@"startDate"]];
        self.endDate  = [NSDate dateFromString:[dict objectForKey:@"endDate"]];
        self.dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        self.type     = [[dict objectForKey:@"type"] intValue];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.bid forKey:@"bid"];
    [aCoder encodeObject:self.senderId forKey:@"senderId"];
    [aCoder encodeObject:self.senderName forKey:@"senderName"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.classId forKey:@"classId"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.bid = [aDecoder decodeObjectForKey:@"bid"];
        self.senderId = [aDecoder decodeObjectForKey:@"senderId"];
        self.senderName=[aDecoder decodeObjectForKey:@"senderName"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.image  =[aDecoder decodeObjectForKey:@"image"];
        self.startDate=[aDecoder decodeObjectForKey:@"startDate"];
        self.endDate  =[aDecoder decodeObjectForKey:@"endDate"];
        self.dateTime =[aDecoder decodeObjectForKey:@"dateTime"];
        self.type     =[aDecoder decodeIntegerForKey:@"type"];
        self.schoolId =[aDecoder decodeObjectForKey:@"schoolId"];
        self.classId =[aDecoder decodeObjectForKey:@"classId"];
    }
    return self;
}

- (XXTBulletin*) initNewBulletinWithSchoolId:(NSNumber *)schoolId
                                   startDate:(NSDate *)startDate
                                     endDate:(NSDate *)endDate
                                   teacherId:(NSNumber *)teacherId
                                     classId:(NSNumber *)classId
                                       title:(NSString *)title
                                     content:(NSString *)content
{
    if (self = [super init]){
        self.schoolId = schoolId;
        self.startDate = startDate;
        self.endDate = endDate;
        self.senderId = [teacherId stringValue];
        self.classId = classId;
        self.title = title;
        self.content = content;
    }
    return self;
}

@end
