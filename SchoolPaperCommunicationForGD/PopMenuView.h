//
//  PopMenuView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-14.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#define VIEW_X   100
#define VIEW_Y   100
#define VIEW_WIDTH      200
#define VIEW_HEIGHT      300

typedef enum{
    kPopMenuViewTypeSendDynamic = 0,
    kPopMenuViewTypeSendComment = 1,
    kPopMenuViewTypeSendNotice = 2,
    kPopMenuViewTypeSendHomework = 3,
    kPopMenuViewTypeSendMassMsg = 4
} PopMenuType;
@class PopMenuView;

@protocol PopMenuViewDelegate <NSObject>

@optional
- (void)PopMenuViewClickAction:(PopMenuView *)menuView withButton:(UIButton *)button;

@end

@interface PopMenuView : UIView

@property (nonatomic, retain) NSMutableArray *buttonArr;
@property (nonatomic, assign) id <PopMenuViewDelegate> delegate;
- (void)showPopMenu;
- (void)hidePopMenu;
@end
