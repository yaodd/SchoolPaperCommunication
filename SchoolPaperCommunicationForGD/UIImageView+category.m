//
//  UIImageView+category.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "UIImageView+category.h"

@implementation UIImageView (category)
- (void)setImageWithXXTImage:(XXTImage *)xxtImage{
//    self.myPerson = person;
    if (xxtImage.thumbPicImage == nil) {
        [self setImage:[UIImage imageNamed:@"photo"]];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImageWithUrl:) object:xxtImage];
        [thread start];
    }else{
        [self setImage:xxtImage.thumbPicImage];
    }
}
//下载图片
- (void)downloadImageWithUrl:(XXTImage *)xxtImage{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:xxtImage.thumbPicURL]];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil) {
        xxtImage.thumbPicImage = image;
        [self setImageWithXXTImage:xxtImage];
    } else{
        NSLog(@"图片下载失败");
    }
    
}
@end
