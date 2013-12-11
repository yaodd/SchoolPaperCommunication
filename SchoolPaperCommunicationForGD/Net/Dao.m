//
//  Dao.m
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "Dao.h"
#import "Reachability.h"
#import "XXTModelController.h"
#import "UIApplication+appinfo.h"
#import "SSZipArchive.h"
@interface Dao ()

-(void)initNetworkStateObserver;
-(void)reachabilityChanged:(NSNotification*)note;
-(NSDictionary *)request:(NSString *)urlString dict:(NSDictionary *)dict;
-(void)insertUserInfoToDictionary:(NSMutableDictionary*) dict;
-(NSString*) getUrlForModule:(NSString*) moduleName WithCmd:(NSString*) cmdStr;

@end

@implementation Dao

@synthesize reachbility;

//此处为基本ip地址
//#define baseUrl  @"http://localhost:8888/index.php"
#define baseUrl @"http://120.197.89.182:8080/mobile/pull"

#define userModuleUrl            @"login"
#define messageModuleUrl         @"messages"
#define contactsModuleUrl        @"contacts"
#define sysModuleUrl             @"modules"
#define otherModuleUrl           @"others"


//此处为基本操作码与URL后缀

#define loginCmd                @"10011"
#define logoffCmd               @"10012"
#define forgetPwdCmd            @"10013"
#define dynamicPwdCmd           @"10014"
#define changeProfileCmd        @"10015"
#define changePwdCmd            @"10016"

#define messageListCmd          @"10021"
#define messageStatusUpdateCmd  @"10022"
#define sendGroupMessageCmd     @"10023"
#define messageTemplatesCmd     @"10024"
#define getModuleMessageCmd     @"10025"
#define messageHistoryCmd       @"10026"
#define getMessageReceiverCmd   @"10027"

#define sendInstantMessageCmd   @"10031"
#define getContactListCmd       @"10032"

#define microblogsListCmd       @"10041"
#define postMicroblogCmd        @"10042"
#define postCommentCmd          @"10043"
#define postLikeCmd             @"10044"
#define microblogDetailCmd      @"10045"
#define getCommentAndLikesCmd   @"10046"

#define bulletinListCmd         @"10051"
#define postBulletinCmd         @"10052"

#define homeworkListCmd         @"10062"
#define postHomeworkCmd         @"10061"

#define evaluateListCmd         @"10071"
#define evaluateDetailCmd       @"10072"
#define evaluateHistory2PersonCmd @"10073"
#define evaluateTemplatesCmd    @"10074"
#define postEvaluateCmd         @"10075"

#define questionListCmd         @"10081"
#define questionDetailCmd       @"10082"
#define postQuestionCmd         @"10083"
#define postAnswerCmd           @"10084"
#define gradeListCmd            @"10085"

#define feedbackListCmd         @"10091"
#define postFeedbackCmd         @"10092"

#define uploadErrorLogCmd       @"20004"
#define classListCmd            @"20005"
#define studentListCmd          @"20006"
#define childrenListCmd         @"20007"
#define subjectListCmd          @"20008"
#define appUpdateCmd            @"20009"
#define moduleUpdateCmd         @"20010"

//此处为一些常量 - 可以把它们移到config.h里
#define PLATFORM @"ios"
#define APIVERSION @"1.0"

#define messageRequestInterval 20.0f

+(id)sharedDao{
    static Dao* sharedDaoer;
    @synchronized(self){
        if(sharedDaoer == nil){
            sharedDaoer = [[Dao alloc] init];
            [sharedDaoer initNetworkStateObserver];
        }
    }
    return sharedDaoer;
}

-(void)initNetworkStateObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Reachable";
            self.reachbility = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reachbility = NO;
            //blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
}



-(void) setTimerForMessageList{
    NSTimer* timer= [NSTimer timerWithTimeInterval:messageRequestInterval
                            target:self
                          selector:@selector(requestForMessageList)
                          userInfo:nil
                           repeats:YES] ;
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] run];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //有网
        //notificationLabel.text = @"Notification Says Reachable";
        reachbility = YES;
    }
    else
    {
        reachbility = NO;
        //断网
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}

