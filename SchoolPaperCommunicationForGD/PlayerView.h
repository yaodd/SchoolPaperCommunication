//
//  PlayerView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-6.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTUserRole.h"

@interface PlayerView : UIView
@property (nonatomic, retain)UIImageView *headImageView;
@property (nonatomic, retain)UILabel     *playerLabel;
@property (nonatomic, retain)XXTUserRole *userRole;
- (id)initWithDefault;

- (void)setData:(XXTUserRole *)role;
@end
