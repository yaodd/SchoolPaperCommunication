//
//  XXTAudio.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTAudio.h"

@implementation XXTAudio

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        self.audioURL = [dict objectForKey:@"url"];
        self.duration = [[dict objectForKey:@"duration"] integerValue];
    }
    return self;
}

@end