/**
 * @name request
 * @pam1 urlString：the url of the query's destination
 * @pam2 dict:to format the post array of the http .
 * @result return a NSDictionary contains the data what the protocol wo agree to.return nil 代表 联网失败。
 **/
-(NSDictionary *)request:(NSString *)urlString dict:(NSDictionary *)dict{
    
    NSDictionary *response = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //create a request for the http-query.
    //And we set the request type to ignorecache to confirm each time we invoke this function,we
    //acquire the latest data .
    if(!self.reachbility) return nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f ];
    //format the post array
    NSMutableData *postData = [[NSMutableData alloc] init];
    int l = [dict count];
    NSArray *arr = [dict allKeys];
    
    for (int i = 0 ; i < l ; ++i) {
        if(i > 0 ){
            NSString *temp = @"&";
            [postData appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSString *key = [arr objectAtIndex:i];
        NSString *param = [dict objectForKey:key];
        NSString *params = [[NSString alloc]initWithFormat:@"%@=%@",key,param];
        
        [postData appendData:[params dataUsingEncoding:NSUTF8StringEncoding]];
        //        NSLog(@"%@",params);
    }
    
    //set http method and body.
    if (WTF == YES)
        [request setHTTPMethod:@"GET"];
    else
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
    }
    //start the connnection and block the thread.
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    //create the NSDictionary from the json result.
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
        return nil;
    }
    NSString* receivedStr = [NSString stringWithUTF8String:[received bytes]];
    NSLog(@"data %@",receivedStr);
//    if (received != NULL) {
    response = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    //just for Log.
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"received dic %@",str1);
    
//    }
    
    return response;
}

- (void) insertUserInfoToDictionary:(NSMutableDictionary *)dict{
    [dict setObject:PLATFORM forKey:@"platform"];
    [dict setObject:APIVERSION forKey:@"version"];
    
    if ([XXTModelGlobal sharedModel].sessionId != nil){
        [dict setObject:[XXTModelGlobal sharedModel].sessionId forKey:@"sessionKey"];
        [dict setObject:[XXTModelGlobal sharedModel].currentUser.pid forKey:@"userId"];
        [dict setObject:[XXTModelGlobal sharedModel].currentUser.schoolId forKey:@"schoolId"];
        [dict setObject:[XXTModelGlobal sharedModel].currentUser.areaAbbr forKey:@"areaAbbr"];
        [dict setObject:[NSNumber numberWithInt:[XXTModelGlobal sharedModel].currentUser.type] forKey:@"userType"];
    }
}

- (NSString*) getUrlForModule:(NSString *)moduleName WithCmd:(NSString *)cmdStr{
    if (WTF == YES)
        return [NSString stringWithFormat:@"%@/%@/%@",baseUrl,moduleName,cmdStr];
    else
        return [NSString stringWithFormat:@"%@/%@/",baseUrl,moduleName];
}

- (NSInteger) requestForLogin:(NSString *)username password:(NSString *)pwd{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:[NSNumber numberWithInt:[loginCmd intValue]] forKey:@"cmd"];
    [postDic setObject:username forKey:@"account"];
    [postDic setObject:pwd forKey:@"pwd"];
    [postDic setObject:[UIApplication appVersion] forKey:@"appVersion"];
    [postDic setObject:[UIApplication sysVersion] forKey:@"sysVersion"];
    [postDic setObject:@"iOS" forKey:@"platform"];
    [postDic setObject:[UIApplication deviceType] forKey:@"model"];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSString* screenSize = [NSString stringWithFormat:@"%d×%d",(int)screenWidth,(int)screenHeight];
    [postDic setObject:screenSize forKey:@"screenSize"];
    if ([[UIApplication deviceType] isEqualToString:@"Simulator"]){
        [postDic setObject:@"ThisIsSimulator" forKey:@"deviceToken"];
    }
    else{
        if ([XXTModelGlobal sharedModel].deviceToken != nil) {
            //用setObject，如果Object为空会崩...
            [postDic setObject:[XXTModelGlobal sharedModel].deviceToken forKey:@"deviceToken"];
        }
    }
    [postDic setObject:[UIApplication appId] forKey:@"appId"];
    
    NSString* url = [self getUrlForModule:userModuleUrl WithCmd:loginCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController loginSuccess:rs];
    }
    
    return ret;
}

