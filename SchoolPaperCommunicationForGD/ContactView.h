//
//  ContactView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactView : UIView

@property (nonatomic, retain) UIImageView *userHeadIV;
@property (nonatomic, retain) UILabel   *userNameLabel;
@property (nonatomic, retain) UIView    *toolView;
@property (nonatomic, retain) UIButton  *button;
- (void)setData:(NSDictionary *)dict;
@end
