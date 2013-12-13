//
//  PopMenuView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-14.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "PopMenuView.h"

#define BUTTON_WIDTH     30
#define BUTTON_HEIGHT     30
#define BUTTON_INIT_FRAME    CGRectMake(VIEW_WIDTH - 30, VIEW_HEIGHT- 30, BUTTON_WIDTH, BUTTON_HEIGHT)
@interface PopMenuView()
{
    CGRect buttonInitFrame;
    UIView *blurView;
}
@end
@implementation PopMenuView
@synthesize buttonArr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonInitFrame = CGRectMake(self.frame.size.width - 10 - BUTTON_WIDTH, self.frame.size.height - 10 - 49 - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
        UIButton *popButton = [[UIButton alloc]initWithFrame:buttonInitFrame];
        [popButton setImage:[UIImage imageNamed:@"yuwen"] forState:UIControlStateNormal];
        [popButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:popButton];
        
        NSArray *titleArr = [NSArray arrayWithObjects:@"发动态",@"发点评",@"发通知",@"发作业",@"群发短信", nil];
        buttonArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 5 ; i ++) {
            UIButton *button = [[UIButton alloc]initWithFrame:buttonInitFrame];
            [button setImage:[UIImage imageNamed:@"shuxue"] forState:UIControlStateNormal];
            [button setTag:i];
            [button setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setAlpha:0];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttonArr addObject:button];
        }
        [self setHidden:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return self;
}
- (void)buttonAction:(UIButton *)button{
    [self hidePopMenu];
    [self.delegate PopMenuViewClickAction:self withButton:button];
}
- (void)popAction:(id)sender{
    [self hidePopMenu];
}
- (void)showPopMenu
{
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blurViewGestureSelector:)];
    [self addGestureRecognizer:tapGesture];
    UIView *parentView = [self superview];
    blurView = [[UIView alloc]initWithFrame:parentView.bounds];
    [blurView setAlpha:0];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [parentView insertSubview:blurView belowSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        [blurView setAlpha:0.2];
    } completion:^(BOOL finished){
        
        
    }];
    [self setHidden:NO];
    int dx[5] = {-20,-40,-50,-40,-20};
    
    for (int i = 0; i < [buttonArr count]; i++) {
        UIButton *button = [buttonArr objectAtIndex:i];
        CGRect frame = button.frame;
        int index = i + 1;

        frame.origin.x += dx[i];
        frame.origin.y -= index * 40;
        [UIView animateWithDuration:0.3 delay:i * 0.05 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            button.frame = frame;
        } completion:^(BOOL finished){
            CGRect frame = button.frame;
            frame.origin.x -= 100;
            frame.size.width += 100;
            UIEdgeInsets imageEdgeInsets = button.imageEdgeInsets;
            imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets.top, imageEdgeInsets.left + 100, imageEdgeInsets.bottom, imageEdgeInsets.right);
            [button setImageEdgeInsets:imageEdgeInsets];
            UIEdgeInsets titleEdgeInsets = button.titleEdgeInsets;
            titleEdgeInsets.right += 30;
            [button setTitleEdgeInsets:titleEdgeInsets];
//            [button setTitle:@"撒大声地" forState:UIControlStateNormal];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.frame = frame;
                [button.titleLabel setAlpha:1.0];
//                [button setTitle:@"撒大声地" forState:UIControlStateNormal];
            } completion:^(BOOL finished){
                
            }];
        }];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //角度转弧度
//        rotationAnimation.beginTime = i * 0.05;
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rotationAnimation.duration = 0.2f;
        rotationAnimation.repeatCount = 2;
        //动画开始结束的快慢，设置为加速
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [button.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
        
        /*[UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
            button.transform = CGAffineTransformRotate(button.transform,-1 * M_PI);
        
        } completion:^(BOOL finished){
        }];
        */
    }
}
- (void)hidePopMenu{
    [self setUserInteractionEnabled:NO];
    for (int i = 0;  i < [buttonArr count]; i ++) {
        UIButton *button = [buttonArr objectAtIndex:i];
        CGRect frame = button.frame;
        frame.origin.x += 100;
        frame.size.width -= 100;
        

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            UIEdgeInsets imageEdgeInsets = button.imageEdgeInsets;
            imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets.top, imageEdgeInsets.left - 100, imageEdgeInsets.bottom, imageEdgeInsets.right);
            [button setImageEdgeInsets:imageEdgeInsets];
            UIEdgeInsets titleEdgeInsets = button.titleEdgeInsets;
            titleEdgeInsets.right -= 30;
            [button setTitleEdgeInsets:titleEdgeInsets];
            
            button.frame = frame;
            [button.titleLabel setAlpha:0];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 animations:^{
                [blurView setAlpha:0];
            } completion:^(BOOL finished){
                [blurView removeFromSuperview];
            }];

            CGRect frame = buttonInitFrame;
            [UIView animateWithDuration:0.3 delay:i * 0.05 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                button.frame = frame;
            } completion:^(BOOL finished){
                [self setHidden:YES];
            }];
            
            CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            //角度转弧度
            //        rotationAnimation.beginTime = i * 0.05;
            rotationAnimation.toValue = [NSNumber numberWithFloat:-1 * M_PI * 2];
            rotationAnimation.duration = 0.2f;
            rotationAnimation.repeatCount = 2;
            //动画开始结束的快慢，设置为加速
            rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [button.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
        }];
        
        
        
        
    }
}
- (void)blurViewGestureSelector:(id)sender{
    [self hidePopMenu];
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
