//
//  XXTImage.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTImage.h"

@implementation XXTImage

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        if ([dict objectForKey:@"original"]!=nil)
            self.originPicURL = [dict objectForKey:@"original"];
        if ([dict objectForKey:@"avatar"]!=nil)
            self.originPicURL = [dict objectForKey:@"avatar"];
        if ([dict objectForKey:@"thumb"]!=nil)
            self.thumbPicURL = [dict objectForKey:@"thumb"] ;
        if ([dict objectForKey:@"avatarThumb"]!=nil)
            self.thumbPicURL = [dict objectForKey:@"avatarThumb"] ;
    }
    return self;
}

@end