- (NSInteger) requestForLogoff{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:logoffCmd forKey:@"cmd"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:userModuleUrl WithCmd:logoffCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        //TODO save the user message
        [XXTModelController logoffSuccess];
    }
    
    return ret;
}

- (NSInteger) requestForForgetPasswordForAccount:(NSString *)account{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:forgetPwdCmd forKey:@"cmd"];
    [postDic setObject:account forKey:@"account"];
    
    NSString* url = [self getUrlForModule:userModuleUrl WithCmd:forgetPwdCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    return ret;
}

- (NSInteger) requestForDynamicPasswordForAccount:(NSString *)account{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:dynamicPwdCmd forKey:@"cmd"];
    [postDic setObject:account forKey:@"account"];
    
    NSString* url = [self getUrlForModule:userModuleUrl WithCmd:dynamicPwdCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    return ret;
}

- (NSInteger) requestForChangeProfileWithName:(NSString *)name avatar:(XXTImage *)avatar{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:changeProfileCmd forKey:@"cmd"];
    [postDic setObject:name forKey:@"userName"];
    [postDic setObject:avatar.originPicURL forKey:@"avatar"];
    [postDic setObject:avatar.thumbPicURL forKey:@"avatarThumb"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:userModuleUrl WithCmd:forgetPwdCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    return ret;
}

- (NSInteger) requestForChangePasswordForAccount:(NSString *)account
                                     OldPassword:(NSString *)oldPwd
                                    ValidateCode:(NSString *)validCode
                                     NewPassword:(NSString *)newPwd
{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:changePwdCmd forKey:@"cmd"];
    [postDic setObject:account forKey:@"account"];
    if (validCode!=nil)
        [postDic setObject:validCode forKey:@"validCode"];
    if (oldPwd!=nil)
        [postDic setObject:oldPwd forKey:@"oldPwd"];
    [postDic setObject:newPwd forKey:@"newPwd"];
    
    NSString* url = [self getUrlForModule:userModuleUrl WithCmd:changePwdCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    return ret;
}

- (NSInteger) requestForMessageList
{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:messageListCmd forKey:@"cmd"];
    
    NSDate* lastUpdateTime = [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMessageList;
    NSString* lastUpdateTimeString = [NSDate stringValueOfDate:lastUpdateTime];
    [postDic setObject:lastUpdateTimeString forKey:@"updateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:messageModuleUrl WithCmd:messageListCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        NSArray *newMessagesList = [rs objectForKey:@"items"];
        if ([newMessagesList count] > 0)
            [XXTModelController receivedNewMessages:newMessagesList];
        
    }
    
    return ret;
}

- (NSInteger) requestForMessageStatusUpdateWithMessageObjects:(NSArray *)messageObjects{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:messageStatusUpdateCmd forKey:@"cmd"];
    NSMutableArray* msgIdsArr = [NSMutableArray array];
    for (XXTMessageReceive* message in messageObjects){
        [msgIdsArr addObject:message.msgId];
    }
    [postDic setObject:msgIdsArr forKey:@"msgIds"];
    
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:messageModuleUrl WithCmd:messageStatusUpdateCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController ReceiveMessageStatusUpdate:messageObjects];
    }
    
    return ret;
}

