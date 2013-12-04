//
//  XXTAlertView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XXTAlertViewType) {
    kXXTAlertViewTypeSucceed,
    kXXTAlertViewTypeFailed,
    kXXTAlertViewTypeQuestion,
    kXXTAlertViewTypeNoImage
};

@class XXTAlertView;
@protocol XXTAlertViewDelegate <NSObject>

@optional
- (void)XXTAlertViewButtonAction:(XXTAlertView *)alertView  button:(UIButton *)button;

@end

@interface XXTAlertView : UIView

@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, assign) id<XXTAlertViewDelegate> delegate;
@property (nonatomic, assign) XXTAlertViewType type;

- (id)initWithTitle:(NSString *)title  XXTAlertViewType:(XXTAlertViewType)kXXTAlertViewType otherButtonTitles:(NSString *) otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION;
// 显示
- (void)show;
// 消失
- (void)dismiss;
@end
