//
//  ContactView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ContactView.h"
#import "XXTModelController.h"
#import "UIImageView+category.h"
@implementation ContactView
@synthesize userHeadIV;
@synthesize userNameLabel;
@synthesize phoneButton;
@synthesize msgButton;
@synthesize chatButton;
@synthesize toolButton;
@synthesize contactPerson;
@synthesize phoneLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        myDict = [NSDictionary]
        CGFloat leftButtonX = 5;
        userHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(leftButtonX, 9,48, 48)];
        userHeadIV.layer.masksToBounds = YES;
        [userHeadIV.layer setCornerRadius:24];
        [self addSubview:userHeadIV];
        
        leftButtonX += (10 + 48);
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftButtonX, 15, 100, 18)];
        [userNameLabel setFont:[UIFont systemFontOfSize:15]];
        [userNameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:userNameLabel];
        
        phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftButtonX, 39, 100, 18)];
        [phoneLabel setBackgroundColor:[UIColor clearColor]];
        [phoneLabel setTextColor:[UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0]];
        [self addSubview:phoneLabel];
        
        CGFloat buttonX = 161;
        CGFloat buttonRadius = 24;
        CGFloat buttonY = 9;
        NSArray *imageNameArrayN = [NSArray arrayWithObjects:@"phone",@"message",@"chat", nil];
        NSArray *imageNameArrayH = [NSArray arrayWithObjects:@"phone_click",@"message_click",@"chat_click", nil];
        for (int i = 0; i < 3; i ++) {
            toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [toolButton setFrame:CGRectMake(buttonX, buttonY, buttonRadius * 2, buttonRadius * 2)];
            [toolButton.layer setCornerRadius:buttonRadius];
//            [toolButton setBackgroundColor:[UIColor greenColor]];
            [toolButton setTag:i];
            [toolButton setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
            [toolButton setImage:[UIImage imageNamed:[imageNameArrayN objectAtIndex:i]] forState:UIControlStateNormal];
            [toolButton setImage:[UIImage imageNamed:[imageNameArrayH objectAtIndex:i]] forState:UIControlStateHighlighted];
            [toolButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:toolButton];
            buttonX += 53;
        }
        UIView *sepector = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, 1)];
        [sepector setBackgroundColor:[UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0]];
        [self addSubview:sepector];
    }
    return self;
}

- (void)setData:(XXTContactPerson *)person{
    contactPerson = person;
    [userHeadIV setImageWithXXTImage:person.avatar];
    [userNameLabel setText:person.name];
    [phoneLabel setText:person.phone];
}
- (void)buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self.delegate ContactViewButtonAction:self button:button person:contactPerson];
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
