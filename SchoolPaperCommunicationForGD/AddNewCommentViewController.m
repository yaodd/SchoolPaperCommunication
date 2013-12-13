//
//  AddNewCommentViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "AddNewCommentViewController.h"
#import "AppDelegate.h"

@interface AddNewCommentViewController ()

@end

@implementation AddNewCommentViewController
{
    UIBarButtonItem *rightBarButton;
    
    UILabel *textViewHint;
}
@synthesize comment;


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
    if (IOS_VERSION_7_OR_ABOVE)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavigationViews];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    comment= [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 310, 150)];
    comment.backgroundColor = [UIColor clearColor];
    comment.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    comment.textColor = [UIColor blackColor];
    comment.returnKeyType = UIReturnKeyDefault;
    comment.scrollEnabled = YES;
    comment.delegate = self;
    comment.textAlignment = NSTextAlignmentLeft;
    [comment becomeFirstResponder];
    [self.view addSubview:comment];
    
    //model the placehold of UITextField
    textViewHint = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 200, 20)];
    textViewHint.backgroundColor = [UIColor clearColor];
    textViewHint.text = @"输入评论..";
    textViewHint.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    textViewHint.textAlignment = NSTextAlignmentLeft;
    textViewHint.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    [comment addSubview:textViewHint];

    [self initCustomBarViewAboveKeyboard];
}

- (void)initNavigationViews
{
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendComment)];
    rightBarButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)initCustomBarViewAboveKeyboard
{
    
}

- (void)sendComment
{
    NSLog(@"Bar button '发送' is pressed!");
    [comment resignFirstResponder];
}

#pragma Mark
#pragma UITextView Delegate

//把回车键当做退出键盘的响应键
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"TextView did begin editing!");
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"TextView did Changed!");
    if([textView.text isEqualToString:@""]){
        textViewHint.hidden = NO;
    }else {
        textViewHint.hidden = YES;
    }
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"TextView did end editing!");
    
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
