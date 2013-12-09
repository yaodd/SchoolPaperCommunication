//
//  XXTGroup.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/3/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTGroup.h"

@implementation XXTGroup

- (XXTGroup*) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.groupId = [dict objectForKey:@"groupId"];
        self.groupName = [dict objectForKey:@"groupName"];
        self.groupType = [[dict objectForKey:@"groupType"] intValue];
        self.groupMemberArr = [NSMutableArray array];
        for (NSDictionary* contactDic in [dict objectForKey:@"items"]){
            XXTContactPerson* contact = [[XXTContactPerson alloc] initWithDictionary:contactDic];
            [self.groupMemberArr addObject:contact];
        }
    }
    return self;
}

@end
