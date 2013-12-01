//
//  ImageView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-1.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVO.h"

@interface ImageView : UIView
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIImageView *bubbleImageView;
@property (nonatomic, retain) MessageVO *message;
- (id) initWithDefault;
- (void) setData:(MessageVO *)msg;
@end
