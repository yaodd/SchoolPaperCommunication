//
//  MsgHistoryViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-15.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MsgHistoryViewController.h"
#import "AppDelegate.h"

#define INTERACTION_TYPE_INDEX    0
#define OA_TYPE_INDEX             1

@interface MsgHistoryViewController ()
{
    BOOL isSearching;
}
@end

@implementation MsgHistoryViewController
@synthesize msgHisTableView;
@synthesize searchBar;
@synthesize chooseMsgTypeSC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initLayout];
}
- (void)initLayout{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.frame = SCREEN_RECT;
    } else{
        self.view.frame = CGRectMake(0, 0, SCREEN_RECT.size.width, SCREEN_RECT.size.height - 20);
    }
    isSearching = NO;
    self.msgHisTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT)];
    self.msgHisTableView.dataSource = self;
    self.msgHisTableView.delegate = self;
    [self.msgHisTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.msgHisTableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 88)];
    [headView addSubview:self.searchBar];
    
    NSArray *items = [NSArray arrayWithObjects:@"家校互动短信",@"OA短信",nil];
    chooseMsgTypeSC = [[UISegmentedControl alloc]initWithItems:items];
    [chooseMsgTypeSC addTarget:self action:@selector(chooseMsgTypeAction:) forControlEvents:UIControlEventValueChanged];
    [chooseMsgTypeSC setSelectedSegmentIndex:INTERACTION_TYPE_INDEX];
    [chooseMsgTypeSC setFrame:CGRectMake(6, 50, 308, 29)];
    [chooseMsgTypeSC setWidth:154 forSegmentAtIndex:0];
    [chooseMsgTypeSC setWidth:154 forSegmentAtIndex:1];
    [chooseMsgTypeSC setTintColor:[UIColor colorWithRed:13.0/255 green:152.0/255 blue:219.0/255 alpha:1.0]];
    
    [headView addSubview:chooseMsgTypeSC];
    self.msgHisTableView.tableHeaderView = headView;
    [self.view addSubview:self.msgHisTableView];
    
    
}
- (void)chooseMsgTypeAction:(UISegmentedControl *)segment{
    
}

#pragma UITableViewDelegate mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        
    }
    cell.text = @"test";
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