- (NSInteger) requestForSendGroupMessage:(XXTMessageSend *)messageToSend{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:sendGroupMessageCmd forKey:@"cmd"];
    
    NSMutableArray* groupIdsItem = [NSMutableArray array];
    for (NSString* groupId in messageToSend.sendToGroupIdArr){
        NSMutableDictionary* groupInfoDic = [NSMutableDictionary dictionary];
        XXTGroup* group = [[XXTModelGlobal sharedModel].currentUser getGroupObjectById:groupId];
        [groupInfoDic setObject:groupId forKey:@"id"];
        [groupInfoDic setObject:[NSNumber numberWithInt:group.groupType] forKey:@"type"];
        [groupIdsItem addObject:groupInfoDic];
    }
    [postDic setObject:groupIdsItem forKey:@"groupIdsItem"];
    
    NSMutableArray* receiverIdsItem = [NSMutableArray array];
    for (NSString* receiverId in messageToSend.sendToPersonIdArr){
        NSMutableDictionary* receiverInfoDic = [NSMutableDictionary dictionary];
        XXTPersonBase* person = [[XXTModelGlobal sharedModel].currentUser getPersonObjectById:receiverId];
        [receiverInfoDic setObject:receiverId forKey:@"id"];
        [receiverInfoDic setObject:[NSNumber numberWithInt:person.type] forKey:@"type"];
        [receiverIdsItem addObject:receiverInfoDic];
    }
    [postDic setObject:receiverIdsItem forKey:@"receiverIdsItem"];
    
    [postDic setObject:messageToSend.content forKey:@"Content"];
    NSMutableArray* imagesArr = [NSMutableArray array];
    for (XXTImage* image in messageToSend.images){
        NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
        [imageDic setObject:image.originPicURL forKey:@"original"];
        [imageDic setObject:image.thumbPicURL forKey:@"thumb"];
        [imagesArr addObject:imageDic];
    }
    [postDic setObject:imagesArr forKey:@"images"];
    
    NSMutableArray* audioArr = [NSMutableArray array];
    for (XXTAudio* audio in messageToSend.audios){
        NSMutableDictionary* audioDic = [NSMutableDictionary dictionary];
        [audioDic setObject:audio.audioURL forKey:@"url"];
        [audioDic setObject:[NSNumber numberWithInt:audio.duration] forKey:@"duration"];
        [audioArr addObject:audioDic];
    }
    [postDic setObject:audioArr forKey:@"audios"];
    
    NSString *url = [self getUrlForModule:messageModuleUrl WithCmd:sendGroupMessageCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController groupMessageSendSuccess:messageToSend WithDictionary:rs];
    }
    
    return ret;
}

- (NSInteger) requestForMessageTemplates{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:messageTemplatesCmd forKey:@"cmd"];
    NSDate* lastUpdateTime = [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMessageTemplates;
    NSString* lastUpdateTimeStr = [NSDate stringValueOfDate:lastUpdateTime];
    [postDic setObject:lastUpdateTimeStr forKey:@"updateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:messageModuleUrl WithCmd:messageTemplatesCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedMessageTemplatesDictionary:rs];
    }
    
    return ret;
}

- (NSInteger) requestForMessageHistoryWithDate:(NSDate *)date isPull:(BOOL)isPull pageSize:(int)pageSize keyword:(NSString *)keyword type:(XXTHistoryType)type{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:messageHistoryCmd forKey:@"cmd"];
    NSString *lastUpdateTimeStr = [NSDate stringValueOfDate:date];
    [postDic setObject:lastUpdateTimeStr forKey:@"dateTime"];
    [postDic setObject:[NSNumber numberWithInt:isPull] forKey:@"isPull"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    if (keyword == nil) keyword = @"";
    [postDic setObject:keyword forKey:@"key"];
    [postDic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:messageModuleUrl WithCmd:messageHistoryCmd];
//    if (WTF)
//        url = @"http://localhost:8888/messageHistory.php";
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedMessageHistoryDictionary:rs];
    }
    
    return ret;
}

- (NSInteger) requestForMessageReceivers:(XXTHistoryMessage *)message{
    int ret = 0;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:getMessageReceiverCmd forKey:@"cmd"];
    [postDic setObject:message.msgId forKey:@"id"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:messageModuleUrl WithCmd:getMessageReceiverCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedMessageHistoryReceiverDic:rs ForMessage:message];
    }
    
    return ret;
}

- (NSInteger) requestForModuleMessages{
    int ret = 0;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:getModuleMessageCmd forKey:@"cmd"];
    NSDate* lastUpdateTime = [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForModuleMessage;
    NSString* lastTimeStr = [NSDate stringValueOfDate:lastUpdateTime];
    [postDic setObject:lastTimeStr forKey:@"updateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:messageModuleUrl WithCmd:getModuleMessageCmd];
    if (WTF)
        url = @"http://localhost:8888/moduleMessage.php";
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedModuleMessageDic:rs];
    }
    
    return ret;
}

