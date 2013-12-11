//
//  XXTUser.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTUserRole.h"
#import "NSData+AES.h"

@implementation XXTUserRole

-(id) initWithDictionary:(NSDictionary *)userInfoDic{
    if (self = [super init]){
        
        self.pid = [userInfoDic objectForKey:@"userId"];
        self = [self initLoad];
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
    }
    return self;
}

- (XXTPersonBase*) getPersonObjectById:(id)ppid{
    NSString* pid;
    if ([ppid isKindOfClass:[NSString class]])
        pid = ppid;
    if ([ppid isKindOfClass:[NSNumber class]])
        pid = [ppid stringValue];
    if ([pid isEqualToString:[self.pid stringValue]]){
        return self;
    }
    else{
        for (XXTGroup* group in _contactGroupArr){
            for (XXTContactPerson* person in group.groupMemberArr){
                if ([pid isEqualToString:[person.pid stringValue]])
                    return person;
            }
        }
    }
    return nil;
}

- (NSArray*) getMessagesBetweenMeAndPerson:(id)ppid{
    NSString* pid;
    if ([ppid isKindOfClass:[NSString class]])
        pid = ppid;
    if ([ppid isKindOfClass:[NSNumber class]])
        pid = [ppid stringValue];
    
    NSMutableArray* messages = [NSMutableArray array];
    
    for (XXTMessageBase* message in self.allMessagesArr){
        if ([message isKindOfClass:[XXTMessageSend class]]){
            XXTMessageSend* msgS = (XXTMessageSend*)message;
            if (msgS.sendToGroupIdArr.count == 0 && msgS.sendToPersonIdArr.count == 1)
                if ([msgS.sendToPersonIdArr.firstObject isEqualToString:pid])
                    [messages addObject:msgS];
        }
        if ([message isKindOfClass:[XXTMessageReceive class]]){
            XXTMessageReceive *msgR = (XXTMessageReceive*)message;
            if ([msgR.senderId isEqualToString:pid])
                [messages addObject:msgR];
        }
    }
    
    return messages;
}


