//
//  BubbleView.h
//  WeixinDeom
//
//  Created by yaodd on 13-12-1.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVO.h"
@interface BubbleView : UIView

@property (nonatomic, retain) UILabel *bubbleText;
@property (nonatomic, retain) UIImageView *bubbleImageView;

- (id) initWithDefault;

- (void)setData:(MessageVO *)msg;
@end
