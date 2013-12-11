//
//  QuestionPikerView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "QuestionPikerView.h"


@implementation QuestionPikerView
@synthesize pikerDataArray;
@synthesize pikerView;
@synthesize blurView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setHidden:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        pikerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, PIKER_VIEW_HEIGHT - PIKER_VIEW_HEIGHT, self.frame.size.width, PIKER_VIEW_HEIGHT)];
        pikerView.delegate = self;
        pikerView.dataSource = self;
        pikerView.showsSelectionIndicator = YES;
        [self addSubview:pikerView];
    }
    return self;
}

//弹出
- (void)showPikerView
{
    UIView *parentView = self.superview;
    blurView = [[UIView alloc]initWithFrame:parentView.frame];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blurTapGesture:)];
    [blurView addGestureRecognizer:tapGesture];
    [blurView setAlpha:0.0];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [parentView insertSubview:blurView belowSubview:self];
    [self setHidden:NO];
    CGRect frame = self.frame;
    frame.origin.y -= frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.frame = frame;
        [blurView setAlpha:0.2];
    } completion:^(BOOL finished){
        
    }];
}
//收起
- (void)hidePikerView
{
    CGRect frame = self.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.frame = frame;
        [blurView setAlpha:0.0];
    } completion:^(BOOL finished){
        [self setHidden:YES];
        [blurView removeFromSuperview];
    }];
}
//点击灰色背景的响应
- (void)blurTapGesture:(id)sender{
    [self hidePikerView];
}
#pragma UIPikerViewDelegate Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 320;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 320, 35)];
    [label setFont:[UIFont systemFontOfSize:23]];
    [label setText:@"科目科目"];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
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
