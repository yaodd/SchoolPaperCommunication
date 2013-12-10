//
//  QuestionView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-9.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "QuestionView.h"
#import "UIImageView+category.h"



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
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
}
- (void)setDataWithQuestion:(XXTQuestion *)question{
    xxtQuestion = question;
    NSString *content = question.content;
    XXTImage *qImage = question.qImage;
    XXTAudio *qAudio = question.qAudio;
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
    NSString *timeStr = [self getStringWithDate:dateTime];
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
    
    
    CGFloat viewHeight = topY;
    [self setFrame:CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, viewHeight)];
}
- (NSString *)getStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"M月d日 HH:MM"];
    
    return [formatter stringFromDate:date];
}
- (void)playAudioAction:(id)sender{
    if ([self.avPlay isPlaying]) {
        [self.avPlay stop];
        return;
    }
    XXTAudio *audio = xxtQuestion.qAudio;
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
