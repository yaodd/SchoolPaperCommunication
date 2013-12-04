//
//  XXTUser.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTUser.h"

@implementation XXTUser

@synthesize contactGroupArr;

+(XXTUser*) sharedUser{
    static XXTUser* __sharedUser;
    @synchronized(self){
        if(__sharedUser == nil){
            __sharedUser = [[XXTUser alloc] init];
        }
    }
    return __sharedUser;
}

-(void) initWithLoginInfoDictionary:(NSDictionary *)infoDic{
    
    NSDictionary* userInfoDic = [[infoDic objectForKey:@"items"] objectAtIndex:0];
    
    self.pid = [userInfoDic objectForKey:@"userId"];
    self.name = [userInfoDic objectForKey:@"userName"];
    self.avatar = [[XXTImage alloc] init];
    self.avatar.originPicURL = [userInfoDic objectForKey:@"avatar"];
    self.avatar.thumbPicURL = [userInfoDic objectForKey:@"avatarThumb"];
    self.schoolName = [userInfoDic objectForKey:@"schoolName"];
    self.schoolId = [userInfoDic objectForKey:@"schoolId"];
    self.areaAbbr = [userInfoDic objectForKey:@"areaAbb"];
    self.type = [[userInfoDic objectForKey:@"userType"] intValue];
//    [infoDic objectForKey:@"newMessageNum"]; //这..没啥用啊
//    [infoDic objectForKey:@"extendPageURL"]; //这..没啥用啊
//    [infoDic objectForKey:@"ctdEnable"]; //这..没啥用啊
    self.sessionId = [infoDic objectForKey:@"sessionKey"];
    
    [self loadDataWithUserId:self.pid];
}

- (void) loadDataWithUserId:(NSString*) pid{
    //TODO! 从本地数据读取
    self.microblogsArr = [NSMutableArray array];
    self.allMessagesArr = [NSMutableArray array];
}

- (XXTPersonBase*) getPersonObjectById:(NSString *)pid{
    if ([pid isEqualToString:self.pid]){
        return self;
    }
    else{
        for (XXTGroup* group in contactGroupArr){
            for (XXTContactPerson* person in group.groupMemberArr){
                if ([pid isEqualToString:person.pid])
                    return person;
            }
        }
    }
    return nil;
}


@end
