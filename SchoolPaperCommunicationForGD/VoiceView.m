//
//  VoiceView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-1.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "VoiceView.h"

@implementation VoiceView

@synthesize button;
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
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return self;
}
- (void)setData:(MessageVO *)msg{
    message = msg;
    BOOL fromSelf;
    CGFloat position = 65;
    NSInteger longtime = msg.audioTime;
    if (msg.msgMode == kMsgMode_Receive) {
        fromSelf = NO;
    } else{
        fromSelf = YES;
    }
    int yuyinwidth = 66+fromSelf;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.tag = indexRow;
    CGRect frame;
    if(fromSelf)
		frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
	else
		frame =CGRectMake(position, 10, yuyinwidth, 54);
    button.frame = CGRectMake(0, 0, yuyinwidth, 54);
    self.frame = frame;
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d''",longtime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
}

- (void)buttonAction:(id)sender{
    NSURL *url = message.audioUrl;
    [self.delegate playAudio:url];
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
