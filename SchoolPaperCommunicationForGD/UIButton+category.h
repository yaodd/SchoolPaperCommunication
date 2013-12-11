//
//  UIButton+category.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTMessageBase.h"

@interface UIButton (category)
- (void)setBackgroundImageWithMessage:(XXTMessageBase *)message forState:(UIControlState)state;

@end
