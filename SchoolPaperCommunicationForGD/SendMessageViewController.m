//
//  SendMessageViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "SendMessageViewController.h"
#import "AppDelegate.h"
#define XXT_VIEW_TAG    111111
#define MSG_VIEW_TAG    222222

@interface SendMessageViewController ()
{
    UIColor *greyColor;
    UIColor *blueColor;
    int currentViewTag;
    CGRect upRect;
    CGRect downRect;
    
    XXTContactPerson *currentPerson;
    XXTModelGlobal *modelGlobal;
    XXTUserRole *userRole;
    UILabel *placeHolder;
}

@end

@implementation SendMessageViewController
@synthesize  receiveContactsLabel;
@synthesize chooseConsigneeButton;
@synthesize messageImageView;
@synthesize messageLabel;
@synthesize messageTextView;
@synthesize methodButton;
@synthesize methodImageView;
@synthesize methodLabel;
@synthesize methodMSGView;
@synthesize methodXXTView;
@synthesize currentPid;
@synthesize XXTMethodButton;
@synthesize MSGMethodButton;
@synthesize methodButtonMSG;

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
    NSLog(@"viewDidload");
    // Do any additional setup after loading the view from its nib.
    [self initLayout];
}

- (void)initLayout{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction:)];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    currentViewTag = XXT_VIEW_TAG;
    modelGlobal = [XXTModelGlobal sharedModel];
    userRole = modelGlobal.currentUser;
//    currentPerson = (XXTContactPerson *)[userRole getPersonObjectById:currentPid];
//    NSString *contactInfo = [NSString stringWithFormat:@"%@ %@",currentPerson.name,currentPerson.phone];
//    [receiveContactsLabel setText:contactInfo];
    upRect = methodXXTView.frame;
    downRect = methodMSGView.frame;
    
    greyColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    blueColor = [UIColor colorWithRed:225.0/255 green:245.0/255 blue:1 alpha:1.0];
    methodButton.selected = NO;
    methodButtonMSG.selected = NO;
    [methodButton addTarget:self action:@selector(methodAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *blueImage = [self createImageWithColor:blueColor];
    UIImage *greyImage = [self createImageWithColor:greyColor];
    [XXTMethodButton setBackgroundImage:blueImage forState:UIControlStateHighlighted];
    [XXTMethodButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [MSGMethodButton setBackgroundImage:blueImage forState:UIControlStateHighlighted];
    [MSGMethodButton setBackgroundImage:greyImage forState:UIControlStateNormal];
    [XXTMethodButton setHidden:YES];
    [MSGMethodButton setHidden:YES];
    
    //给textView添加placeHolder
    placeHolder = [[UILabel alloc]init];
    placeHolder.frame =CGRectMake(10, 8, 200, 20);
    placeHolder.text = @"输入短信内容...";
    [placeHolder setFont:[UIFont systemFontOfSize:15]];
    [placeHolder setTextColor:[UIColor blackColor]];
    placeHolder.enabled = NO;//lable必须设置为不可用
    placeHolder.backgroundColor = [UIColor clearColor];
    [messageTextView addSubview:placeHolder];
    messageTextView.delegate = self;
}
//发送按钮响应
- (void)sendAction:(id)sender{
    NSLog(@"发送");
}
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseConsigneeAction:(id)sender {
}

- (IBAction)methodAction:(id)sender {
    if (methodButton.selected) {
        [methodButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [methodButtonMSG setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];

        if (currentViewTag == XXT_VIEW_TAG) {
            methodXXTView.frame = upRect;
            methodMSGView.frame = downRect;
            [methodMSGView setHidden:YES];
            [methodXXTView setHidden:NO];
        } else{
            methodXXTView.frame = downRect;
            methodMSGView.frame = upRect;
            [methodLabel setHidden:NO];
            [methodButtonMSG setHidden:NO];
            [methodXXTView setHidden:YES];
            [methodMSGView setHidden:NO];
        }
        methodMSGView.hidden = YES;
        CGRect frame = messageTextView.frame;
        frame.origin.y -= 44;
        frame.size.height -= 44;
        messageTextView.frame = frame;
        [XXTMethodButton setHidden:YES];
        [MSGMethodButton setHidden:YES];
    }else{
        [methodButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [methodButtonMSG setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
//        methodMSGView.hidden = NO;
        methodXXTView.frame = upRect;
        methodMSGView.frame = downRect;
        [methodMSGView setHidden:NO];
        [methodXXTView setHidden:NO];
        [methodButtonMSG setHidden:YES];
        [methodLabel setHidden:YES];
        CGRect frame = messageTextView.frame;
        frame.origin.y += 44;
        frame.size.height += 44;
        messageTextView.frame = frame;
        [XXTMethodButton setHidden:NO];
        [MSGMethodButton setHidden:NO];

    }
    methodButton.selected = !methodButton.selected;
    methodButtonMSG.selected = !methodButtonMSG.selected;
}
- (IBAction)chooseMethodAction:(id)sender {
    NSLog(@"click");

    UIButton *button = (UIButton *)sender;
    currentViewTag = button.tag;
    if (currentViewTag == XXT_VIEW_TAG) {
        
        methodXXTView.frame = upRect;
        methodMSGView.frame = downRect;
        [methodMSGView setHidden:YES];
    }else{
        methodXXTView.frame = downRect;
        methodMSGView.frame = upRect;
        [methodXXTView setHidden:YES];
        [methodLabel setHidden:NO];
        [methodButtonMSG setHidden:NO];
    }
    [methodButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [methodButtonMSG setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    methodButton.selected = NO;
    methodButtonMSG.selected = NO;
    CGRect frame = messageTextView.frame;
    frame.origin.y -= 44;
    frame.size.height -= 44;
    messageTextView.frame = frame;
    [XXTMethodButton setHidden:YES];
    [MSGMethodButton setHidden:YES];
}

#pragma TextViewDelegate mark
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeHolder.text = @"输入短信内容...";
    }else{
        placeHolder.text = @"";
    }
}
@end
