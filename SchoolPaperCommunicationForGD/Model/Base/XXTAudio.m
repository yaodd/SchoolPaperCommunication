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

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.audioURL forKey:@"URL"];
    [aCoder encodeObject:self.audiodata forKey:@"data"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.duration = [aDecoder decodeIntegerForKey:@"duration"];
        self.audioURL = [aDecoder decodeObjectForKey:@"URL"];
        self.audiodata= [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}

@end
