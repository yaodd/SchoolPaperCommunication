//
//  XXTMessageBase.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

@implementation XXTMessageBase

- (id) initWithContent:(NSString *)content images:(NSArray *)imagesArr audio:(NSArray *)audiosArr{
    if (self = [super init]){
        if (content!= nil)
            self.content = content;
        if (imagesArr!=nil)
            self.images = imagesArr;
        if (audiosArr!=nil)
            self.audios = audiosArr;
    }
    return self;
}

@end