- (void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.areaAbbr forKey:@"areaAbbr"];
    [aCoder encodeObject:self.contactGroupArr forKey:@"contactGroupArr"];
    [aCoder encodeObject:self.allMessagesArr forKey:@"allMessagesArr"];
    [aCoder encodeObject:self.messageTemplatesArr forKey:@"messageTemplatesArr"];
    [aCoder encodeObject:self.messageHistoryArr forKey:@"messageHistoryArr"];
    [aCoder encodeObject:self.moduleMessagesArr forKey:@"moduleMessagesArr"];
    [aCoder encodeObject:self.microblogsArrOfArr forKey:@"microblogsArrOfArr"];
    [aCoder encodeObject:self.homeworkArr forKey:@"homeworkArr"];
    [aCoder encodeObject:self.evaluateTemplatesArr forKey:@"evaluateTemplatesArr"];
    [aCoder encodeObject:self.questionArr forKey:@"questionArr"];
    [aCoder encodeObject:self.lastUpdateTimeForMessageList
                  forKey:@"lastUpdateTimeForMessageList"];
    [aCoder encodeObject:self.lastUpdateTimeForMicroblogListArr
                  forKey:@"lastUpdateTimeForMicroblogListArr"];
    [aCoder encodeObject:self.lastUpdateTimeForCommentsAndLikes
                  forKey:@"lastUpdateTimeForCommentsAndLikes"];
    [aCoder encodeObject:self.lastUpdateTimeForMessageTemplates
                  forKey:@"lastUpdateTimeForMessageTemplates"];
    [aCoder encodeObject:self.lastUpdateTimeForModuleMessage
                  forKey:@"lastUpdateTimeForModuleMessage"];
    [aCoder encodeObject:self.lastUpdateTimeForBulletinArr
                  forKey:@"lastUpdateTimeForBulletinArr"];
    [aCoder encodeObject:self.lastUpdateTimeForHomework
                  forKey:@"lastUpdateTimeForHomework"];
    [aCoder encodeObject:self.lastUpdateTimeForEvaluateTemplates forKey:@"lastUpdateTimeForEvaluateTemplates"];
    [aCoder encodeObject:self.myCommentsAndLikes
                  forKey:@"myCommentsAndLikes"];
    [aCoder encodeInteger:self.commentAndLikesReadCount
                   forKey:@"commentAndLikesReadCount"];
    [aCoder encodeObject:self.gradeArr forKey:@"gradeArr"];
    [aCoder encodeObject:self.subjectArr forKey:@"subjectArr"];
    [aCoder encodeObject:self.myClassArr forKey:@"myClassArr"];
    [aCoder encodeObject:self.myChildrenArr forKey:@"myChildrenArr"];

}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.schoolId = [aDecoder decodeObjectForKey:@"schoolId"];
        self.areaAbbr = [aDecoder decodeObjectForKey:@"areaAbbr"];
        self.contactGroupArr = [aDecoder decodeObjectForKey:@"contactGroupArr"];
        self.allMessagesArr = [aDecoder decodeObjectForKey:@"allMessagesArr"];
        self.messageTemplatesArr = [aDecoder decodeObjectForKey:@"messageTemplatesArr"];
        self.messageHistoryArr = [aDecoder decodeObjectForKey:@"messageHistoryArr"];
        self.moduleMessagesArr = [aDecoder decodeObjectForKey:@"moduleMessagesArr"];
        self.microblogsArrOfArr = [aDecoder decodeObjectForKey:@"schoolName"];
        self.bulletinArrOfArr = [aDecoder decodeObjectForKey:@"bulletinArr"];
        self.homeworkArr = [aDecoder decodeObjectForKey:@"homeworkArr"];
        self.evaluateTemplatesArr = [aDecoder decodeObjectForKey:@"evaluateTemplatesArr"];
        self.questionArr = [aDecoder decodeObjectForKey:@"questionArr"];
        
        self.lastUpdateTimeForMessageList = [aDecoder decodeObjectForKey:@"lastUpdateTimeForMessageList"];
        self.lastUpdateTimeForMicroblogListArr = [aDecoder decodeObjectForKey:@"lastUpdateTimeForMicroblogListArr"];
        self.lastUpdateTimeForCommentsAndLikes = [aDecoder decodeObjectForKey:@"lastUpdateTimeForCommentsAndLikes"];
        self.lastUpdateTimeForMessageTemplates = [aDecoder decodeObjectForKey:@"lastUpdateTimeForMessageTemplates"];
        self.lastUpdateTimeForModuleMessage = [aDecoder decodeObjectForKey:@"lastUpdateTimeForModuleMessage"];
        self.lastUpdateTimeForBulletinArr = [aDecoder decodeObjectForKey:@"lastUpdateTimeForBulletin"];
        self.lastUpdateTimeForHomework = [aDecoder decodeObjectForKey:@"lastUpdateTimeForHomework"];
        self.lastUpdateTimeForEvaluateTemplates = [aDecoder decodeObjectForKey:@"lastUpdateTimeForEvaluateTemplates"];
        self.myCommentsAndLikes = [aDecoder decodeObjectForKey:@"myCommentsAndLikes"];
        self.commentAndLikesReadCount = [aDecoder decodeIntegerForKey:@"commentAndLikesReadCount"];
        
        self.gradeArr = [aDecoder decodeObjectForKey:@"gradeArr"];
        self.subjectArr = [aDecoder decodeObjectForKey:@"subjectArr"];
        self.myClassArr = [aDecoder decodeObjectForKey:@"myClassArr"];
        self.myChildrenArr=[aDecoder decodeObjectForKey:@"myChildrenArr"];
    }
    return self;
}

