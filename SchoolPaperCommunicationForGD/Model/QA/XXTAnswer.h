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
@property (strong , nonatomic) NSArray* aAudios;
@property (copy , nonatomic) NSString* answererName;
@property (strong , nonatomic) XXTImage* answererAvatar;
@property (copy , nonatomic) NSDate* dateTime;
@property BOOL isSended;

- (XXTAnswer*) initWithDicitionary:(NSDictionary*) dict;
- (XXTAnswer*) initNewAnswer:(NSString*) content image:(XXTImage*)image audio:(XXTAudio*) audio;

@end
