//
//  XXTAudio.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTAudio.h"

@implementation XXTAudio

@synthesize audioURL,duration;

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        audioURL = [[dict objectForKey:@"url"] copy];
        duration = [[dict objectForKey:@"duration"] integerValue];
    }
    return self;
}

@end
