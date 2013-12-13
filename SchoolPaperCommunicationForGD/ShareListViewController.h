//
//  ShareListViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "NIDropDown.h"
#import "ShareListCell.h"

@interface ShareListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NIDropDownDelegate, ShareListCellDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;

}
//navigation part
@property (nonatomic, retain) NIDropDown *scopeDropDown;
//below part
@property (nonatomic, retain) UITableView *tableView;
//top part
@property (nonatomic, retain) UIImageView *themeImage;
@property (nonatomic, retain) UISearchBar *seachBar;
@property (nonatomic, retain) UIImageView *userHeadImage;
@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UIButton *myMessage;
@property (nonatomic) NSInteger scopeIndex;

@end
