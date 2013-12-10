//
//  DetailViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ShareDetailViewController.h"
#import "AddNewCommentViewController.h"
#import "commentCell.h"
#import "AppDelegate.h"
#define kTextName @"Heiti SC"
#define kTextColorName [UIColor colorWithRed:86/255.0 green:122/255.0 blue:150/255.0 alpha:1.0f]
#define kTextColorContent [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0f]
#define kTextColorHint [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0f]
#define kFontSizeName 16
#define kFontSizeContent 15
#define kFontSizeHint 12
#define kContentMaxLength 140

@interface ShareDetailViewController ()

@end

@implementation ShareDetailViewController
{
    UIButton *commentBtn;
    UIButton *likeBtn;
    UIImageView *commentImg;
    UIImageView *likeImg;
    UIImageView *triangle;

    CGFloat originY;
    BOOL isIOS7;
    NSInteger contentHeight;
    NSInteger heightForList;
    
    XXTMicroblog *micro;
    
    NSInteger commentListHeight;   //消息列表的高度
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

- (id)initWithMicro:(XXTMicroblog *)microBlog
{
    self = [super init];
    
    micro = microBlog;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect screenFrame =  [[UIScreen mainScreen] bounds];
    if (IOS_VERSION_7_OR_ABOVE)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
        contentHeight = screenFrame.size.height - 64;
    }else{
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
    
    [self setData];
}

//load views
- (void)initUserInfoView
{
    userHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    userHead.backgroundColor = [UIColor clearColor];
    userHead.image = [UIImage imageNamed:@"photo"];
    userHead.layer.masksToBounds = YES;
    userHead.layer.cornerRadius = 22.5f;
    [scrollView addSubview:userHead];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 100, 20)];
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = kTextColorName;
    userName.textAlignment = NSTextAlignmentLeft;
    userName.font = [UIFont fontWithName:kTextName size:kFontSizeName];
    userName.text = @"王智锐";
    [scrollView addSubview:userName];
    
    shareDate = [[UILabel alloc] initWithFrame:CGRectMake(userName.frame.origin.x, 40, 150, 20)];
    shareDate.backgroundColor = [UIColor clearColor];
    shareDate.textColor = kTextColorHint;
    shareDate.textAlignment = NSTextAlignmentLeft;
    shareDate.font = [UIFont fontWithName:kTextName size:kFontSizeHint];
    shareDate.text = @"12月4日 13:15";
    [scrollView addSubview:shareDate];
    
    UIButton *userDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    userDetailBtn.backgroundColor = [UIColor clearColor];
    [userDetailBtn addTarget:self action:@selector(jumpToUserDetail) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:userDetailBtn];
    
    UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(320-11.5, userDetailBtn.frame.size.height/2 - 5, 6.5, 10)];
    indicator.backgroundColor = [UIColor clearColor];
    indicator.image = [UIImage imageNamed:@"next"];
    [userDetailBtn addSubview:indicator];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f];
    [scrollView addSubview:line];
}

- (void)initShareDetailView
{
    CGFloat newOriginY = 65;
    
    shareContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+newOriginY, 240, 0)];
    shareContent.backgroundColor = [UIColor clearColor];
    shareContent.textColor = kTextColorContent;
    shareContent.textAlignment = NSTextAlignmentLeft;
    shareContent.lineBreakMode = NSLineBreakByCharWrapping;
    shareContent.numberOfLines = 0;
    shareContent.font = [UIFont fontWithName:kTextName size:kFontSizeContent];
    shareContent.text = @"这里是分享的文字内容";
    [scrollView addSubview:shareContent];
    
    shareImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [shareImg setBackgroundColor:[UIColor blackColor]];
    [scrollView addSubview:shareImg];
}

