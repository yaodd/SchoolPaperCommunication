//
//  IssueQAViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "IssueQAViewController.h"

@interface IssueQAViewController ()
{
    UILabel *placeHolder;
}

@end

@implementation IssueQAViewController
@synthesize issueTV;
@synthesize issueToolView;
@synthesize choosePhotoButton;
@synthesize takePhotoButton;
@synthesize recordAudioButton;

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
    // Do any additional setup after loading the view from its nib.
    [self initLayout];
}

- (void)initLayout
{
    placeHolder = [[UILabel alloc]init];
    placeHolder.frame =CGRectMake(10, 8, 200, 20);
    placeHolder.text = @"输入你的问题让大家帮帮忙...";
    [placeHolder setFont:[UIFont systemFontOfSize:15]];
    [placeHolder setTextColor:[UIColor blackColor]];
    placeHolder.enabled = NO;//lable必须设置为不可用
    placeHolder.backgroundColor = [UIColor clearColor];
    [issueTV addSubview:placeHolder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePhotoAction:(id)sender {
}

- (IBAction)takePhotoAction:(id)sender {
}

- (IBAction)recordAudioAction:(id)sender {
}

#pragma TextViewDelegate mark
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeHolder.text = @"输入你的问题让大家帮帮忙...";
    }else{
        placeHolder.text = @"";
    }
}
@end
