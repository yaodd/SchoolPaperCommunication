//
//  ContactView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTContactPerson.h"



@interface ContactView : UIView

@property (nonatomic, retain) UIImageView *userHeadIV;
@property (nonatomic, retain) UILabel   *userNameLabel;
@property (nonatomic, retain) UIView    *toolView;
@property (nonatomic, retain) UIButton  *showButton;
@property (nonatomic, retain) UIButton  *hideButton;
@property (nonatomic, retain) UIButton  *phoneButton;
@property (nonatomic, retain) UIButton  *msgButton;
@property (nonatomic, retain) UIButton  *chatButton;
@property (nonatomic, retain) UIButton  *deleteButton;
//@property (nonatomic, retain) NSMutableDictionary *myDict;
@property (nonatomic, retain) XXTContactPerson *contactPerson;
- (void)setData:(XXTContactPerson *)person;
@end
