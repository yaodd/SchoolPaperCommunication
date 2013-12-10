//
//  XXTQuestion.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTImage.h"
#import "XXTAudio.h"
#import "XXTAnswer.h"

typedef enum{
    XXTQuestionStateUnsolved = 1,
    XXTQuestionStateSolved   = 2
} XXTQuestionState;

@interface XXTQuestion : XXTObject

@property (copy , nonatomic) NSNumber* qid;
@property (copy , nonatomic) NSString* content;
@property (strong , nonatomic) XXTImage* qImage;
@property (strong , nonatomic) NSArray* qAudios;
@property (strong , nonatomic) NSString* subjectName;
@property (strong , nonatomic) NSNumber* subjectId;
@property XXTQuestionState state;
@property NSDate* dateTime;

@property (copy , nonatomic) NSString* questionerName;
@property (strong , nonatomic) XXTImage* questionerAvatar;

@property (strong , nonatomic) NSMutableArray* answersArr;

- (XXTQuestion*) initWithDictionary:(NSDictionary*) dict;
- (XXTQuestion*) initNewQuestion:(NSString*) content subjectId:(int) sid image:(XXTImage*) image audio:(XXTAudio*) audio;

@end
