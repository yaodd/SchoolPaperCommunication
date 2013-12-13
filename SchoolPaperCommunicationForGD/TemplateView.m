//
//  TemplateView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "TemplateView.h"

@implementation TemplateView
@synthesize contentLabel;
@synthesize expandButton;
@synthesize holder;
@synthesize sepector;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [contentLabel setFont:LABEL_FONT];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setNumberOfLines:0];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentLabel];
        
        expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:expandButton];
        
        sepector  = [[UIView alloc]initWithFrame:CGRectZero];
        [sepector setBackgroundColor:[UIColor colorWithWhite:235.0/255 alpha:1.0]];
        [self addSubview:sepector];
        
    }
    return self;
}
- (void)setDataWithTemplateHolder:(TemplateHolder *)templateHolder{
    
    holder = templateHolder;
    
    XXTMessageTemplate *messageTemplate = templateHolder.messageTemplate;
    BOOL isExpanded = templateHolder.isExpanded;
    NSString *contentStr = messageTemplate.content;
    UIColor *blueColor = [UIColor colorWithRed:13.0/255 green:152.0/255 blue:219.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithWhite:52.0/255 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:148.0/255 green:203.0/255 blue:0 alpha:1.0];
    
    CGSize size = [contentStr sizeWithFont:LABEL_FONT constrainedToSize:CGSizeMake(LABEL_WIDTH - 10, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelHeight;
    CGFloat buttonHeight;
    CGFloat viewHeight;
    UIColor *textColor = [[UIColor alloc]init];
    UIColor *viewColor = [[UIColor alloc]init];
    UIColor *buttonColor = [[UIColor alloc]init];
    UIImage *buttonImage;
    NSString *buttonTitle = [[NSString alloc]init];
    if (isExpanded) {
        labelHeight = size.height;
        buttonHeight = labelHeight + 30;
        viewHeight = labelHeight + 30;
        expandButton.selected = YES;
        textColor = [UIColor whiteColor];
        viewColor = blueColor;
        buttonColor = greenColor;
        buttonImage = [[UIImage alloc]init];
        [expandButton setUserInteractionEnabled:YES];
        buttonTitle = @"使用";
//        NSLog(@"")
    } else{
        labelHeight = 36;
        buttonHeight = TEMPLATE_VIEW_HEIGHT_DEFAULT;
        viewHeight = TEMPLATE_VIEW_HEIGHT_DEFAULT;
        expandButton.selected = NO;
        textColor = greyColor;
        viewColor = [UIColor whiteColor];
        buttonColor = [UIColor whiteColor];
        buttonImage = [UIImage imageNamed:@"open_up"];
        [expandButton setUserInteractionEnabled:NO];
        buttonTitle = @"";
    }
    [contentLabel setFrame:CGRectMake(LABEL_X, LABEL_Y, LABEL_WIDTH, labelHeight)];
    [contentLabel setText:contentStr];
    [contentLabel setTextColor:textColor];
    
    [expandButton setFrame:CGRectMake(BUTTON_X, 0, BUTTON_WIDTH, buttonHeight)];
    [expandButton setImage:buttonImage forState:UIControlStateNormal];
    [expandButton setBackgroundColor:buttonColor];
    [expandButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    
    [sepector setFrame:CGRectMake(0, viewHeight - 1, 320, 1)];
    [self setBackgroundColor:viewColor];
    [self setFrame:CGRectMake(0, 0, 320, viewHeight)];
    
}
- (void)expandAction:(UIButton *)button{
    [self.delegate templateView:self withHolder:self.holder];
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
