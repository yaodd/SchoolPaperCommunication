//
//  ContactView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTContactPerson.h"
#define PHONE_BUTTON_TAG    0
#define MESSAGE_BUTTON_TAG  1
#define CHAT_BUTTON_TAG     2

@class ContactView;
@protocol ContactViewDelegate <NSObject>

@optional
- (void)ContactViewButtonAction:(ContactView *)contactView button:(UIButton *)button person:(XXTContactPerson *)person;

@end

@interface ContactView : UIView

@property (nonatomic, retain) UIImageView *userHeadIV;
@property (nonatomic, retain) UILabel   *userNameLabel;
@property (nonatomic, retain) UIButton  *phoneButton;
@property (nonatomic, retain) UIButton  *msgButton;
@property (nonatomic, retain) UIButton  *toolButton;
@property (nonatomic, retain) UIButton  *chatButton;
@property (nonatomic, retain) UILabel   *phoneLabel;
@property (nonatomic, assign) id<ContactViewDelegate> delegate;
//@property (nonatomic, retain) NSMutableDictionary *myDict;
@property (nonatomic, retain) XXTContactPerson *contactPerson;
- (void)setData:(XXTContactPerson *)person;
@end
