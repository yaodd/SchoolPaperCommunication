//
//  XXTContactPerson.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTContactPerson.h"

@implementation XXTContactPerson

- (XXTContactPerson*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.pid = [dict objectForKey:@"contactId"];
        self.name = [dict objectForKey:@"contactName"];
        self.avatar = [[XXTImage alloc] initWithDictionary:dict];
        self.type = [[dict objectForKey:@"contactType"] intValue];
        self.remark = [dict objectForKey:@"remarks"];
        self.phone = [dict objectForKey:@"phone"];
        self.dialReq = [dict objectForKey:@"dialReq"];
        self.messageEnable = [[dict objectForKey:@"messageEnable"] intValue];
        self.evaluateArr = [NSMutableArray array];
        self.lastUpdateTimeForEvaluateArr =[NSDate dateWithTimeIntervalSince1970:0];
    }
    return self;
}


/*
 @property (strong,nonatomic) NSString* remark; //备注
 @property (strong,nonatomic) NSString* phone;
 @property (strong,nonatomic) NSString* dialReq;
 @property NSInteger messageEnable;
 */
- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.remark forKey:@"remark"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.dialReq forKey:@"dialReq"];
    [aCoder encodeInteger:self.messageEnable forKey:@"msgEnable"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.dialReq = [aDecoder decodeObjectForKey:@"dialReq"];
        self.messageEnable = [aDecoder decodeIntegerForKey:@"msgEnable"];
    }
    return self;
}

@end