- (void) save{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    NSString* aes_key = [AES_KEY stringByAppendingString:[self.pid stringValue]];
    NSString* aesFilename = [[self.pid stringValue] stringByAppendingString:@".archive"];
    NSString* fullAESPath = [ourDocumentPath stringByAppendingString:aesFilename];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    if (WTF){
        NSString* da = [NSString stringWithUTF8String:[data bytes]];
        [da writeToFile:@"/Users/chen070757/Desktop/aa.xml" atomically:YES encoding:NSUTF8StringEncoding error:nil];
//         writeToFile:@"/Users/chen070757/Desktop/aa.xml" atomically:YES];
        NSData* aes = [data AES256EncryptWithKey:aes_key];
        [aes writeToFile:@"/Users/chen070757/Desktop/aa.aes" atomically:YES];
    }

    NSData* atad = [data AES256EncryptWithKey:aes_key];
    [atad writeToFile:fullAESPath atomically:YES];
}

- (id) initLoad{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    NSString* aes_key = [AES_KEY stringByAppendingString:[self.pid stringValue]];
    NSString* aesFilename = [[self.pid stringValue] stringByAppendingString:@".archive"];
    NSString* fullAESPath = [ourDocumentPath stringByAppendingString:aesFilename];

    NSData *aesdata = [NSData dataWithContentsOfFile:fullAESPath];
    if (aesdata!=nil){
        //原来有本地数据
        NSData* data = [aesdata AES256DecryptWithKey:aes_key];
        
        self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else{
        
        self.allMessagesArr = [NSMutableArray array];
        self.messageTemplatesArr = [NSMutableArray array];
        self.messageHistoryArr = [NSMutableArray array];
        self.moduleMessagesArr = [NSMutableArray array];
        self.homeworkArr = [NSMutableArray array];
        self.bulletinArrOfArr = [NSMutableArray array];
        self.lastUpdateTimeForBulletinArr = [NSMutableArray array];
        for (int i = 0 ; i < 3 ; i++){
            [self.bulletinArrOfArr addObject:[NSMutableArray array]];
            [self.lastUpdateTimeForBulletinArr addObject:[NSDate dateWithTimeIntervalSince1970:0] ];
        }
        
        self.microblogsArrOfArr = [NSMutableArray array];
        self.lastUpdateTimeForMicroblogListArr = [NSMutableArray array];
        for (int i = 0 ; i < 4 ; i++){
            [self.microblogsArrOfArr addObject:[NSMutableArray array]];
            [self.lastUpdateTimeForMicroblogListArr addObject:[NSDate dateWithTimeIntervalSince1970:0]];
        }
        
        self.lastUpdateTimeForMessageList = [NSDate dateWithTimeIntervalSince1970:0];
        self.lastUpdateTimeForCommentsAndLikes = [NSDate dateWithTimeIntervalSince1970:0];
        self.lastUpdateTimeForMessageTemplates = [NSDate dateWithTimeIntervalSince1970:0];
        self.lastUpdateTimeForModuleMessage = [NSDate dateWithTimeIntervalSince1970:0];
        self.lastUpdateTimeForHomework  =   [NSDate dateWithTimeIntervalSince1970:0];
        
        self.myCommentsAndLikes = [NSMutableArray array];
        
        self.evaluateArr = [NSMutableArray array];
        self.lastUpdateTimeForEvaluateArr = [NSDate dateWithTimeIntervalSince1970:0];
        
        self.evaluateTemplatesArr = [NSMutableArray array];
        self.lastUpdateTimeForEvaluateTemplates = [NSDate dateWithTimeIntervalSince1970:0];
        
        self.questionArr = [NSMutableArray array];
        
        self.gradeArr = [NSMutableArray array];
        self.subjectArr = [NSMutableArray array];
        self.myChildrenArr = [NSMutableArray array];
        self.myClassArr = [NSMutableArray array];
    }
    
    return self;
}


@end
