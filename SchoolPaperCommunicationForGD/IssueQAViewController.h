//
//  IssueQAViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueQAViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *issueTV;
@property (strong, nonatomic) IBOutlet UIView *issueToolView;
@property (strong, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *recordAudioButton;
- (IBAction)choosePhotoAction:(id)sender;
- (IBAction)takePhotoAction:(id)sender;
- (IBAction)recordAudioAction:(id)sender;

@end
