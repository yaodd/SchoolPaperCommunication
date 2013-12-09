//
//  XXTMessageSend.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/3/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTMessageBase.h"

@interface XXTMessageSend : XXTMessageBase

@property (nonatomic) NSInteger sendCount;
@property (nonatomic) NSInteger sendSuccessCount;
@property (nonatomic) NSInteger readCount;

@property (strong,nonatomic) NSArray* sendToGroupIdArr;
@property (strong,nonatomic) NSArray* sendToPersonIdArr;

- (id) initWithGroupIds:(NSArray*) groupIds
              personIds:(NSArray*) personIds
                content:(NSString *)content
                 images:(NSArray *)imagesArr
                  audio:(NSArray *)audiosArr;

@end
