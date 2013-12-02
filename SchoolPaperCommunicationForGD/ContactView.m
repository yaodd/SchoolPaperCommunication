//
//  ContactView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ContactView.h"

@implementation ContactView
@synthesize userHeadIV;
@synthesize userNameLabel;
@synthesize toolView;
@synthesize button;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        userHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 50, 50)];
        userHeadIV.layer.masksToBounds = YES;
        [userHeadIV.layer setCornerRadius:25];
        [self addSubview:userHeadIV];
        
        
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(6 + 50 , 6, self.frame.size.width - 56, 50)];
        [userNameLabel setFont:[UIFont systemFontOfSize:30]];
        [self addSubview:userNameLabel];
        
        button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button setFrame:CGRectMake(self.frame.size.width - 50, 6, 50, 50)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        toolView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width - 56, self.frame.size.height)];
        [toolView setBackgroundColor:[UIColor orangeColor]];
        toolView.hidden = YES;
        [self addSubview:toolView];
//        toolView.alpha = 0.0f;
    }
    return self;
}

- (void)setData:(NSDictionary *)dict{
    NSString *name = [dict objectForKey:@"name"];
    UIImage *image = [dict objectForKey:@"image"];
    
    [userHeadIV setImage:image];
    [userNameLabel setText:name];
}

- (void)hideToolView{
    
    CGRect rect = toolView.frame;
    rect.origin.x = 50 + 6;
    [UIView animateWithDuration:0.5 animations:^{
        toolView.frame = rect;
    } completion:^(BOOL finish){
//        [toolView setHidden:YES];
    }];
}
- (void)showToolView{
    [toolView setHidden:NO];
    CGRect rect = toolView.frame;
    rect.origin.x = self.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        toolView.frame = rect;
    } completion:^(BOOL finish){
        
    }];
}
- (void)buttonAction:(id)sender{
    if (toolView.hidden == YES) {
        [self showToolView];
    }else{
        [self hideToolView];
    }
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