- (NSInteger) requestForSendInstantMessage:(XXTMessageSend *)messageToSend{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:sendInstantMessageCmd forKey:@"cmd"];
    
    NSString* receiverId = [messageToSend.sendToPersonIdArr objectAtIndex:0];
    XXTContactPerson* receiver = (XXTContactPerson*)[[XXTModelGlobal sharedModel].currentUser getPersonObjectById:receiverId];
    [postDic setObject:receiverId forKey:@"id"];
    [postDic setObject:[NSNumber numberWithInt:receiver.type] forKey:@"type"];
    
    [postDic setObject:messageToSend.content forKey:@"Content"];
    NSMutableArray* imagesArr = [NSMutableArray array];
    for (XXTImage* image in messageToSend.images){
        NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
        [imageDic setObject:image.originPicURL forKey:@"original"];
        [imageDic setObject:image.thumbPicURL forKey:@"thumb"];
        [imagesArr addObject:imageDic];
    }
    [postDic setObject:imagesArr forKey:@"images"];
    
    NSMutableArray* audioArr = [NSMutableArray array];
    for (XXTAudio* audio in messageToSend.audios){
        NSMutableDictionary* audioDic = [NSMutableDictionary dictionary];
        [audioDic setObject:audio.audioURL forKey:@"url"];
        [audioDic setObject:[NSNumber numberWithInt:audio.duration] forKey:@"duration"];
        [audioArr addObject:audioDic];
    }
    [postDic setObject:audioArr forKey:@"audios"];
    
    NSString *url = [self getUrlForModule:contactsModuleUrl WithCmd:sendInstantMessageCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController instantMessageSendSuccess:messageToSend WithDictionary:rs];
    }
    
    return ret;
}

- (NSInteger) requestForGetContactList{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:getContactListCmd forKey:@"cmd"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:contactsModuleUrl WithCmd:getContactListCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    if (ret == 1){
        NSString* zipUrlStr = [rs objectForKey:@"downUrl"];
        if (zipUrlStr == nil || [zipUrlStr isEqualToString:@""])
            return 404;
        NSURL *zipURL = [NSURL URLWithString:zipUrlStr];
        NSData *data = [NSData  dataWithContentsOfURL:zipURL];
        NSString *fileName = [[zipURL path] lastPathComponent];
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [data writeToFile:filePath atomically:YES];
        NSString *unzipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"linkMan.json"];
        [SSZipArchive unzipFileAtPath:filePath toDestination:NSTemporaryDirectory()];
        NSData* unzipData = [NSData dataWithContentsOfFile:unzipPath];
        
        NSError* error;
        NSArray *groupDicArr = [NSJSONSerialization JSONObjectWithData:unzipData options:NSJSONReadingMutableContainers error:&error];
        
        [XXTModelController receivedContactsListDicArr:groupDicArr];
        
    }
    
    return ret;
}

- (NSInteger) requestForMicroblogsListWithType:(XXTMicroblogCircleType)circleType isPull:(NSInteger)isPull pageSize:(NSInteger)pageSize
{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:microblogsListCmd forKey:@"cmd"];
    [postDic setObject:[NSNumber numberWithInt:circleType] forKey:@"type"];
    NSDate* lastUpdateTime = [[XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForMicroblogListArr objectAtIndex:circleType];
    NSString* lastUpdateTimeString = [NSDate stringValueOfDate:lastUpdateTime];
    [postDic setObject:lastUpdateTimeString forKey:@"updateTime"];
    [postDic setObject:[NSNumber numberWithInt:isPull] forKey:@"isPull"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:microblogsListCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        NSArray* microblogArr = [rs objectForKey:@"items"];
        [XXTModelController receivedMicroblogDics:microblogArr WithType:circleType];
    }
    
    return ret;
}

- (NSInteger) requestForPostMicroblog:(XXTMicroblog *)microblog{
    int ret = 0 ;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postMicroblogCmd forKey:@"cmd"];
    if (microblog.content != nil)
        [postDic setObject:microblog.content forKey:@"content"];
    if ([microblog.images count] > 0){
        NSMutableArray* imagesDicArr = [NSMutableArray array];
        for (XXTImage* image in microblog.images){
            NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
            [imageDic setObject:image.originPicURL forKey:@"original"];
            [imageDic setObject:image.thumbPicURL forKey:@"thumb"];
            [imagesDicArr addObject:imageDic];
        }
        [postDic setObject:imagesDicArr forKey:@"images"];
    }
    if ([microblog.audios count]>0){
        NSMutableArray* audiosDicArr = [NSMutableArray array];
        for (XXTAudio* audio in microblog.audios){
            NSMutableDictionary* audioDic = [NSMutableDictionary dictionary];
            [audioDic setObject:audio.audioURL forKey:@"url"];
            [audioDic setObject:[NSNumber numberWithInt:audio.duration] forKey:@"duration"];
            [audiosDicArr addObject:audioDic];
        }
        [postDic setObject:audiosDicArr forKey:@"audios"];
    }
    
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:postMicroblogCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postMicroblogSuccess:microblog WithDic:rs];
    }
    
    return ret;
}

