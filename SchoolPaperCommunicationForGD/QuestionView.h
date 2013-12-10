//
//  QuestionView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-9.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTQuestion.h"
#import <AVFoundation/AVFoundation.h>

#define CONTENT_X      10
#define CONTENT_TEXT_Y      65
#define CONTENT_TEXT_WIDTH  288

#define VIEW_X          10
#define VIEW_Y          0
#define VIEW_WIDTH      308

#define IMAGE_HEIGHT    120
#define AUDIO_HEIGHT    36

@interface QuestionView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *subjectIV;
@property (strong, nonatomic) IBOutlet UIImageView *headIV;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *isSolvedLabel;
@property (strong, nonatomic) IBOutlet UIImageView *isSolvedIV;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contentIV;
@property (strong, nonatomic) IBOutlet UIButton *contentAudio;
@property (nonatomic, retain) XXTQuestion *xxtQuestion;
@property (nonatomic, retain) AVAudioPlayer *avPlay;
- (IBAction)playAudioAction:(id)sender;

- (void)initLayout;
- (void)setDataWithQuestion:(XXTQuestion *)question;
@end
