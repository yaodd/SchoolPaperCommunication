//
//  AnswerView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "AnswerView.h"
#import "QuestionView.h"
#import "NSString+category.h"
#import "UIImageView+category.h"
@implementation AnswerView
@synthesize headIV;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize contentIV;
@synthesize contentLabel;
@synthesize audioButton;
@synthesize xxtAnswer;
@synthesize avPlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setDataWithAnswer:(XXTAnswer *)answer{
    xxtAnswer = answer;
    NSString *answerName = answer.answererName;
    NSDate *date = answer.dateTime;
    NSString *dateStr = [[NSString alloc]initWithDate:date];
    NSString *contentStr = answer.content;
    XXTImage *aImage = answer.aImage;
    XXTImage *aAvatar = answer.answererAvatar;
    XXTAudio *aAudio = [[XXTAudio alloc]init];
    NSArray *audioArr = answer.aAudios;
    if ([audioArr count] != 0) {
        aAudio = [audioArr objectAtIndex:0];
    }
    NSString *audioTime = [NSString stringWithFormat:@"%d''",aAudio.duration];
    [timeLabel setText:dateStr];
    [headIV setImageWithXXTImage:aAvatar];
    [audioButton setTitle:audioTime forState:UIControlStateNormal];
    [nameLabel setText:answerName];
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [contentStr sizeWithFont:font constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH - 10, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    float topY = CONTENT_TEXT_Y;
    [contentLabel setFrame:CGRectMake(CONTENT_X, topY, CONTENT_TEXT_WIDTH, size.height + 10)];
    [contentLabel setText:contentStr];
    topY += (size.height + 10);
    
    if (aImage != nil) {
        [contentIV setFrame:CGRectMake(CONTENT_X, topY, contentIV.frame.size.width, contentIV.frame.size.height)];
        [contentIV setImageWithXXTImage:aImage];
    } else{
        [contentIV setFrame:CGRectZero];
    }
    topY += (contentIV.frame.size.height + 10);
    if (aAudio != nil) {
        [audioButton setFrame:CGRectMake(CONTENT_X, topY, audioButton.frame.size.width, audioButton.frame.size.height)];
    }else{
        [audioButton setFrame:CGRectZero];
    }
    topY += (audioButton.frame.size.height + 10);
    
    CGFloat viewHeight = topY;
    UIView *sepector = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight - 1, 320, 0.5)];
    [sepector setBackgroundColor:[UIColor colorWithWhite:179.0 / 255 alpha:1.0]];
    [self addSubview:sepector];
    [self setFrame:CGRectMake(0, 0, VIEW_WIDTH, viewHeight)];
}

- (IBAction)audioAction:(id)sender {
    if ([self.avPlay isPlaying]) {
        [self.avPlay stop];
        return;
    }
    //    XXTAudio *audio = xxtQuestion.qAudio;
    XXTAudio *audio = [[XXTAudio alloc]init];
    NSArray *aAudioArr = xxtAnswer.aAudios;
    
    if ([aAudioArr count] != 0) {
        audio = [aAudioArr objectAtIndex:0];
    }
    
    if (audio.audiodata != nil) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithData:audio.audiodata error:nil];
        self.avPlay = player;
        [self.avPlay play];
    } else{
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadAudio:) object:audio];
        [thread start];
    }

}
- (void)downloadAudio:(XXTAudio *)audio{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:audio.audioURL]];
    NSLog(@"audioUrl %@",audio.audioURL);
    if (data != nil) {
        audio.audiodata = data;
        [self audioAction:nil];
    } else{
        NSLog(@"音频下载失败");
    }
}

@end
