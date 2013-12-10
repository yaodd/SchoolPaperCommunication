//
//  XXTAnswer.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/8/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTImage.h"
#import "XXTAudio.h"

@interface XXTAnswer : XXTObject

@property (copy , nonatomic) NSNumber* aid;
@property (copy , nonatomic) NSString* content;
@property (strong , nonatomic) XXTImage* aImage;
@property (strong , nonatomic) XXTAudio* aAudio;
@property (copy , nonatomic) NSString* answererName;
@property (strong , nonatomic) XXTImage* answererAvatar;

- (XXTAnswer*) initWithDicitonary:(NSDictionary*) dict;

@end
