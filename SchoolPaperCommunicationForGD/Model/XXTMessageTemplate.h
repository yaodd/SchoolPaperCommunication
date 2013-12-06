//
//  XXTMessageTemplate.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

typedef NSInteger XXTMessageTemplateType;
#define XXTMessageTemplateTypeOffenUse      1
#define XXTMessageTemplateTypeRecommend     2

@interface XXTMessageTemplate : XXTMessageBase

@property XXTMessageTemplateType type;

- (XXTMessageTemplate*) initWithDictionary:(NSDictionary *)dict;

@end
