//
//  TemplateView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateHolder.h"
#define LABEL_X         10
#define LABEL_Y         15
#define LABEL_WIDTH     230
#define BUTTON_WIDTH    70
#define BUTTON_X        250
#define LABEL_FONT      [UIFont systemFontOfSize:15]
#define TEMPLATE_VIEW_HEIGHT_DEFAULT    64

@class TemplateView;
@protocol TemplateViewDelegate <NSObject>

@optional
- (void)templateView:(TemplateView *)templateView withHolder:(TemplateHolder *)holder;
@end

@interface TemplateView : UIView
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UIButton *expandButton;
@property (nonatomic, retain) TemplateHolder *holder;
@property (nonatomic, assign) id <TemplateViewDelegate> delegate;
- (void)setDataWithTemplateHolder:(TemplateHolder *)templateHolder;

@end
