//
//  addNewShareViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewShareViewController : UIViewController<UITextViewDelegate>
@property (nonatomic, retain) UITextView *shareContent;
@property (nonatomic, retain) UIImageView *shareImage;
@property (nonatomic, retain) UIButton *addPhoto;
@end
