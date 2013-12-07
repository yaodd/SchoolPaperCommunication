//
//  NSDate+string.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "NSDate+string.h"

@implementation NSDate (string)

+ (NSString*) stringValueOfDate:(NSDate*) date{
    NSString* timeString;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-mm-dd hh:mm:ss"];
    if (date == nil){
        timeString = @"";
    }
    else{
        timeString = [formatter stringFromDate:date];
    }
    return timeString;
}

+ (NSDate*) dateFromString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter dateFromString:dateString];
}

@end
