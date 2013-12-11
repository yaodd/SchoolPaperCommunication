//
//  ChooseTemplateViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateView.h"
#import "XXTMessageTemplate.h"
@class ChooseTemplateViewController;

@protocol ChooseTemplateControllerDelegate <NSObject>

@optional

- (void)ChooseTemplateController:(ChooseTemplateViewController *)controller passBackWithTemplate:(XXTMessageTemplate *)msgTemplate;

@end


@interface ChooseTemplateViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TemplateViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic, retain) UITableView *templateTableView;
@property (nonatomic ,retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISegmentedControl *chooseTempTypeSC;
@property (nonatomic, retain) NSMutableArray *displayTempArr;
@property (nonatomic, retain) NSMutableArray *offenUseTempArr;
@property (nonatomic, retain) NSMutableArray *recommendedTempArr;
@property (nonatomic, retain) NSMutableArray *allTempArr;
@property (nonatomic, retain) XXTMessageTemplate *choosenTemp;
@property (nonatomic, assign) id<ChooseTemplateControllerDelegate>delegate;


@end
