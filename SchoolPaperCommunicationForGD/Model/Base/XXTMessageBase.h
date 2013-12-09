//
//  XXTMessageBase.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTObject.h"
#import "XXTImage.h"
#import "XXTAudio.h"

@interface XXTMessageBase : XXTObject

@property (copy,nonatomic) NSString* msgId;

@property (strong,nonatomic) NSString* content;
@property (strong,nonatomic) NSArray* images;   //存XXTImage
@property (strong,nonatomic) NSArray* audios;   //存XXTAudio

@property (strong,nonatomic) NSDate* dateTime;

- (id) initWithContent:(NSString*) content
          imageObjects:(NSArray*) imagesArr
          audioObjects:(NSArray*) audiosArr;

@end