- (void)initCommentDetailView
{
    CGFloat newOriginY = 65 + shareContent.frame.size.height + shareImg.frame.size.height;
    
    triangle = [[UIImageView alloc] initWithFrame:CGRectMake(30, newOriginY+5, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle"];
    triangle.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:triangle];
    
    commentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, newOriginY+10, 305, 40)];
    commentBackground.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f];
    commentBackground.layer.cornerRadius = 5.0f;
    commentBackground.userInteractionEnabled = YES;
    [scrollView addSubview:commentBackground];
    
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 40, 40)];
    [likeBtn addTarget:self action:@selector(likeBtnPressedDown) forControlEvents:UIControlEventTouchDown];
    [likeBtn addTarget:self action:@selector(likeBtnPressedUp) forControlEvents:UIControlEventTouchUpInside];
    [commentBackground addSubview:likeBtn];
    
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(likeBtn.frame.origin.x+43, 0, 40, 40)];
    [commentBtn addTarget:self action:@selector(commentBtnPressedDown) forControlEvents:UIControlEventTouchDown];
    [commentBtn addTarget:self action:@selector(commentBtnPressedUp) forControlEvents:UIControlEventTouchUpInside];
    [commentBackground addSubview:commentBtn];
    
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
    [commentBackground addSubview:line];
    
    commentList = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, commentBackground.frame.size.width, 200)];
    commentList.dataSource = self;
    commentList.delegate = self;
    commentList.scrollEnabled = NO;
    commentList.separatorColor = [UIColor clearColor];
    commentList.backgroundColor = [UIColor clearColor];
    [commentBackground addSubview:commentList];
    
}

- (void)setData
{
    NSLog(@"setData");
    //The following code is for getting the exact height of text content
    NSString *content = micro.content;
    CGSize size = CGSizeMake(240, 2000);
    shareContent.text = content;
    CGSize contentSize = [content sizeWithFont:[UIFont fontWithName:@"Heiti SC" size:15.0] forWidth:size.width lineBreakMode:NSLineBreakByCharWrapping];
    CGRect contentFrame = CGRectMake(shareContent.frame.origin.x, shareContent.frame.origin.y, shareContent.frame.size.width, contentSize.height);
    shareContent.frame = CGRectMake(shareContent.frame.origin.x, shareContent.frame.origin.y, contentFrame.size.width, contentFrame.size.height);
    
    //Translate the shareDateTime to NSString
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:micro.dateTime];
    shareDate.text = dateString;
    
    CGRect commentBgFrame = commentBackground.frame;
    commentBackground.frame = CGRectMake(commentBgFrame.origin.x, commentBgFrame.origin.y+contentFrame.size.height+20, commentBgFrame.size.width, 40 + commentList.frame.size.height);
    
    triangle.frame = CGRectMake(triangle.frame.origin.x, triangle.frame.origin.y+contentFrame.size.height+20, triangle.frame.size.width, triangle.frame.size.height);
    
    //Fix the exact number of comment and like
    numberOfComment.text = [NSString stringWithFormat:@"%ld", (long)micro.commentCount];
    numberOflike.text = [NSString stringWithFormat:@"%ld", (long)micro.likeCount];
}

- (void)jumpToUserDetail
{
    
}

- (void)commentBtnPressedDown{
    commentImg.image = [UIImage imageNamed:@"comment_click"];
}

- (void)commentBtnPressedUp{
    commentImg.image = [UIImage imageNamed:@"comment"];
    AddNewCommentViewController *controller = [[AddNewCommentViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
    NSLog(@"Height for row: %ld", indexPath.row);
    NSInteger height;
    //The following code is for getting the exact height of text content
    XXTComment *comment = [micro.commentsArr objectAtIndex:indexPath.row];
    CGSize size = CGSizeMake(240, 1000);
    CGSize contentSize = [comment.content sizeWithFont:[UIFont fontWithName:@"Heiti SC" size:15.0] forWidth:size.width lineBreakMode:NSLineBreakByCharWrapping];
    height = contentSize.height;
    heightForList += height;
    commentListHeight += height+40;
    return height+40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return micro.commentsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row at indexpath :row(), section()");//, indexPath.row, indexPath.section);
    static NSString *CellIdentifier = @"CommentListCell";
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //The following code is for getting the exact height of text content
    XXTComment *comment = [micro.commentsArr objectAtIndex:indexPath.row];
    NSLog(@"commentArrCount:%ld",micro.commentsArr.count);
    CGSize size = CGSizeMake(240, 2000);
    cell.comment.text = comment.content;
    CGSize contentSize = [comment.content sizeWithFont:[UIFont fontWithName:@"Heiti SC" size:15.0] forWidth:size.width lineBreakMode:NSLineBreakByCharWrapping];
    cell.comment.frame = CGRectMake(cell.comment.frame.origin.x, cell.comment.frame.origin.y, cell.comment.frame.size.width, contentSize.height);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == micro.commentsArr.count-1){
        commentBackground.frame = CGRectMake(commentBackground.frame.origin.x, commentBackground.frame.origin.y, commentBackground.frame.size.width, 40+commentListHeight);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
