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
- (void)setData:(XXTMessageBase *)msg{
    message = msg;
    BOOL fromSelf;
    CGFloat position = 65;
    XXTAudio *audio = (XXTAudio *)[msg.audios objectAtIndex:0];
    NSInteger longtime = audio.duration;
    if ([msg isKindOfClass:[XXTMessageReceive class]]) {
        fromSelf = NO;
    } else{
        fromSelf = YES;
    }
    int yuyinwidth = 120+fromSelf;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.tag = indexRow;
    CGRect frame;
    if(fromSelf)
        frame =CGRectMake(position, 10, yuyinwidth, 54);
	else
        frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);

    button.frame = CGRectMake(0, 0, yuyinwidth, 54);
    self.frame = frame;
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = 0;
    imageInsert.left = -button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"audio":@"audio"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"bubble_grey":@"bubble_blue"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width / 2 topCapHeight:backgroundImage.size.height / 2];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 30, button.frame.size.height)];
    UIColor *textColor = fromSelf?[UIColor colorWithWhite:30.0/255 alpha:1.0]:[UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%d''",longtime];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
}

- (void)buttonAction:(id)sender{
    XXTAudio *audio = (XXTAudio *)[message.audios objectAtIndex:0];
    [self.delegate playAudio:audio];
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
