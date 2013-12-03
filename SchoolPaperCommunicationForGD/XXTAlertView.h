//
//  XXTAlertView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXTAlertView : UIView

- (id)initWithTitle:(NSString *)title : (NSArray *)buttons :(BOOL)isSuccess;
// 显示
- (void)show;
// 消失
- (void)dismiss;
@end
