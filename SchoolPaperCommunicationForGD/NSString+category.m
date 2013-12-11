//
//  NSString+category.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NSString+category.h"

@implementation NSString (category)

- (id)initWithDate:(NSDate *)date{
    self = [[NSString alloc]init];
    if (self) {
        self = [self getStringWithDate:date];
    }
    return self;
}

- (NSString *)getStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"M月d日 HH:MM"];
    
    return [formatter stringFromDate:date];
}
@end
