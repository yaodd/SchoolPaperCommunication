//
//  ContactsViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ViewController.h"

@interface ContactsViewController : ViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated; 
@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property(nonatomic, strong) UISearchBar *searchBar;

@end
