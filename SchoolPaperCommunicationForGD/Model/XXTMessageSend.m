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

@end
