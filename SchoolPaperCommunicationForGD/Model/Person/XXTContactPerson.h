//
//  XXTContactPerson.h
//  XiaoxuntongModelDemo
//
//  Created by 陈 正梁 on 11/30/13.
//  Copyright (c) 2013 陈 正梁. All rights reserved.
//

#import "XXTPersonBase.h"

@interface XXTContactPerson : XXTPersonBase

@property (strong,nonatomic) NSString* remark; //备注
@property (strong,nonatomic) NSString* phone;
@property (strong,nonatomic) NSString* dialReq;
@property NSInteger messageEnable;

- (XXTContactPerson*) initWithDictionary:(NSDictionary*) dict;

@end
