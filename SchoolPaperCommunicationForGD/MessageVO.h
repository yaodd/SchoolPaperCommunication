//
//  MessageVO.h
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/26/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kMsgMode_Receive=0,
    kMsgMode_Send,
    
}MsgMode;
typedef enum
{
    kMsgType_Text,
    kMsgType_Audio,
    kMsgType_Image
}MsgType;

@interface MessageVO : NSObject

@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strText;//消息内容，三选一
@property (nonatomic, retain) UIImage *image;//消息内容，三选一
@property (nonatomic, retain) NSURL *audioUrl;//消息内容，三选一
@property (nonatomic, assign) NSInteger audioTime;
@property (nonatomic, copy) NSString *strUserid;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strFromUsername;
@property (nonatomic, copy) NSString *strToUsername;
@property (nonatomic, assign)MsgType msgType;
@property (nonatomic, assign)MsgMode msgMode;
@end
