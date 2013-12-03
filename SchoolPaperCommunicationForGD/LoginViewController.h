//
//  LoginViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *autoLoginCheck;
@property (strong, nonatomic) IBOutlet UIButton *forgetPswButton;
@property (strong, nonatomic) IBOutlet UIButton *remeberPswCheck;
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *dynamicsPswButton;
- (IBAction)forgetPswAction:(id)sender;
- (IBAction)dynamicPswAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)remeberPswAction:(id)sender;
- (IBAction)autoLoginAction:(id)sender;

@end
