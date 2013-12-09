//
//  XXTModelGlobal.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 12/5/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTObject.h"
#import "XXTUserRole.h"
#import "XXTFeedback.h"

@interface XXTModelGlobal : XXTObject

+ (XXTModelGlobal*) sharedModel;

@property (copy,nonatomic) NSString* sessionId;
@property (copy,nonatomic) NSString* deviceToken;

@property (strong , nonatomic) NSArray* userObjectArr;
@property (strong , nonatomic) XXTUserRole* currentUser;

@property (strong , nonatomic) NSArray* feedbackArr;
@property NSInteger feedbackCount;

-(void) initWithLoginInfoDictionary:(NSDictionary*) infoDic;

@end
