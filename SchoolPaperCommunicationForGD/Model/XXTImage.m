//
//  XXTImage.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTImage.h"

@implementation XXTImage

@synthesize originPicURL,thumbPicURL;

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]){
        originPicURL = [[dict objectForKey:@"original"] copy];
        thumbPicURL = [[dict objectForKey:@"thumb"] copy];
    }
    return self;
}

@end
