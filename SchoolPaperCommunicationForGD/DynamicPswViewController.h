//
//  DynamicPswViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicPswViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UIButton *getDynamicButton;
- (IBAction)getDynamicAction:(id)sender;

@end
