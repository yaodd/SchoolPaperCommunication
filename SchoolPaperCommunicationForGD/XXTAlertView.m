//
//  XXTAlertView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "XXTAlertView.h"
#define SMALL_FRAME     CGRectMake(52, 161, 216, 125)
#define LAGER_FRAME     CGRectMake(52, 161, 216, 162)
#define IMAGE_FRAME     CGRectMake(85, 25, 46, 37)
#define LABEL_FRAME     CGRectMake(10, 76, 196, 30)

@implementation XXTAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title :(NSArray *)buttons :(BOOL)isSuccess{
    CGRect frame;
    if ([buttons count] == 0) {
        frame = SMALL_FRAME;
    } else{
        frame = LAGER_FRAME;
    }
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:5.0f];
        UIImage *image;
        if (isSuccess) {
            image = [UIImage imageNamed:@"succeed"];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:IMAGE_FRAME];
        [imageView setImage:image];
        [self addSubview:imageView];
        
        
    }
    
    
    
    return self;
}

- (void)show {
}

- (void)dismiss {
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
