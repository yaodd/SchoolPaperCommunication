//
//  ShareListCell.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ShareListCell.h"
#define kTextName @"Heiti SC"
#define kTextColorName [UIColor colorWithRed:86/255.0 green:122/255.0 blue:150/255.0 alpha:1.0f]
#define kTextColorContent [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0f]
#define kTextColorHint [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0f]
#define kFontSizeName 16
#define kFontSizeContent 15
#define kFontSizeHint 12
#define kContentMaxLength 140
#define kViewBackgroundColor [UIColor clearColor];
#define kBackgroundColor [UIColor whiteColor]
#define kScreenSize [[UIScreen mainScreen] bounds].size

@implementation ShareListCell
{
    UIImageView *commentImg;
    UIImageView *likeImg;
}
@synthesize userHead;
@synthesize userHeadBtn;
@synthesize userName;
@synthesize commentBtn;
@synthesize shareContent;
@synthesize shareDate;
@synthesize shareImg;
@synthesize likeBtn;
@synthesize commentBackground;
@synthesize numberOfComment;
@synthesize numberOflike;
@synthesize bottomView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = kBackgroundColor;
        
        [self initViews];
        
    }
    return self;
}

- (void)initViews{
    
    CGRect headFrame = CGRectMake(5, 10, 45, 45);
    userHead = [[UIImageView alloc] initWithFrame:headFrame];
    userHead.backgroundColor = kViewBackgroundColor;
    userHead.image = [UIImage imageNamed:@"photo"];
    userHead.layer.masksToBounds = YES;
    userHead.layer.cornerRadius = 22.5f;
    userHead.tag = 0;
    [self.contentView addSubview:userHead];
    
    userHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userHeadBtn.backgroundColor = kViewBackgroundColor;
    userHeadBtn.frame = headFrame;
    [self.contentView addSubview:userHeadBtn];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(60, 17, 100, 20)];
    userName.backgroundColor = kViewBackgroundColor;
    userName.textColor = kTextColorName;
    userName.textAlignment = NSTextAlignmentLeft;
    userName.font = [UIFont fontWithName:kTextName size:kFontSizeName];
    userName.text = @"王智锐";
    [self.contentView addSubview:userName];
    
    shareDate = [[UILabel alloc] initWithFrame:CGRectMake(165, 22, 150, 20)];
    shareDate.backgroundColor = kViewBackgroundColor;
    shareDate.textColor = kTextColorHint;
    shareDate.textAlignment = NSTextAlignmentRight;
    shareDate.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    shareDate.text = @"12月4日 13:15";
    [self.contentView addSubview:shareDate];
    
    UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(77, 39, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle"];
    triangle.backgroundColor = kViewBackgroundColor;
    [self.contentView addSubview:triangle];
    
    commentBackground = [[UIButton alloc] initWithFrame:CGRectMake(60, 44, 255, 103)];
    commentBackground.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f];
    commentBackground.layer.cornerRadius = 5.0f;
    [commentBackground addTarget:self action:@selector(jumpToShareDetal) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentBackground];
    
    shareContent = [[UILabel alloc] initWithFrame:CGRectMake(70, 54, 240, 0)];
    shareContent.backgroundColor = kViewBackgroundColor;
    shareContent.textColor = kTextColorContent;
    shareContent.textAlignment = NSTextAlignmentLeft;
    shareContent.lineBreakMode = NSLineBreakByCharWrapping;
    shareContent.numberOfLines = 0;
    shareContent.font = [UIFont fontWithName:kTextName size:kFontSizeContent];
    [self.contentView addSubview:shareContent];
    
    shareImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [shareImg setBackgroundColor:[UIColor blackColor]];
    [self.contentView addSubview:shareImg];
    
    bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, commentBackground.frame.size.height-30, commentBackground.frame.size.width, 30)];
    bottomView.backgroundColor = [UIColor clearColor];
    [bottomView addTarget:self action:@selector(jumpToShareDetal) forControlEvents:UIControlEventTouchUpInside];
    [commentBackground addSubview:bottomView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, commentBackground.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [bottomView addSubview:line];
    
    UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(bottomView.frame.size.width-11.5, bottomView.frame.size.height/2 - 5, 6.5, 10)];
    indicator.backgroundColor = [UIColor clearColor];
    indicator.image = [UIImage imageNamed:@"next"];
    [bottomView addSubview:indicator];
    
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(43, 0, 30, 30)];
    [commentBtn addTarget:self action:@selector(commentBtnPressedDown) forControlEvents:UIControlEventTouchDown];
    [commentBtn addTarget:self action:@selector(commentBtnPressedUp) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commentBtn];
    
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [likeBtn addTarget:self action:@selector(likeBtnPressedDown) forControlEvents:UIControlEventTouchDown];
    [likeBtn addTarget:self action:@selector(likeBtnPressedUp) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:likeBtn];
    
    commentImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 14, 12)];
    commentImg.image = [UIImage imageNamed:@"comment"];
    commentImg.backgroundColor = [UIColor clearColor];
    [self.commentBtn addSubview:commentImg];
    
    likeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 14, 15.5)];
    likeImg.image = [UIImage imageNamed:@"like"];
    likeImg.backgroundColor = [UIColor clearColor];
    [self.likeBtn addSubview:likeImg];
    
    numberOflike = [[UILabel alloc] initWithFrame:CGRectMake(commentImg.frame.origin.x + commentImg.frame.size.width + 3, 8, 20, 15)];
    numberOflike.backgroundColor = [UIColor clearColor];
    numberOflike.textColor = kTextColorHint;
    numberOflike.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    numberOflike.text = @"0";
    [self.likeBtn addSubview:numberOflike];
    
    numberOfComment = [[UILabel alloc] initWithFrame:CGRectMake(likeImg.frame.origin.x + likeImg.frame.size.width + 3, 8, 20, 15)];
    numberOfComment.backgroundColor = [UIColor clearColor];
    numberOfComment.textColor = kTextColorHint;
    numberOfComment.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    numberOfComment.text = @"0";
    [self.commentBtn addSubview:numberOfComment];
    
    
}

- (void)commentBtnPressedDown{
    commentImg.image = [UIImage imageNamed:@"comment_click"];
}

- (void)commentBtnPressedUp{
    commentImg.image = [UIImage imageNamed:@"comment"];
    int number = [numberOfComment.text intValue];
    number++;
    numberOfComment.text = [NSString stringWithFormat:@"%d",number];
}

- (void)likeBtnPressedDown{
    likeImg.image = [UIImage imageNamed:@"like_click"];
}

- (void)likeBtnPressedUp{
    likeImg.image = [UIImage imageNamed:@"like"];
    int number = [numberOflike.text intValue];
    number++;
    numberOflike.text = [NSString stringWithFormat:@"%d",number];
}

- (void)jumpToShareDetal{
    [self.delegate jumpToShareDetailDelegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
