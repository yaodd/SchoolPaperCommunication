//
//  XXTModelGlobal.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTModelGlobal.h"

@implementation XXTModelGlobal

+(XXTModelGlobal*) sharedModel{
    static XXTModelGlobal* __sharedModel;
    @synchronized(self){
        if(__sharedModel == nil){
            __sharedModel = [[XXTModelGlobal alloc] init];
        }
    }
    return __sharedModel;
}

- (void) initWithLoginInfoDictionary:(NSDictionary *)infoDic{
    self.sessionId = [infoDic objectForKey:@"sessionKey"];
    
    NSMutableArray* userArr = [NSMutableArray array];
    NSArray* userDicArr = [infoDic objectForKey:@"items"];
    for (NSDictionary* userInfoDic in userDicArr){
        XXTUserRole* userRole = [[XXTUserRole alloc] initWithDictionary:userInfoDic];
        [userArr addObject:userRole];
    }
    
    self.userObjectArr = userArr;
}

@end
