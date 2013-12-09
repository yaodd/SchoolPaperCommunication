//
//  UIApplication+appinfo.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/4/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface UIApplication (appinfo)

+(NSString*) appVersion;
+(NSString*) build;
+(NSString*) versionBuild;

+(NSString*) appId;
+(NSString*) sysVersion;
+(NSString*) deviceType;

@end
