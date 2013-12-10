//
//  PersonDedailViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "AppDelegate.h"
#import "UIImageView+category.h"
#import "XXTModelGlobal.h"
#import "SendMessageViewController.h"

@interface PersonDetailViewController ()

@end

@implementation PersonDetailViewController
@synthesize chatButton;
@synthesize classLabel;
@synthesize headImageView;
@synthesize nameLabel;
@synthesize phoneNumLabel;
@synthesize phoneButton;
@synthesize messageButton;
@synthesize currentPid;

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
    [self initLayout];
    // Do any additional setup after loading the view from its nib.
}
//初始化布局
- (void)initLayout{
    if (IOS_VERSION_7_OR_ABOVE)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    [headImageView.layer setCornerRadius:25];
    [headImageView.layer setMasksToBounds:YES];
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"call_click"] forState:UIControlStateHighlighted];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"sendmessage_click"] forState:UIControlStateHighlighted];
    [chatButton setBackgroundImage:[UIImage imageNamed:@"startchat_click"] forState:UIControlStateHighlighted];
    [self initData];
}

- (void)initData
{
    XXTUserRole *userRole = [XXTModelGlobal sharedModel].currentUser;
    NSString *userName = userRole.name;
    XXTImage *xxtImage = userRole.avatar;
    NSArray *classArr = userRole.myClassArr;
    NSString *className = [[NSString alloc]init];
    if ([classArr count] != 0) {
        className = [classArr objectAtIndex:0];
    }
    [headImageView setImageWithXXTImage:xxtImage];
    [nameLabel setText:userName];
    [classLabel setText:className];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneAction:(id)sender {
    NSLog(@"打电话");
}

- (IBAction)messageAction:(id)sender {
    NSLog(@"发短信");
    [self setHidesBottomBarWhenPushed:YES];
    SendMessageViewController *sendMessageViewController = [[SendMessageViewController alloc]initWithNibName:@"SendMessageViewController" bundle:nil];
    [sendMessageViewController setCurrentPid:currentPid];
    [self.navigationController pushViewController:sendMessageViewController animated:YES];
}

- (IBAction)chatAction:(id)sender {
    NSLog(@"即时聊天");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
