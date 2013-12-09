//
//  XXTEvaluateTemplate.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"

typedef enum{
    XXTEvaluateTemplateTypeDefault = 1,
}XXTEvaluateTemplateType;

@interface XXTEvaluateTemplate : XXTObject

@property XXTEvaluateTemplateType type;
@property (copy , nonatomic) NSString* content;

- (XXTEvaluateTemplate*) initWithDictionary:(NSDictionary*) dict;

@end
