//
//  SendMessageViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTModelGlobal.h"
@interface SendMessageViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *receiveContactsLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseConsigneeButton;
@property (strong, nonatomic) IBOutlet UIImageView *methodImageView;
@property (strong, nonatomic) IBOutlet UILabel *methodLabel;
@property (strong, nonatomic) IBOutlet UIButton *methodButton;
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIView *methodXXTView;
@property (strong, nonatomic) IBOutlet UIView *methodMSGView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIButton *XXTMethodButton;
@property (strong, nonatomic) IBOutlet UIButton *MSGMethodButton;
@property (strong, nonatomic) IBOutlet UIButton *methodButtonMSG;
@property (nonatomic, retain) NSString *currentPid;
- (IBAction)chooseConsigneeAction:(id)sender;
- (IBAction)methodAction:(id)sender;
- (IBAction)buttonAction:(id)sender;

@end
