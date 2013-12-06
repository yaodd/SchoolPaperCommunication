//
//  UIImageView+category.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTPersonBase.h"

@interface UIImageView (category)
@property (nonatomic, retain)XXTPersonBase *myPerson;
//- (void)setImageWithUrl:(NSURL *)url person:(XXTPersonBase *)person;
- (void)setImageWithPerson:(XXTPersonBase *)person;
@end
