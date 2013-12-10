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

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.originPicURL forKey:@"originURL"];
    [aCoder encodeObject:self.thumbPicURL forKey:@"thumbURL"];
    [aCoder encodeObject:self.originPicImage forKey:@"originPic"];
    [aCoder encodeObject:self.thumbPicImage forKey:@"thumbPic"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.originPicURL = [aDecoder decodeObjectForKey:@"originURL"];
        self.thumbPicURL  = [aDecoder decodeObjectForKey:@"thumbURL"];
        self.originPicImage =[aDecoder decodeObjectForKey:@"originPic"];
        self.thumbPicImage =[aDecoder decodeObjectForKey:@"thumbPic"];
    }
    return self;
}

@end
