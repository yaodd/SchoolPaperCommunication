//
//  MsgHistoryViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-15.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgHistoryViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) UITableView *msgHisTableView;
@property (nonatomic ,retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISegmentedControl *chooseMsgTypeSC;
@end
