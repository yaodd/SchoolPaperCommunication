//
//  ContactView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ContactView.h"
#import "XXTModelController.h"
@implementation ContactView
@synthesize userHeadIV;
@synthesize userNameLabel;
@synthesize toolView;
@synthesize showButton;
@synthesize hideButton;
@synthesize phoneButton;
@synthesize msgButton;
@synthesize chatButton;
@synthesize deleteButton;
//@synthesize myDict;
@synthesize contactPerson;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        myDict = [NSDictionary]
        
        userHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 50, 50)];
        userHeadIV.layer.masksToBounds = YES;
        [userHeadIV.layer setCornerRadius:25];
        [self addSubview:userHeadIV];
        
        
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(6 + 50 , 6, self.frame.size.width - 56, 50)];
        [userNameLabel setFont:[UIFont systemFontOfSize:30]];
        [self addSubview:userNameLabel];
        
        showButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [showButton setFrame:CGRectMake(self.frame.size.width - 50, 6, 50, 50)];
        [showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showButton];
        
        toolView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width - 56, self.frame.size.height)];
        [toolView setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:toolView];
        
        CGFloat toolViewButtonX = 6.0f;
        hideButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [hideButton setFrame:CGRectMake(toolViewButtonX, 6, 50, 50)];
        [hideButton addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:hideButton];
        toolViewButtonX += (50 + 6);
        
        phoneButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [phoneButton setFrame:CGRectMake(toolViewButtonX, 6, 50, 50)];
        [phoneButton addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:phoneButton];
        toolViewButtonX += (50 + 6);

        chatButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [chatButton setFrame:CGRectMake(toolViewButtonX, 6, 50, 50)];
        [chatButton addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:chatButton];
        toolViewButtonX += (50 + 6);
        
        msgButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [msgButton setFrame:CGRectMake(toolViewButtonX, 6, 50, 50)];
        [msgButton addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:msgButton];
        toolViewButtonX += (50 + 6);
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [deleteButton setFrame:CGRectMake(toolViewButtonX, 6, 50, 50)];
        [deleteButton addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:deleteButton];
        
    }
    return self;
}

- (void)setData:(XXTContactPerson *)person{
//    myDict = dict;
    contactPerson = person;
    NSString *name = person.name;
    UIImage *image = person.avatar.thumbPicImage;
//    BOOL toolIsShow = [[dict objectForKey:@"toolIsShow"] boolValue];
    if (image == nil) {
        image = [UIImage imageNamed:@"photo"];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage:) object:nil];
        [thread start];
    }
    [userHeadIV setImage:image];
    [userNameLabel setText:name];
    
//    if (toolIsShow) {
//        [toolView setFrame:CGRectMake(50 + 6, 0, self.frame.size.width - 56, self.frame.size.height)];
//    } else{
        [toolView setFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width - 56, self.frame.size.height)];
//    }

}
//下载图片
- (void)downloadImage:(NSThread *)thread{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:contactPerson.avatar.thumbPicURL]];
    UIImage *image = [UIImage imageWithData:data];
    if (image == nil) {
        NSLog(@"图片下载失败");
    }else{
        [self performSelectorOnMainThread:@selector(updateImageView:) withObject:image waitUntilDone:YES];
        
    }
    
}
- (void)updateImageView:(UIImage *)image{
    contactPerson.avatar.thumbPicImage = image;
    [userHeadIV setImage:image];
}

- (void)hideToolView{
//    [myDict setObject:[NSNumber numberWithBool:NO] forKey:@"toolIsShow"];
    CGRect rect = toolView.frame;
    rect.origin.x = self.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        toolView.frame = rect;
    } completion:^(BOOL finish){
//        [toolView setHidden:YES];
//        [self setUserInteractionEnabled:NO];
    }];
}
- (void)showToolView{
//    [myDict setObject:[NSNumber numberWithBool:YES] forKey:@"toolIsShow"];
    CGRect rect = toolView.frame;
    rect.origin.x = 50 + 6;
    [UIView animateWithDuration:0.5 animations:^{
        toolView.frame = rect;
    } completion:^(BOOL finish){
//        [self setUserInteractionEnabled:YES];
    }];
}
- (void)showButtonAction:(id)sender{
    NSLog(@"show");
    [self showToolView];
}
- (void)hideButtonAction:(id)sender{
    [self hideToolView];
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
