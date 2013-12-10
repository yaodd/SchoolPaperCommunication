//
//  NSNumber+stringCompare.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/10/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "NSNumber+stringCompare.h"

@implementation NSNumber (stringCompare)

- (BOOL) isEqualToString:(id)strr{
    NSString* str;
    if ([strr isKindOfClass:[NSString class]])
        str = strr;
    if ([strr isKindOfClass:[NSNumber class]])
        str = [strr stringValue];
    return [[self stringValue] isEqualToString:str];
}

@end

