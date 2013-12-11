//
//  AnswerView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTAnswer.h"
#import <AVFoundation/AVFoundation.h>

@interface AnswerView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headIV;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contentIV;
@property (strong, nonatomic) IBOutlet UIButton *audioButton;
@property (nonatomic, retain) XXTAnswer *xxtAnswer;
@property (nonatomic, retain) AVAudioPlayer *avPlay;
- (IBAction)audioAction:(id)sender;

- (void)setDataWithAnswer:(XXTAnswer *)answer;
@end
