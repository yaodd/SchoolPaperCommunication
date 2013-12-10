//
//  XXTFeedback.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"

@interface XXTFeedback : XXTObject

@property (copy , nonatomic) NSNumber* fid;
@property (copy , nonatomic) NSString* content;
@property (copy , nonatomic) NSDate*  dateTime;
@property (copy , nonatomic) NSString* answer;
@property (copy , nonatomic) NSDate*  answerTime;

- (XXTFeedback*) initWithDictionary:(NSDictionary*) dict;

@end
