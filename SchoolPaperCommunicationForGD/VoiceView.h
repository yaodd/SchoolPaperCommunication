//
//  VoiceView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-1.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTModelGlobal.h"
@class VoiceView;
@protocol VoiceViewDelegate <NSObject>

@optional
- (void)playAudio:(XXTAudio *)audio;

@end
@interface VoiceView : UIView
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) XXTMessageBase *message;
@property (nonatomic, assign) id<VoiceViewDelegate> delegate;
- (id)initWithDefault;
- (void)setData:(XXTMessageBase *)msg;
@end
