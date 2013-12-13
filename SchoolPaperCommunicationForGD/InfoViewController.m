//
//  InfoViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "InfoViewController.h"
#import "SendMassMsgViewController.h"
#import "MsgHistoryViewController.h"
@interface InfoViewController ()
{
    PopMenuView *popMenuView;
}

@end

@implementation InfoViewController

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
    [self.view setBackgroundColor:[UIColor grayColor]];
    NSLog(@"didload");
    	// Do any additional setup after loading the view.
    [self initLayout];
}
- (void)initLayout
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [menuButton setFrame:CGRectMake(self.view.frame.size.width - 10 - 30, self.view.frame.size.height - 10 - 30 - 49, 30, 30)];
    [menuButton setBackgroundColor:[UIColor clearColor]];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    popMenuView = [[PopMenuView alloc]initWithFrame:CGRectMake(0, 0, self.tabBarController.view.frame.size.width, self.tabBarController.view.frame.size.height)];
    popMenuView.delegate = self;
    [self.tabBarController.view addSubview:popMenuView];
}
- (void)menuAction:(id)sender{
    [popMenuView showPopMenu];
}
- (void)jumpWithViewController:(UIViewController *)nextViewController{
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:nextViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
#pragma PopMenuViewDelegate mark
- (void)PopMenuViewClickAction:(PopMenuView *)menuView withButton:(UIButton *)button{
    UIViewController *nextViewController = [[UIViewController alloc]init];
    if (button.tag == kPopMenuViewTypeSendDynamic) {
        nextViewController = [[MsgHistoryViewController alloc]initWithNibName:@"MsgHistoryViewController" bundle:nil];
    }
    if (button.tag == kPopMenuViewTypeSendComment) {
        
    }
    if (button.tag == kPopMenuViewTypeSendHomework) {
        
    }
    if (button.tag == kPopMenuViewTypeSendNotice) {
        
    }
    if (button.tag == kPopMenuViewTypeSendMassMsg) {
        nextViewController = [[SendMassMsgViewController alloc]initWithNibName:@"SendMassMsgViewController" bundle:nil];
    }
    [self jumpWithViewController:nextViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
