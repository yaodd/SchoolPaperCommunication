//
//  XXTAlertView.m
//  SchoolPaperCommunicationForGD
//
//  用UIView模仿系统自带UIAlertView
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "XXTAlertView.h"
#define VIEW_X          52
#define VIEW_Y          161
#define VIEW_WIDTH      216
#define VIEW_HEIGHT_SMALL   125
#define VIEW_HEIGHT_MIDDLE  140
#define VIEW_HEIGHT_LARGE   162
//#define SMALL_FRAME     CGRectMake(52, 161, 216, 125)
//#define LARGE_FRAME     CGRectMake(52, 161, 216, 162)
//#define MIDDLE_FRAME    CGRectMake(52, 161, 216, 140)
//#define IMAGE_FRAME     CGRectMake(85, 25, 46, 37)
#define IMAGE_X         85
#define IMAGE_WIDTH     46
#define IMAGE_HEIGHT    37
//#define LABEL_FRAME     CGRectMake(10, 76, 196, 30)
#define LABEL_X         10
#define LABEL_WIDTH     196
#define LABEL_HEIGHT    30
//#define LARGE_BUTTON_FRAME      CGRectMake(11, 105, 192, 44)
#define LARGE_BUTTON_X      11
#define LARGE_BUTTON_WIDTH  192
#define LAGER_BUTTON_HEIGHT 44
//#define LEFT_BUTTON_FRAME       CGRectMake(0, 162 - 44, 216 / 2, 44)
#define LEFT_BUTTON_X       0
#define LEFT_BUTTON_WIDTH   216/2
#define LEFT_BUTTON_HEIGHT  44
//#define RIGHT_BUTTON_FRAME      CGRectMake(216 / 2, 162 - 44, 216 / 2, 44)
#define RIGHT_BUTTON_X      216/2
#define RIGHT_BUTTON_WIDTH  216/2
#define RIGHT_BUTTON_HEIGHT 44
#define BLUR_VIEW_FRAME         CGRectMake(0, 0, 320, 568)
@implementation XXTAlertView
@synthesize blurView;
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}
//初始化
-(id)initWithTitle:(NSString *)title XXTAlertViewType:(XXTAlertViewType)kXXTAlertViewType otherButtonTitles:(NSString *)otherButtonTitles, ...{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    va_list args;
    va_start(args, otherButtonTitles);
    
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args, NSString *)) {
        [buttons addObject:str];
    }
    va_end(args);
    CGRect frame;
    if ([buttons count] == 0) {
        frame = CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT_SMALL);
    } else{
        frame = CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT_LARGE);
    }
    if (kXXTAlertViewType == kXXTAlertViewTypeNoImage) {
        frame = CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT_MIDDLE);
    }
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:5.0f];
        UIImage *image;
        if (kXXTAlertViewType == kXXTAlertViewTypeSucceed) {
            image = [UIImage imageNamed:@"succeed"];
        } else if (kXXTAlertViewType == kXXTAlertViewTypeFailed){
            
        } else if (kXXTAlertViewType == kXXTAlertViewTypeQuestion){
            
        }
        CGFloat viewTopY =  0;

        if (kXXTAlertViewType != kXXTAlertViewTypeNoImage) {
            viewTopY += 25;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(IMAGE_X, viewTopY, IMAGE_WIDTH, IMAGE_HEIGHT)];
            [imageView setImage:image];
            [self addSubview:imageView];
            viewTopY += 51;
        } else{
            viewTopY += 38;
        }
        
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_X, viewTopY, LABEL_WIDTH, LABEL_HEIGHT)];
        [label setText:title];
        [label setTextColor:[UIColor blackColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:label];
        
        if ([buttons count] == 1) {
            viewTopY += 29;
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(LARGE_BUTTON_X, viewTopY, LARGE_BUTTON_WIDTH, LAGER_BUTTON_HEIGHT)];
            [button setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [button setTag:0];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
            [self addSubview:button];
        } else if ([buttons count] == 2){
            CGFloat Y = frame.size.height - 44;
            UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(LEFT_BUTTON_X, Y, LEFT_BUTTON_WIDTH, LEFT_BUTTON_HEIGHT)];
            [leftButton setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1.0] forState:UIControlStateNormal];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"buttonleft"] forState:UIControlStateNormal];
            [leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [leftButton setTag:0];
            [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:leftButton];
            
            UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(RIGHT_BUTTON_X, Y, RIGHT_BUTTON_WIDTH, RIGHT_BUTTON_HEIGHT)];
            [rightButton setTitle:[buttons objectAtIndex:1] forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"buttonright"] forState:UIControlStateNormal];
            [rightButton setTag:1];
            [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightButton];
        }
        blurView = [[UIView alloc]initWithFrame:BLUR_VIEW_FRAME];
        [blurView setBackgroundColor:[UIColor blackColor]];
        blurView.alpha = 0.0;
        self.alpha = 0.0;
        
    }
    
    
    
    return self;
}
//show，包括显示alertView和添加半透明黑色背景
- (void)show {
    [self.superview insertSubview:blurView belowSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        blurView.alpha = 0.5;
        self.alpha = 1.0;
    } completion:^(BOOL finish){
    
    }];
}
//dismiss,将
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        blurView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finish){
        [blurView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self.delegate XXTAlertViewButtonAction:self button:button];
    
    [self dismiss];
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