- (NSInteger) requestForPostComment:(XXTComment*) comment microblog:(XXTMicroblog *)microblog{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postCommentCmd forKey:@"cmd"];
    [postDic setObject:comment.content forKey:@"content"];
    [postDic setObject:microblog.msgId forKey:@"id"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:postCommentCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postCommentSuccess:comment ToMicroblog:microblog WithDic:rs];
    }
    
    return  ret;
}

- (NSInteger) requestForPostLike:(XXTMicroblog *)microblog{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postLikeCmd forKey:@"cmd"];
    [postDic setObject:microblog.msgId forKey:@"id"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:postLikeCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postLikeSuccessToMicroblog:microblog WithDic:rs];
    }
    
    return ret;
}

- (NSInteger) requestForMicroblogDetail:(XXTMicroblog *)microblog{
    int ret = 0 ;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:microblogDetailCmd forKey:@"cmd"];
    [postDic setObject:microblog.msgId forKey:@"id"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:microblogDetailCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController microblogDetail:rs forMicroblog:microblog];
    }
    
    return ret;
}

- (NSInteger) requestForMyCommentAndLikes{
    int ret = 0 ;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:getCommentAndLikesCmd forKey:@"cmd"];
    NSDate* lastUpdateTime = [XXTModelGlobal sharedModel].currentUser.lastUpdateTimeForCommentsAndLikes;
    NSString* lastUpdateTimeString = [NSDate stringValueOfDate:lastUpdateTime];
    [postDic setObject:lastUpdateTimeString forKey:@"updateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:getCommentAndLikesCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController getCommentsAndLikes:[rs objectForKey:@"item"]];
    }
    
    return ret;
}

- (NSInteger) requestForBulletinListWithType:(XXTBulletinType)type
                                      isPull:(int)isPull
                                    pageSize:(int)pageSize
{
    XXTUserRole* currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSDate* lastUpdateTime = [currentUser.lastUpdateTimeForBulletinArr objectAtIndex:type];
    NSString* lastUpdateStr= [NSDate stringValueOfDate:lastUpdateTime];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:bulletinListCmd forKey:@"cmd"];
    [postDic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [postDic setObject:[NSNumber numberWithInt:isPull] forKey:@"isPull"];
    [postDic setObject:lastUpdateStr forKey:@"updateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:bulletinListCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        NSArray* bulletinArr = [rs objectForKey:@"items"];
        [XXTModelController receivedBulletinListDicArr:bulletinArr type:type];
    }
    
    return ret;
}

- (NSInteger) requestForPostBulletin:(XXTBulletin *)bulletin{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postBulletinCmd forKey:@"cmd"];
    [postDic setObject:bulletin.schoolId forKey:@"schoolId"];
    NSString* startDateStr = [NSDate stringValueOfDate:bulletin.startDate];
    [postDic setObject:startDateStr forKey:@"startDate"];
    NSString* endDateStr = [NSDate stringValueOfDate:bulletin.endDate];
    [postDic setObject:endDateStr forKey:@"endDate"];
    [postDic setObject:bulletin.senderId forKey:@"teacherId"];
    [postDic setObject:bulletin.classId forKey:@"classId"];
    [postDic setObject:bulletin.title forKey:@"title"];
    [postDic setObject:bulletin.content forKey:@"content"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:postBulletinCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postBulletinSuccess:bulletin WithDic:rs];
    }
    
    return ret;
}

- (NSInteger) requestForHomeworkListForTime:(NSDate *)dateTime isPull:(int)isPull pageSize:(int)pageSize{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:homeworkListCmd forKey:@"cmd"];
    NSString* lastStr = [NSDate stringValueOfDate:dateTime];
    [postDic setObject:lastStr forKey:@"dateTime"];
    [postDic setObject:[NSNumber numberWithInt:isPull] forKey:@"isPull"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:homeworkListCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedHomeworkListDicArr:[rs objectForKey:@"items"]];
    }
    
    return ret;
}

