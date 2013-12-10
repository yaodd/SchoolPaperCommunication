//
//  XXTMessageSend.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/3/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageSend.h"

@implementation XXTMessageSend

- (id) initWithGroupIds:(NSArray *)groupIds personIds:(NSArray *)personIds content:(NSString *)content images:(NSArray *)imagesArr audio:(NSArray *)audiosArr{
    if (self = [super initWithContent:content imageObjects:imagesArr audioObjects:audiosArr]){
        if (groupIds!=nil){
            self.sendToGroupIdArr = groupIds;
        }
        if (personIds!=nil){
            self.sendToPersonIdArr = personIds;
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.sendCount forKey:@"sendCount"];
    [aCoder encodeInteger:self.sendSuccessCount forKey:@"sendSucCount"];
    [aCoder encodeInteger:self.readCount forKey:@"readCount"];
    [aCoder encodeObject:self.sendToGroupIdArr forKey:@"send2GroupArr"];
    [aCoder encodeObject:self.sendToPersonIdArr forKey:@"send2PersonArr"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.sendCount = [aDecoder decodeIntegerForKey:@"sendCount"];
        self.sendSuccessCount=[aDecoder decodeIntegerForKey:@"sendSucCount"];
        self.readCount = [aDecoder decodeIntegerForKey:@"readCount"];
        self.sendToGroupIdArr = [aDecoder decodeObjectForKey:@"send2GroupArr"];
        self.sendToPersonIdArr= [aDecoder decodeObjectForKey:@"send2PersonArr"];
    }
    return self;
}

@end
