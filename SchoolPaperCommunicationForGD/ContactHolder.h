//
//  ContactHolder.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-13.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTContactPerson.h"

@interface ContactHolder : NSObject

@property (nonatomic) BOOL isChosen;
@property (nonatomic, retain) XXTContactPerson *contactPerson;
@end