- (NSInteger) requestForPostHomework:(XXTHomework *)homework{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postHomeworkCmd forKey:@"cmd"];
    [postDic setObject:homework.subjectId forKey:@"subjectId"];
    [postDic setObject:homework.classId forKey:@"classId"];
    [postDic setObject:homework.content forKey:@"content"];
    if (homework.image!=nil){
        [postDic setObject:homework.image.originPicURL forKey:@"original"];
        [postDic setObject:homework.image.thumbPicURL forKey:@"thumb"];
    }
    NSString* dateTimeStr = [NSDate stringValueOfDate:homework.finishTime];
    [postDic setObject:dateTimeStr forKey:@"dateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:postHomeworkCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postHomeworkSuccess:homework WithDic:rs];
    }
    return ret;
}

- (NSInteger) requestForEvaluateListForTime:(NSDate *)dateTime
                                     isPull:(int)isPull
                                   pageSize:(int)pageSize
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:evaluateListCmd forKey:@"cmd"];
    NSString* dateTimeStr = [NSDate stringValueOfDate:dateTime];
    [postDic setObject:dateTimeStr forKey:@"dateTime"];
    [postDic setObject:[NSNumber numberWithInt:isPull] forKey:@"isPull"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:evaluateListCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    if (ret == 1){
        [XXTModelController receivedEvaluateListDicArr:[rs objectForKey:@"items"]];
    }
    
    return ret;
}

- (NSInteger) requestForEvaluateDetail:(XXTEvaluate *)evaluate{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:evaluateDetailCmd forKey:@"cmd"];
    [postDic setObject:evaluate.eid forKey:@"id"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:evaluateDetailCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedEvaluateDetailFor:evaluate PersonDicArr:[rs objectForKey:@"item"]];
    }
    
    return ret;
}

- (NSInteger) requestForEvaluateToPerson:(XXTPersonBase *)person
                                    time:(NSDate *)dateTime
                                  isPull:(int)isPull
                                pageSize:(int)pageSize
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:evaluateHistory2PersonCmd forKey:@"cmd"];
    [postDic setObject:person.pid forKey:@"id"];
    NSString* dateStr = [NSDate stringValueOfDate:dateTime];
    [postDic setObject:dateStr forKey:@"dateTime"];
    [postDic setObject:[NSNumber numberWithInt:isPull] forKey:@"isPull"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:evaluateHistory2PersonCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedEvaluateHistory2Person:person evaluateDicArr:[rs objectForKey:@"items"]];
    }
    
    return ret;
}

- (NSInteger) requestForEvaluateTemplates{
    XXTUserRole *currentUser = [XXTModelGlobal sharedModel].currentUser;
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:evaluateTemplatesCmd forKey:@"cmd"];
    [postDic setObject:currentUser.lastUpdateTimeForEvaluateTemplates forKey:@"updateTime"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:evaluateTemplatesCmd];
    NSDictionary *rs =[self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    if (ret == 1){
        [XXTModelController receivedEvaluateTemplatesWithDic:rs];
    }
    
    return ret;
}

- (NSInteger) requestForPostEvaluate:(XXTEvaluate*) evaluate{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postEvaluateCmd forKey:@"cmd"];
    NSMutableArray* idArr = [NSMutableArray array];
    for (XXTEvaluatedPerson* person in evaluate.evaluatedPersonArr){
        [idArr addObject:person.pid];
    }
    [postDic setObject:idArr forKey:@"id"];
    [postDic setObject:evaluate.content forKey:@"comment"];
    [postDic setObject:[NSNumber numberWithInt:evaluate.rank] forKey:@"rank"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:postEvaluateCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postEvaluateSuccess:evaluate WithDictionary:rs];
    }
    
    return ret;
}

