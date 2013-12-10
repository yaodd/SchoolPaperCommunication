//
//  XXTAudio.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTObject.h"

@interface XXTAudio : XXTObject

@property (strong,nonatomic)    NSString *audioURL;
@property (nonatomic)           NSInteger duration;
@property (strong,nonatomic)    NSData* audiodata;

@end
