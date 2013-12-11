//
//  ChooseMassContactViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MassContactView.h"

@interface ChooseMassContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,MassContactViewDelegate>

@property (nonatomic, retain) UITableView *massTableView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *groupHolderArr;

@end
