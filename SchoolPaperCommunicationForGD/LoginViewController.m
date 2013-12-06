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
#import "Dao.h"
#import "XXTModelController.h"
#import "XXTModelGlobal.h"
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
//初始化布局
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
    
    [loginButton.layer setCornerRadius:5.0f];
    [loginButton.layer setBorderWidth:1.0f];
    [loginButton.layer setBorderColor:[UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1.0].CGColor];
    

    remeberPswCheck.selected = NO;
    autoLoginCheck.selected = NO;
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//忘记密码响应
- (IBAction)forgetPswAction:(id)sender {
    ForgetPswViewController *forgetPswViewController = [[ForgetPswViewController alloc]initWithNibName:@"ForgetPswViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPswViewController animated:YES];
}
//获取动态密码响应
- (IBAction)dynamicPswAction:(id)sender {
    DynamicPswViewController *dynamicPswViewController = [[DynamicPswViewController alloc]initWithNibName:@"DynamicPswViewController" bundle:nil];
    [self.navigationController pushViewController:dynamicPswViewController animated:YES];
}
//登录按钮点击响应
- (IBAction)loginAction:(id)sender {
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loginWithThread:) object:nil];
    [thread start];
    
}
//访问网络
- (void)loginWithThread:(NSThread *)thread{
    Dao *dao = [Dao sharedDao];
    int isSuccess = [dao requestForLogin:@"test" password:@"test"];
    if (isSuccess == 1) {
        NSLog(@"login success");
        [self performSelectorOnMainThread:@selector(jumpToNextPager) withObject:nil waitUntilDone:YES];
    } else {
        NSLog(@"login failed");
    }

}
//登录成功，跳转
- (void)jumpToNextPager{
    ChoosePlayerViewController *choosePlayerViewController = [[ChoosePlayerViewController alloc]initWithNibName:@"ChoosePlayerViewController" bundle:nil];
    [self.navigationController pushViewController:choosePlayerViewController animated:YES];

}
//记住密码复选框响应
- (IBAction)remeberPswAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [button setBackgroundImage:[UIImage imageNamed:@"check_unselected"] forState:UIControlStateNormal];
    } else{
        [button setBackgroundImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;
}
//自动登录复选框响应
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
