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

@end
