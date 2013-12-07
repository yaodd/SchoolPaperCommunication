//
//  DetailViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "DetailViewController.h"
#import "commentCell.h"
#define kTextName @"Heiti SC"
#define kTextColorName [UIColor colorWithRed:86/255.0 green:122/255.0 blue:150/255.0 alpha:1.0f]
#define kTextColorContent [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0f]
#define kTextColorHint [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0f]
#define kFontSizeName 16
#define kFontSizeContent 15
#define kFontSizeHint 12
#define kContentMaxLength 140

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    UIButton *commentBtn;
    UIButton *likeBtn;
    UIImageView *commentImg;
    UIImageView *likeImg;

    CGFloat originY;
    BOOL isIOS7;
    NSInteger contentHeight;
}
@synthesize userHead;
@synthesize userName;
@synthesize shareDate;
@synthesize shareContent;
@synthesize shareImg;
@synthesize commentList;
@synthesize numberOfComment;
@synthesize numberOflike;
@synthesize commentBackground;
@synthesize scrollView;
@synthesize commentDataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    CGRect screenFrame =  [[UIScreen mainScreen] bounds];
    NSLog(@"%ld", (long)screenFrame.size.height);
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        originY = 64;
        isIOS7 = YES;
        contentHeight = screenFrame.size.height - 64;
    }else{
        originY = 0;
        isIOS7 = NO;
        contentHeight = screenFrame.size.height - 44;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    commentDataArray = [[NSMutableArray alloc] init];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight - 49)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    [self initUserInfoView];
    [self initShareDetailView];
    [self initCommentDetailView];
}

//load views
- (void)initUserInfoView
{
    userHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    userHead.backgroundColor = [UIColor clearColor];
    userHead.image = [UIImage imageNamed:@"photo"];
    userHead.layer.masksToBounds = YES;
    userHead.layer.cornerRadius = 22.5f;
    [self.scrollView addSubview:userHead];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 100, 20)];
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = kTextColorName;
    userName.textAlignment = NSTextAlignmentLeft;
    userName.font = [UIFont fontWithName:kTextName size:kFontSizeName];
    userName.text = @"王智锐";
    [self.scrollView addSubview:userName];
    
    shareDate = [[UILabel alloc] initWithFrame:CGRectMake(userName.frame.origin.x, 40, 150, 20)];
    shareDate.backgroundColor = [UIColor clearColor];
    shareDate.textColor = kTextColorHint;
    shareDate.textAlignment = NSTextAlignmentLeft;
    shareDate.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    shareDate.text = @"12月4日 13:15";
    [self.scrollView addSubview:shareDate];
    
    UIButton *userDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    userDetailBtn.backgroundColor = [UIColor clearColor];
    [userDetailBtn addTarget:self action:@selector(jumpToUserDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:userDetailBtn];
    
    UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(320-11.5, userDetailBtn.frame.size.height/2 - 5, 6.5, 10)];
    indicator.backgroundColor = [UIColor clearColor];
    indicator.image = [UIImage imageNamed:@"next"];
    [userDetailBtn addSubview:indicator];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f];
    [self.scrollView addSubview:line];
}

- (void)initShareDetailView
{
    CGFloat newOriginY = 65;
    
    shareContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+newOriginY, 240, 100)];
    shareContent.backgroundColor = [UIColor clearColor];
    shareContent.textColor = kTextColorContent;
    shareContent.textAlignment = NSTextAlignmentLeft;
    shareContent.lineBreakMode = NSLineBreakByCharWrapping;
    shareContent.numberOfLines = 0;
    shareContent.font = [UIFont fontWithName:kTextName size:kFontSizeContent];
    shareContent.text = @"这里是分享的文字内容";
    [self.scrollView addSubview:shareContent];
    
    shareImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [shareImg setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:shareImg];
}

- (void)initCommentDetailView
{
    CGFloat newOriginY = 10 + shareContent.frame.size.height + 10 + shareImg.frame.size.height + 5;
    
    UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(30, newOriginY+5, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle"];
    triangle.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:triangle];
    
    commentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, newOriginY+10, 305, 103)];
    commentBackground.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f];
    commentBackground.layer.cornerRadius = 5.0f;
    commentBackground.userInteractionEnabled = YES;
    [self.scrollView addSubview:commentBackground];
    
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 40, 40)];
    [likeBtn addTarget:self action:@selector(likeBtnPressedDown) forControlEvents:UIControlEventTouchDown];
    [likeBtn addTarget:self action:@selector(likeBtnPressedUp) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBackground addSubview:likeBtn];
    
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(likeBtn.frame.origin.x+43, 0, 40, 40)];
    [commentBtn addTarget:self action:@selector(commentBtnPressedDown) forControlEvents:UIControlEventTouchDown];
    [commentBtn addTarget:self action:@selector(commentBtnPressedUp) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBackground addSubview:commentBtn];
    
    commentImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 14, 12)];
    commentImg.image = [UIImage imageNamed:@"comment"];
    commentImg.backgroundColor = [UIColor clearColor];
    [commentBtn addSubview:commentImg];
    
    likeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 15.5)];
    likeImg.image = [UIImage imageNamed:@"like"];
    likeImg.backgroundColor = [UIColor clearColor];
    [likeBtn addSubview:likeImg];
    
    numberOflike = [[UILabel alloc] initWithFrame:CGRectMake(commentImg.frame.origin.x + commentImg.frame.size.width + 3, 11, 20, 15)];
    numberOflike.backgroundColor = [UIColor clearColor];
    numberOflike.textColor = kTextColorHint;
    numberOflike.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    numberOflike.text = @"0";
    [likeBtn addSubview:numberOflike];
    
    numberOfComment = [[UILabel alloc] initWithFrame:CGRectMake(likeImg.frame.origin.x + likeImg.frame.size.width + 3, 11, 20, 15)];
    numberOfComment.backgroundColor = [UIColor clearColor];
    numberOfComment.textColor = kTextColorHint;
    numberOfComment.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    numberOfComment.text = @"0";
    [commentBtn addSubview:numberOfComment];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, commentBackground.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [self.commentBackground addSubview:line];
    
    commentList = [[UITableView alloc] initWithFrame:CGRectMake(0, commentBackground.frame.size.height, commentBackground.frame.size.width, commentBackground.frame.size.height - 40)];
    commentList.delegate = self;
    commentList.scrollEnabled = NO;
    commentList.separatorColor = [UIColor clearColor];
    commentList.backgroundColor = [UIColor clearColor];
    [commentBackground addSubview:commentList];
    
}

- (void)jumpToUserDetail
{
    
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

#pragma Mark
#pragma UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentListCell";
    commentCell *cell = (commentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        commentCell *cell = [[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
