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
@interface Dao ()

-(void)initNetworkStateObserver;
-(void)reachabilityChanged:(NSNotification*)note;
-(NSDictionary *)request:(NSString *)urlString dict:(NSDictionary *)dict;
-(void)insertUserInfoToDictionary:(NSMutableDictionary*) dict;

@end

@implementation Dao

@synthesize reachbility;

//此处为基本ip地址
NSString *baseUrl = @"http://localhost:8888/index.php";

//此处为基本操作码
#define loginCmd                @"10011"

#define messageListCmd          @"10021"
#define messageStatusUpdateCmd  @"10022"
#define sendGroupMessageCmd     @"10023"

#define sendInstantMessageCmd   @"10031"
#define getContactListCmd       @"10032"


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
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    //start the connnection and block the thread.
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    //create the NSDictionary from the json result.
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
        return nil;
    }
    NSLog(@"data %@",received);
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
    
    if ([XXTUser sharedUser].sessionId != nil){
        [dict setObject:[XXTUser sharedUser].sessionId forKey:@"sessionKey"];
        [dict setObject:[XXTUser sharedUser].pid forKey:@"userId"];
        [dict setObject:[XXTUser sharedUser].schoolId forKey:@"schoolId"];
        [dict setObject:[XXTUser sharedUser].areaAbbr forKey:@"areaAbbr"];
        [dict setObject:[NSNumber numberWithInt:[XXTUser sharedUser].type] forKey:@"userType"];
    }
}

- (NSInteger) requestForLogin:(NSString *)username password:(NSString *)pwd{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:loginCmd forKey:@"cmd"];
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
//    [postDic setObject:[XXTUser sharedUser].deviceToken forKey:@"deviceToken"];
    [postDic setObject:[UIApplication appId] forKey:@"appId"];
    
    NSDictionary* rs = [self request:baseUrl dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [self performSelectorInBackground:@selector(setTimerForMessageList) withObject:nil];
        [XXTModelController loginSuccess:rs];
    }
    
    return ret;
}

- (NSInteger) requestForMessageList
{
    int ret = 0;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:messageListCmd forKey:@"cmd"];
    
    NSString* lastUpdateTimeString;
    NSDate* lastUpdateTime = [XXTUser sharedUser].lastUpdateTimeForMessageList;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-mm-dd hh:mm:ss"];
    if (lastUpdateTime == nil){
        lastUpdateTimeString = @"";
    }
    else{
        lastUpdateTimeString = [formatter stringFromDate:lastUpdateTime];
    }
    
    [dict setObject:lastUpdateTimeString forKey:@"updateTime"];
    [self insertUserInfoToDictionary:dict];
    
    NSDictionary *rs = [self request:baseUrl dict:dict];
    
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
    
    NSDictionary *rs = [self request:baseUrl dict:postDic];
    
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
        XXTGroup* group = [[XXTUser sharedUser] getGroupObjectById:groupId];
        [groupInfoDic setObject:groupId forKey:@"id"];
        [groupInfoDic setObject:[NSNumber numberWithInt:group.groupType] forKey:@"type"];
        [groupIdsItem addObject:groupInfoDic];
    }
    [postDic setObject:groupIdsItem forKey:@"groupIdsItem"];
    
    NSMutableArray* receiverIdsItem = [NSMutableArray array];
    for (NSString* receiverId in messageToSend.sendToPersonIdArr){
        NSMutableDictionary* receiverInfoDic = [NSMutableDictionary dictionary];
        XXTPersonBase* person = [[XXTUser sharedUser] getPersonObjectById:receiverId];
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
    
    NSDictionary *rs = [self request:baseUrl dict:postDic];
    
    ret = [[rs objectForKey:@"resultState"] intValue];
    
    if (ret == 1){
        [XXTModelController groupMessageSendSuccess:messageToSend WithDictionary:rs];
    }
    
    return ret;
}

- (NSInteger) requestForSendInstantMessage:(XXTMessageSend *)messageToSend{
    int ret = 0;
    
    NSMutableDictionary* postDic = [NSMutableDictionary dictionary];
    [postDic setObject:sendInstantMessageCmd forKey:@"cmd"];
    
    NSString* receiverId = [messageToSend.sendToPersonIdArr objectAtIndex:0];
    XXTContactPerson* receiver = (XXTContactPerson*)[[XXTUser sharedUser] getPersonObjectById:receiverId];
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
    
    NSDictionary *rs = [self request:baseUrl dict:postDic];
    
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
    
    
    
    return ret;
}


@end
