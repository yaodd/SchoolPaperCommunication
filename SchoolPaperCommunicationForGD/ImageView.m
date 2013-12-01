//
//  ImageView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-1.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView
@synthesize button;
@synthesize bubbleImageView;
@synthesize message;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDefault{
    self = [super initWithFrame:CGRectZero];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    bubbleImageView = [[UIImageView alloc]init];
    [self addSubview:bubbleImageView];
    [self addSubview:button];
    return self;
}
- (void) setData:(MessageVO *)msg{
    BOOL fromSelf;
    if (msg.msgMode == kMsgMode_Receive) {
        fromSelf = NO;
    }else{
        fromSelf = YES;
    }
    CGFloat position = 65;
    CGFloat width = 150;
        //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    [bubbleImageView setImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
    //    NSLog(@"%f,%f",size.width,size.height);
    
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, width+30.0f, width+20.0f);
    CGRect frame;
    [button setBackgroundImage:msg.image forState:UIControlStateNormal];
    if(fromSelf)
    {
        frame = CGRectMake(320-position-(width+30.0f), 0.0f, width+30.0f, width+30.0f);
        button.frame = CGRectMake(10, 20, width, width);
    }
    else{
        frame = CGRectMake(position, 0.0f, width+30.0f, width+30.0f);
        button.frame = CGRectMake(20, 20, width, width);

    }
    self.frame = frame;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
