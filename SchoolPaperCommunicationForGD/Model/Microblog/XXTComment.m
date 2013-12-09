//
//  XXTComment.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/4/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTComment.h"
#import "XXTModelGlobal.h"

@implementation XXTComment

- (id) initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]){
        self.senderName = [dict objectForKey:@"name"];
        self.content = [dict objectForKey:@"content"];
        self.avatar = [[XXTImage alloc] init];
        self.avatar.thumbPicURL = [dict objectForKey:@"avatarThumb"];
        
        self.dateTime = [NSDate dateFromString:[dict objectForKey:@"dateTime"]];
        
        if ([dict objectForKey:@"type"]!=nil){
            self.type = [[dict objectForKey:@"type"] intValue];
        }
        else{
            self.type = 1;
        }
    }
    return self;
}

- (XXTComment*) initWithContent:(NSString *)content
{
    if (self = [super init]){
        self.senderName = [XXTModelGlobal sharedModel].currentUser.name;
        self.dateTime   = [NSDate date];
        self.avatar = [XXTModelGlobal sharedModel].currentUser.avatar;
        self.content = content;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.senderName forKey:@"senderName"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeInteger:self.type forKey:@"type"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.senderName = [aDecoder decodeObjectForKey:@"senderName"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.dateTime=[aDecoder decodeObjectForKey:@"dateTime"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}

@end
