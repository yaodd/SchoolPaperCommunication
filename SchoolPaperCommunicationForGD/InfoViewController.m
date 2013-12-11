//
//  InfoViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "InfoViewController.h"
#import "SendMassMsgViewController.h"

@interface InfoViewController ()

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMassMsgAction:)];
    [self.view addGestureRecognizer:tapGesture];

}
- (void)sendMassMsgAction:(id)sender{
    [self setHidesBottomBarWhenPushed:YES];
    SendMassMsgViewController *sendMassMsgViewController = [[SendMassMsgViewController alloc]initWithNibName:@"SendMassMsgViewController" bundle:nil];
    [self.navigationController pushViewController:sendMassMsgViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
