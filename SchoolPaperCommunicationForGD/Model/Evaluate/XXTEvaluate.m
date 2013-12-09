//
//  XXTEvaluate.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTEvaluate.h"
#import "XXTModelGlobal.h"

@implementation XXTEvaluatedPerson

- (XXTEvaluatedPerson*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.pid = [dict objectForKey:@"id"];
        self.name= [dict objectForKey:@"name"];
        self.avatar = [[XXTImage alloc] initWithDictionary:dict];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.pid forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.pid = [aDecoder decodeObjectForKey:@"id"];
        self.name= [aDecoder decodeObjectForKey:@"name"];
        self.avatar=[aDecoder decodeObjectForKey:@"avatar"];
    }
    return self;
}

@end

@implementation XXTEvaluate

- (XXTEvaluate*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.eid = [dict objectForKey:@"id"];
        self.avatar = [[XXTImage alloc] initWithDictionary:dict];
        self.name = [dict objectForKey:@"name"];
        self.type = [[dict objectForKey:@"type"] intValue];
        self.icon = [[XXTImage alloc] init];
        self.icon.originPicURL = [dict objectForKey:@"icon"];
        self.content = [dict objectForKey:@"content"];
        self.dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
    }
    
    return self;
}

- (XXTEvaluate*) initNewEvaluateWithIds:(NSArray *)studentIds
                                content:(NSString *)content
                                   rank:(int)rank
{
    if (self = [super init]){
        XXTUserRole* currentUser =[XXTModelGlobal sharedModel].currentUser;
        NSMutableArray* evaluatedPersonArr = [NSMutableArray array];
        for (NSString* studentId in studentIds){
            XXTEvaluatedPerson *person = [[XXTEvaluatedPerson alloc] init];
            XXTPersonBase* personbase = [currentUser getPersonObjectById:studentId];
            person.pid = personbase.pid;
            person.name = personbase.name;
            person.avatar = personbase.avatar;
            [evaluatedPersonArr addObject:person];
        }
        self.evaluatedPersonArr = evaluatedPersonArr;
        self.content = content;
        self.rank = rank;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.eid forKey:@"id"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeInteger:self.rank forKey:@"rank"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.eid = [aDecoder decodeObjectForKey:@"id"];
        self.avatar=[aDecoder decodeObjectForKey:@"avatar"];
        self.name  =[aDecoder decodeObjectForKey:@"name"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.dateTime=[aDecoder decodeObjectForKey:@"dateTime"];
        self.rank = [aDecoder decodeIntegerForKey:@"rank"];
    }
    return self;
}

@end
