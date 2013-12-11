//
//  SendMassMsgViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTMessageTemplate.h"
#import "ChooseTemplateViewController.h"

@interface SendMassMsgViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,ChooseTemplateControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *contactsView;
@property (strong, nonatomic) IBOutlet UILabel *contactsLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseContactsButton;
- (IBAction)chooseContactsAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *contentTV;
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseTemplateButton;
@property (strong, nonatomic) IBOutlet UIButton *recordAudioButton;
@property (strong, nonatomic) IBOutlet UIView *mediaView;

- (IBAction)choosePhotoAction:(id)sender;
- (IBAction)chooseTemplateAction:(id)sender;
- (IBAction)recordAudioButton:(id)sender;

@end
