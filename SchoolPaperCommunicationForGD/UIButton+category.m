//
//  UIButton+category.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "UIButton+category.h"

@implementation UIButton (category)

- (void)setBackgroundImageWithMessage:(XXTMessageBase *)message forState:(UIControlState)state{
    
    XXTImage *image = [message.images objectAtIndex:0];
    if (image.thumbPicImage != nil) {
        [self setBackgroundImage:image.thumbPicImage forState:state];
    } else{
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:message,@"message",[NSNumber numberWithInt:state],@"state", nil];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImageWithUrl:) object:dict];
        [thread start];
    }
}

- (void)downloadImageWithUrl:(NSDictionary *)dict{
    XXTMessageBase *message = [dict objectForKey:@"message"];
    UIControlState state = [(NSNumber *)[dict objectForKey:@"state"] integerValue];
    XXTImage *xxtImage = [message.images objectAtIndex:0];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:xxtImage.thumbPicURL]];
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil) {
        xxtImage.thumbPicImage = image;
    }else{
        NSLog(@"图片下载失败;");
    }
    NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:message,@"message",[NSNumber numberWithInt:state],@"state", nil];
    [self performSelectorOnMainThread:@selector(updateButtonImage:) withObject:myDict waitUntilDone:YES];
}
- (void)updateButtonImage:(NSDictionary *)dict{
    XXTMessageBase *message = [dict objectForKey:@"message"];
    UIControlState state = [(NSNumber *)[dict objectForKey:@"state"] integerValue];
    XXTImage *xxtImage = [message.images objectAtIndex:0];
    [self setImage:xxtImage.thumbPicImage forState:state];
}
@end
