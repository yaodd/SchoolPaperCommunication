//
//  IssueQAViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "IssueQAViewController.h"
#import "AppDelegate.h"

@interface IssueQAViewController ()
{
    UILabel *placeHolder;
    NSString *placeHolderStr;
}

@end

@implementation IssueQAViewController
@synthesize issueTV;
@synthesize issueToolView;
@synthesize choosePhotoButton;
@synthesize takePhotoButton;
@synthesize recordAudioButton;
@synthesize issueType;

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
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (issueType == IssueTypeAnswer) {
        placeHolderStr = @"输入你独到的见解吧...";
    } else{
        placeHolderStr = @"输入你的问题让大家帮帮忙...";
    }
    placeHolder = [[UILabel alloc]init];
    placeHolder.frame =CGRectMake(10, 8, 200, 20);
    placeHolder.text = placeHolderStr;
    [placeHolder setFont:[UIFont systemFontOfSize:15]];
    [placeHolder setTextColor:[UIColor blackColor]];
    placeHolder.enabled = NO;//lable必须设置为不可用
    placeHolder.backgroundColor = [UIColor clearColor];
    [issueTV addSubview:placeHolder];
    CGRect issueFrame = issueTV.frame;
    issueFrame.size.height = self.view.frame.size.height - 44 - TOP_BAR_HEIGHT;
    issueTV.frame = issueFrame;
    CGRect toolViewFrame = issueToolView.frame;
    toolViewFrame.origin.y = issueTV.frame.size.height + issueTV.frame.origin.y;
    issueToolView.frame = toolViewFrame;
    
    UIBarButtonItem *issueItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(issueItemAction:)];
    self.navigationItem.rightBarButtonItem = issueItem;
//    [issueTV becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)issueItemAction:(id)sender{
    
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect issueFrame = self.issueTV.frame;
    __block CGRect toolFrame = self.issueToolView.frame;
    CGFloat toolViewHeight = 44;
    if (toolFrame.origin.y != screenHeight - keyboardSize.height - toolViewHeight) {
        toolFrame.origin.y = screenHeight - keyboardSize.height - toolViewHeight;//lxf
        issueFrame.size.height = screenHeight - keyboardSize.height - toolViewHeight;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.issueTV.frame = issueFrame;
                             self.issueToolView.frame = toolFrame;
                         } completion:^(BOOL finished) {
                             self.issueTV.frame = issueFrame;
                             self.issueToolView.frame = toolFrame;
                         }];
        
    }
    NSLog(@"show");
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    
    CGFloat toolViewHeight = 44;
    
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect toolFrame = self.issueToolView.frame;
    __block CGRect issueFrmae = self.issueTV.frame;
    issueFrmae.size.height = issueFrmae.size.height + keyboardSize.height;
    toolFrame.origin.y = screenHeight - toolViewHeight;//lxf
    self.issueTV.frame = issueFrmae;
    self.issueToolView.frame = toolFrame;
    NSLog(@"hide");
    //    [UIView animateWithDuration:fAniTimeSecond animations:^{
    //        self.viewItems.frame = frame;
    //    }];
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
        placeHolder.text = placeHolderStr;
    }else{
        placeHolder.text = @"";
    }
}
@end
