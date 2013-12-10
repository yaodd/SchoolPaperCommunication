//
//  addNewShareViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "AddNewShareViewController.h"

@interface AddNewShareViewController ()

@end

@implementation AddNewShareViewController
{
    CGFloat originY;
    BOOL isIOS7;
    
    UIBarButtonItem *rightBarButton;
    
    UILabel *textViewHint;
}
@synthesize shareContent;
@synthesize shareImage;
@synthesize addPhoto;

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
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        originY = 64;
        isIOS7 = YES;
    }else{
        isIOS7 = NO;
        originY = 0;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavigationViews];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    shareContent= [[UITextView alloc] initWithFrame:CGRectMake(10, originY+10, 310, 150)];
    shareContent.backgroundColor = [UIColor clearColor];
    shareContent.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    shareContent.textColor = [UIColor blackColor];
    shareContent.returnKeyType = UIReturnKeyDefault;
    shareContent.scrollEnabled = YES;
    shareContent.delegate = self;
    shareContent.textAlignment = NSTextAlignmentLeft;
    [shareContent becomeFirstResponder];
    [self.view addSubview:shareContent];
    
    //model the placehold of UITextField
    textViewHint = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 200, 20)];
    textViewHint.backgroundColor = [UIColor clearColor];
    textViewHint.text = @"你想分享什么呢..";
    textViewHint.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
    textViewHint.textAlignment = NSTextAlignmentLeft;
    textViewHint.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    [shareContent addSubview:textViewHint];
    
    shareImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    shareImage.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:shareImage];
    
    [self initCustomBarViewAboveKeyboard];
}

- (void)initNavigationViews
{
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendShare)];
    rightBarButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)initCustomBarViewAboveKeyboard
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44 + 90)];
    topView.backgroundColor = [UIColor whiteColor];
    
    shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
    shareImage.backgroundColor = [UIColor blackColor];
    [topView addSubview:shareImage];
    
    UIImageView *topViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 320, 44)];
    topViewBackground.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    topViewBackground.userInteractionEnabled = YES;
    [topView addSubview:topViewBackground];
    
    addPhoto = [[UIButton alloc] initWithFrame:CGRectMake(214, 0, 320-214, 44)];
    addPhoto.backgroundColor = [UIColor clearColor];
    [addPhoto addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [topViewBackground addSubview:addPhoto];
    
    UIImageView *addPhotoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 36.5, 36.5)];
    addPhotoIcon.backgroundColor = [UIColor clearColor];
    addPhotoIcon.image = [UIImage imageNamed:@"addPhoto"];
    [addPhoto addSubview:addPhotoIcon];
    
    UILabel *addPhotoTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 320-214-40, 20)];
    addPhotoTitle.text = @"添加照片";
    addPhotoTitle.backgroundColor = [UIColor clearColor];
    addPhotoTitle.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    addPhotoTitle.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1.0];
    addPhotoTitle.textAlignment = NSTextAlignmentLeft;
    [addPhoto addSubview:addPhotoTitle];
    
    [shareContent setInputAccessoryView:topView];
    
}

- (void)sendShare
{
    NSLog(@"Bar button '发送' is pressed!");
    [shareContent resignFirstResponder];
}

- (void)addPhotoAction
{
    NSLog(@"Add photo button '添加照片' is pressed!");
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
