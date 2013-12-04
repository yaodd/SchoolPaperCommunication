//
//  LoginViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "ChoosePlayerViewController.h"
#import "AppDelegate.h"
#import "DynamicPswViewController.h"
#import "ForgetPswViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize accountTF;
@synthesize passwordTF;
@synthesize loginView;
@synthesize loginButton;
@synthesize remeberPswCheck;
@synthesize autoLoginCheck;

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
- (void)initLayout{
    if (IOS_VERSION_7_OR_ABOVE)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
//        tableViewY = 0;
        
    }
    self.title = @"登录";
    [loginView.layer setCornerRadius:5.0f];
    [loginView.layer setBorderWidth:1.0f];
    [loginView.layer setBorderColor:[UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1.0].CGColor];
    
    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 39)];
    UIImageView *leftImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 12, 14)];
    [leftImageView1 setImage:[UIImage imageNamed:@"usericon"]];
    [leftView1 addSubview:leftImageView1];
    accountTF.leftView = leftView1;
    [accountTF setLeftViewMode:UITextFieldViewModeAlways];
    
    UIView *leftView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 39)];
    UIImageView *leftImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 12, 14)];
    [leftImageView2 setImage:[UIImage imageNamed:@"codeicon"]];
    [leftView2 addSubview:leftImageView2];
    passwordTF.leftView = leftView2;
    [passwordTF setLeftViewMode:UITextFieldViewModeAlways];
    
    UIColor *blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIImage *color = [self createImageWithColor:blackColor];
    UIImage *color2 = [self createImageWithColor:[UIColor colorWithRed:13.0/255 green:152.0/255 blue:219.0/255 alpha:1.0]];
//    [loginButton.imageView.layer setCornerRadius:5.0f];
    [loginButton setImage:color2 forState:UIControlStateNormal];
    [loginButton setImage:color forState:UIControlStateHighlighted];
    [loginButton.layer setCornerRadius:5.0f];
    [loginButton.layer setBorderWidth:1.0f];
    [loginButton.layer setBorderColor:[UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1.0].CGColor];
    

    remeberPswCheck.selected = NO;
    autoLoginCheck.selected = NO;
    

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
- (void)setViewCorner:(UIRectCorner)corners :(CGFloat)cornerRadius :(UIView *)view
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
//    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.borderColor = [UIColor blackColor].CGColor;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    
//    maskLayer.borderWidth = 1.0f;
    view.layer.mask = maskLayer;
    
//    [view.layer.mask set];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPswAction:(id)sender {
    ForgetPswViewController *forgetPswViewController = [[ForgetPswViewController alloc]initWithNibName:@"ForgetPswViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPswViewController animated:YES];
}

- (IBAction)dynamicPswAction:(id)sender {
    DynamicPswViewController *dynamicPswViewController = [[DynamicPswViewController alloc]initWithNibName:@"DynamicPswViewController" bundle:nil];
    [self.navigationController pushViewController:dynamicPswViewController animated:YES];
}

- (IBAction)loginAction:(id)sender {
    ChoosePlayerViewController *choosePlayerViewController = [[ChoosePlayerViewController alloc]initWithNibName:@"ChoosePlayerViewController" bundle:nil];
    [self.navigationController pushViewController:choosePlayerViewController animated:YES];
}

- (IBAction)remeberPswAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [button setBackgroundImage:[UIImage imageNamed:@"check_unselected"] forState:UIControlStateNormal];
    } else{
        [button setBackgroundImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;
}

- (IBAction)autoLoginAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [button setBackgroundImage:[UIImage imageNamed:@"check_unselected"] forState:UIControlStateNormal];
    } else{
        [button setBackgroundImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;

}
@end
