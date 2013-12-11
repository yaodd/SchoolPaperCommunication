//
//  MassContactView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-13.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupHolder.h"
#import "ContactHolder.h"

@class MassContactView;
@protocol MassContactViewDelegate <NSObject>

@required
- (void)MassContactView:(MassContactView *)massContactView withIndexPath:(NSIndexPath *)indexPath;

@end

@interface MassContactView : UIView
@property (nonatomic, retain)UIButton *chooseButton;
@property (nonatomic, retain)UILabel  *nameLabel;
@property (nonatomic, retain)GroupHolder *groupHolder;
@property (nonatomic, retain)ContactHolder *contactHolder;
@property (nonatomic, retain)NSIndexPath   *indexPath;
@property (nonatomic, retain)UIView *sepector;
@property (nonatomic, assign) id<MassContactViewDelegate> delegate;
- (void)setDataWithContactHolder:(GroupHolder *)holder indexPath:(NSIndexPath *)indexPath;
@end
