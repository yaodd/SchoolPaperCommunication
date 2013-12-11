//
//  TemplateHolder.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXTMessageTemplate.h"

@interface TemplateHolder : NSObject
@property (nonatomic, retain) XXTMessageTemplate *messageTemplate;
@property (nonatomic, assign) BOOL isExpanded;
@end
