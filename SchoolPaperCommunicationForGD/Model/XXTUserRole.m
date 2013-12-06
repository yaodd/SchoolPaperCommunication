//
//  XXTUser.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTUserRole.h"

@implementation XXTUserRole

-(id) initWithDictionary:(NSDictionary *)userInfoDic{
    if (self = [super init]){
        
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
        
        [self loadDataWithUserId:self.pid];
    }
    return self;
}

- (void) loadDataWithUserId:(NSString*) pid{
    //TODO! 从本地数据读取
    self.microblogsArrOfArr = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],nil];
    self.lastUpdateTimeForMicroblogListArr = [NSMutableArray arrayWithObjects:[NSDate dateWithTimeIntervalSince1970:0],[NSDate dateWithTimeIntervalSince1970:0],[NSDate dateWithTimeIntervalSince1970:0],[NSDate dateWithTimeIntervalSince1970:0],nil];
    self.allMessagesArr = [NSMutableArray array];
    self.messageTemplatesArr = [NSMutableArray array];
    self.messageHistoryArr = [NSMutableArray array];
    self.moduleMessagesArr = [NSMutableArray array];
    self.contactGroupArr = [NSMutableArray array];
}

- (XXTPersonBase*) getPersonObjectById:(NSString *)pid{
    if ([pid isEqualToString:self.pid]){
        return self;
    }
    else{
        for (XXTGroup* group in _contactGroupArr){
            for (XXTContactPerson* person in group.groupMemberArr){
                if ([pid isEqualToString:person.pid])
                    return person;
            }
        }
    }
    return nil;
}


@end
