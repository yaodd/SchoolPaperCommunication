//
//  XXTAppUpdateMessage.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/2/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTObject.h"

@interface XXTAppUpdateMessage : XXTObject

@property (strong,nonatomic) NSString* appVersion;
@property (strong,nonatomic) NSString* downloadURL;

@end
