//
//  QuestionView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-9.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "QuestionView.h"
#import "UIImageView+category.h"
#import "NSString+category.h"



@implementation QuestionView
@synthesize subjectIV;
@synthesize headIV;
@synthesize nameLabel;
@synthesize gradeLabel;
@synthesize subjectLabel;
@synthesize isSolvedIV;
@synthesize isSolvedLabel;
@synthesize timeLabel;
@synthesize contentLabel;
@synthesize contentAudio;
@synthesize contentIV;
@synthesize xxtQuestion;
@synthesize avPlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)initLayout{
    [self.layer setCornerRadius:5.0];
    [self setBackgroundColor:[UIColor colorWithRed:229.0/255 green:232.0/255 blue:229.0/255 alpha:1.0]];
    
}
- (void)setDataWithQuestion:(XXTQuestion *)question{
    UIColor *greyColor = [UIColor colorWithWhite:179.0/255 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:44.0/255 green:187.0/255 blue:0 alpha:1.0];
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    xxtQuestion = question;
    NSString *content = question.content;
    XXTImage *qImage = question.qImage;
    XXTAudio *qAudio = [[XXTAudio alloc]init];
    NSArray *qAudioArr = question.qAudios;
    
    if ([qAudioArr count] != 0) {
        qAudio = [qAudioArr objectAtIndex:0];
    }
    NSString *audioTime = [NSString stringWithFormat:@"%d''",qAudio.duration];
    NSString *subjectName = question.subjectName;
    NSNumber *subjectId = question.subjectId;
    XXTQuestionState state = question.state;
    NSDate *dateTime = question.dateTime;
    NSString *questionerName = question.questionerName;
    XXTImage *questionerAvatar = question.questionerAvatar;
    
    [headIV setImageWithXXTImage:questionerAvatar];
    [nameLabel setText:questionerName];
    [gradeLabel setText:@"待定"];
    [subjectLabel setText:subjectName];
    [isSolvedLabel setText:(state == XXTQuestionStateSolved) ? @"已解决" : @"未解决"];
    [isSolvedLabel setTextColor:(state == XXTQuestionStateSolved) ? greenColor : greyColor];
    [isSolvedLabel setBackgroundColor:[UIColor clearColor]];
    [isSolvedIV setImage:(state == XXTQuestionStateSolved) ?[UIImage imageNamed:@"solved"] : [UIImage imageNamed:@"unsolved"]];
    NSString *timeStr = [[NSString alloc]initWithDate:dateTime];
    [timeLabel setText:timeStr];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH - 10, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat topY = CONTENT_TEXT_Y;
    [contentLabel setFrame:CGRectMake(CONTENT_X, topY, CONTENT_TEXT_WIDTH, size.height + 10)];
    [contentLabel setText:content];
    topY += (size.height + 10);
    if (qImage != nil) {
        [contentIV setFrame:CGRectMake(CONTENT_X, topY, contentIV.frame.size.width, contentIV.frame.size.height)];
        [contentIV setImageWithXXTImage:qImage];
    } else{
        [contentIV setFrame:CGRectZero];
    }
    topY += (contentIV.frame.size.height + 10);
    if (qAudio != nil) {
        
        [contentAudio setFrame:CGRectMake(CONTENT_X, topY, contentAudio.frame.size.width, contentAudio.frame.size.height)];
    } else{
        [contentAudio setFrame:CGRectZero];
    }
    topY += (contentAudio.frame.size.height + 10);
    [contentAudio setTitle:audioTime forState:UIControlStateNormal];
    
    CGFloat viewHeight = topY;
    [self setFrame:CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, viewHeight)];
}

- (void)playAudioAction:(id)sender{
    if ([self.avPlay isPlaying]) {
        [self.avPlay stop];
        return;
    }
//    XXTAudio *audio = xxtQuestion.qAudio;
    XXTAudio *audio = [[XXTAudio alloc]init];
    NSArray *qAudioArr = xxtQuestion.qAudios;
    
    if ([qAudioArr count] != 0) {
        audio = [qAudioArr objectAtIndex:0];
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
        [self playAudioAction:nil];
    } else{
        NSLog(@"音频下载失败");
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
