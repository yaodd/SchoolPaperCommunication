//
//  ForgetPswViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-6.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTAlertView.h"


@interface ForgetPswViewController : UIViewController  <XXTAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UIButton *getAuthCodeButton;
- (IBAction)getAuthCodeAction:(id)sender;

@end
