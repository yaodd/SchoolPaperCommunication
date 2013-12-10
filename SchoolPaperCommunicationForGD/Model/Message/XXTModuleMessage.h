//
//  XXTModuleMessage.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/6/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"

@interface XXTModuleMessage : XXTObject

@property (copy,nonatomic) NSString* type;
@property (copy,nonatomic) NSString* icon;
@property (copy,nonatomic) NSString* title;
@property (copy,nonatomic) NSDate* dateTime;
@property (copy,nonatomic) NSString* content;
@property NSInteger count;

- (XXTModuleMessage*) initWithDictionary:(NSDictionary*) dict;

@end
