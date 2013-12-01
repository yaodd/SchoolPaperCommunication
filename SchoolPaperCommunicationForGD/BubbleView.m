//
//  BubbleView.m
//  WeixinDeom
//
//  Created by yaodd on 13-12-1.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import "BubbleView.h"

@implementation BubbleView
@synthesize bubbleImageView;
@synthesize bubbleText;
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
    bubbleText = [[UILabel alloc] initWithFrame:CGRectZero];
    bubbleImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:bubbleImageView];
    [self addSubview:bubbleText];
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
    //计算大小
    NSString *text = msg.strText;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(180.0f, 20000.0f) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
//    CGSize size = rect.size;
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
        [bubbleImageView setImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
//    NSLog(@"%f,%f",size.width,size.height);
    
    
    //添加文本信息
    bubbleText.frame = CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10);
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    CGRect frame;
    
    if(fromSelf)
        frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
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