- (NSInteger) requestForQuestionListForSubjectId:(int)subjectId
                                           state:(int)state
                                      questioner:(int)questioner
                                           grade:(int)gradeId
                                            page:(int)page
                                        pageSize:(int)pageSize
{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:questionListCmd forKey:@"cmd"];
    [postDic setObject:[NSNumber numberWithInt:subjectId] forKey:@"id"];
    [postDic setObject:[NSNumber numberWithInt:state] forKey:@"status"];
    [postDic setObject:[NSNumber numberWithInt:questioner] forKey:@"questioner"];
    [postDic setObject:[NSNumber numberWithInt:gradeId] forKey:@"grade"];
    [postDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:questionListCmd];
    NSDictionary *rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    if (ret == 1){
        [XXTModelController receivedQuestionListDicArr:[rs objectForKey:@"items"]];
    }
    
    return ret;
}

- (NSInteger) requestForQuestionDetail:(XXTQuestion *)question{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:questionDetailCmd forKey:@"cmd"];
    [postDic setObject:question.qid forKey:@"id"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:questionDetailCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedQuestionDetailForQuestion:question receivedDic:rs];
    }
    
    return ret  ;
}

- (NSInteger) requestForPostQuestion:(XXTQuestion *)question{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postQuestionCmd forKey:@"cmd"];
    [postDic setObject:question.subjectId forKey:@"id"];
    [postDic setObject:question.content forKey:@"content"];
    
    XXTImage* image = question.qImage;
    if (image != nil){
        NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
        [imageDic setObject:image.originPicURL forKey:@"original"];
        [imageDic setObject:image.thumbPicURL forKey:@"thumb"];
        [postDic setObject:imageDic forKey:@"image"];
    }
    
    XXTAudio* audio =(XXTAudio*)question.qAudios.firstObject;
    if (audio != nil){
        NSMutableDictionary* audioDic = [NSMutableDictionary dictionary];
        [audioDic setObject:audio.audioURL forKey:@"url"];
        [audioDic setObject:[NSNumber numberWithInt:audio.duration] forKey:@"duration"];
        [postDic setObject:audioDic forKey:@"audio"];
    }
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:postQuestionCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postQuestionSuccess:question receivedDict:rs];
    }
    
    return ret;
}

- (NSInteger) requestForPostAnswer:(XXTAnswer *)answer forQuestion:(XXTQuestion *)question{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postAnswerCmd forKey:@"cmd"];
    [postDic setObject:question.qid forKey:@"id"];
    [postDic setObject:question.content forKey:@"content"];
    
    if (answer.aAudios.count > 0){
        NSMutableDictionary* audioDic = [NSMutableDictionary dictionary];
        XXTAudio* audio = (XXTAudio*)answer.aAudios.firstObject;
        [audioDic setObject:audio.audioURL forKey:@"url"];
        [audioDic setObject:[NSNumber numberWithInt:audio.duration] forKey:@"duration"];
        [postDic setObject:audioDic forKey:@"audio"];
    }
    if (answer.aImage != nil){
        NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
        XXTImage* image = answer.aImage;
        [imageDic setObject:image.originPicURL forKey:@"original"];
        [imageDic setObject:image.thumbPicURL forKey:@"thumb"];
        [postDic setObject:imageDic forKey:@"image"];
    }
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:postAnswerCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController postAnswerSuccess:answer];
    }
    
    return ret;
}

- (NSInteger) requestForGradeList{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:gradeListCmd forKey:@"cmd"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:gradeListCmd];
    NSDictionary* rs=[self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController receivedGradeListDicArr:[rs objectForKey:@"items"]];
    }
    
    return ret;
}

- (NSInteger) requestForFeedbackListWithPageNo:(int)page pageSize:(int)pageSize{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:feedbackListCmd forKey:@"cmd"];
    [postDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [postDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString *url = [self getUrlForModule:sysModuleUrl WithCmd:feedbackListCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    if (ret == 1){
        [XXTModelController receivedFeedbackDic:rs] ;
    }
    
    return ret;
}

- (NSInteger)requestForPostFeedback:(NSString *)content{
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:postFeedbackCmd forKey:@"cmd"];
    [postDic setObject:content forKey:@"content"];
    [self insertUserInfoToDictionary:postDic];
    
    NSString* url = [self getUrlForModule:sysModuleUrl WithCmd:postFeedbackCmd];
    NSDictionary* rs = [self request:url dict:postDic];
    
    int ret = [[rs objectForKey:@"resultState"] intValue];
    
    return ret;
}
@end
