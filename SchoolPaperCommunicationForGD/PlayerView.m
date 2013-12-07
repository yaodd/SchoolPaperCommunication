//
//  PlayerView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-6.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "PlayerView.h"
#import "UIImageView+category.h"

#define VIEW_X      12
#define VIEW_Y      0
#define VIEW_WIDTH  296
#define VIEW_HEIGHT 86

@implementation PlayerView
@synthesize headImageView;
@synthesize playerLabel;
@synthesize userRole;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithDefault{
    self = [super initWithFrame:CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT)];
    if (self) {
        [self.layer setCornerRadius:5.0f];
        [self.layer setBorderColor:[UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1.0].CGColor];
        [self.layer setBorderWidth:1.0];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 64, 64)];
        [headImageView.layer setCornerRadius:32.0];
        [headImageView.layer setMasksToBounds:YES];
        [self addSubview:headImageView];
        
        playerLabel = [[UILabel alloc]initWithFrame:CGRectMake(93, 35, 200, 20)];
        [playerLabel setBackgroundColor:[UIColor clearColor]];
        [playerLabel setFont:[UIFont systemFontOfSize:18]];
        [playerLabel setTextColor:[UIColor colorWithRed:70.0/255 green:70.0/255 blue:70.0/255 alpha:1.0]];
        [playerLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:playerLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(279, 32, 11, 20)];
        [arrowImageView setImage:[UIImage imageNamed:@"next"]];
        [self addSubview:arrowImageView];
    }
    
    return self;
    
}
- (void)setData:(XXTUserRole *)role{
    NSArray *playerArray = [NSArray arrayWithObjects:@"老师",@"家长",@"学生", nil];

    userRole = role;
    
    NSString *player = [playerArray objectAtIndex:role.type - 1];
    [headImageView setImageWithPerson:role];
    [playerLabel setText:player];
    
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
