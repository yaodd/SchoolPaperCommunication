//
//  IssueQAViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTQuestion.h"

typedef enum{
    IssueTypeQuestion = 1,
    IssueTypeAnswer  = 2
} IssueType;

@interface IssueQAViewController : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *issueTV;
@property (strong, nonatomic) IBOutlet UIView *issueToolView;
@property (strong, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *recordAudioButton;
@property (nonatomic, retain) UIImageView *photoIV;
//@property (nonatomic, retain)
@property (nonatomic,assign) IssueType issueType;
@property (nonatomic, retain) XXTQuestion *currentQuestion;
- (IBAction)choosePhotoAction:(id)sender;
- (IBAction)takePhotoAction:(id)sender;
- (IBAction)recordAudioAction:(id)sender;

@end
