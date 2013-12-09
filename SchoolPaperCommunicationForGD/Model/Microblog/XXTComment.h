//
//  XXTComment.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/4/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

typedef enum {
    XXTCommentTypeDefault = 1,
    XXTCommentTypeLike    = 2
} XXTCommentType;

@interface XXTComment : XXTObject

@property (copy , nonatomic) NSString *senderName;
@property (copy , nonatomic) NSString *content;
@property (strong , nonatomic) XXTImage *avatar;
@property (copy , nonatomic) NSDate   *dateTime;
@property XXTCommentType type;

- (XXTComment*) initWithContent:(NSString*) content;

@end
