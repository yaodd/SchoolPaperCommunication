//
//  UIImageView+category.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "UIImageView+category.h"

@implementation UIImageView (category)
- (void)setImageWithPerson:(XXTPersonBase *)person{
//    self.myPerson = person;
    if (person.avatar.thumbPicImage == nil) {
        [self setImage:[UIImage imageNamed:@"photo"]];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImageWithUrl:) object:person];
        [thread start];
    }else{
        [self setImage:person.avatar.thumbPicImage];
    }
}
//下载图片
- (void)downloadImageWithUrl:(XXTPersonBase *)person{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:person.avatar.thumbPicURL]];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil) {
        person.avatar.thumbPicImage = image;
        [self performSelectorOnMainThread:@selector(updateImageView:) withObject:person waitUntilDone:YES];
    } else{
        NSLog(@"图片下载失败");
    }
    
}
//更新ImageView
- (void)updateImageView:(XXTPersonBase *)person{
    [self setImage:person.avatar.thumbPicImage];
}
@end
