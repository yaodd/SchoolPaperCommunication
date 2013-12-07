//
//  XXTMicroblog.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"
#import "XXTComment.h"

typedef enum {
    XXTMicroblogCircleTypeMine = 0,
    XXTMicroblogCircleTypeClass = 1,
    XXTMicroblogCircleTypeTeacher = 2,
    XXTMicroblogCircleTypeSchool = 3
}XXTMicroblogCircleType;

@interface XXTMicroblog : XXTMessageBase

@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger likeCount;
@property (strong,nonatomic) NSMutableArray* commentsArr;


@end
