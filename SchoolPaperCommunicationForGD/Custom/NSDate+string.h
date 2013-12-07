//
//  NSDate+string.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (string)

+ (NSString*) stringValueOfDate:(NSDate*) date;
+ (NSDate*) dateFromString:(NSString*) dateString;

@end
