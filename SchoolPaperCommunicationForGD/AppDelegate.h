//
//  AppDelegate.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVO.h"

@protocol UserListDelegate;
@protocol ChatDelegate;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) id<UserListDelegate> userListDelegate;
@property (strong, nonatomic) id<ChatDelegate> chatDelegate;

@end


@protocol UserListDelegate <NSObject>
-(void)newBuddyOnline:(NSString *)buddyName;
-(void)buddyWentOffline:(NSString *)buddyName;
-(void)disconnect;
@end

@protocol ChatDelegate <NSObject>
-(void)newMessageReceived:(MessageVO *)aMsgVO;
@end