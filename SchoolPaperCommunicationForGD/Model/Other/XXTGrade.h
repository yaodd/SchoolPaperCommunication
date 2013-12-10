//
//  XXTGrade.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/10/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"

@interface XXTGrade : XXTObject

@property (copy , nonatomic) NSNumber* gid;
@property (copy , nonatomic) NSString* name;

- (XXTGrade*) initWithDictionary:(NSDictionary*) dict;

@end
