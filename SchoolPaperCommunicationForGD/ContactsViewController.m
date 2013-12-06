//
//  ContactsViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ContactsViewController.h"
#import "ChatViewController.h"
#import "ContactView.h"
#import "XXTUserRole.h"
#import "XXTModelGlobal.h"
#import "Dao.h"

#define CONTACT_VIEW_TAG    111111

@interface ContactsViewController ()
{
    CGFloat tableViewY;
    NSMutableArray *data;
}
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; // UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897
@property(nonatomic, copy) NSArray *famousPersons;
@property(nonatomic, copy) NSArray *filteredPersons;
@property(nonatomic, copy) NSArray *sections;

@end

@implementation ContactsViewController
@synthesize contactsTableView;
@synthesize searchBar;

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
    // Do any additional setup after loading the view.
    tableViewY = 0;
    if (IOS_VERSION_7_OR_ABOVE)
    {
        // OS version >= 7.0
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        tableViewY = 0;
        
    }else{
        tableViewY = 49;
    }
    [self iniTableView];
    [self initData];
//    [self.contactsTableView reloadData];
}
//初始化tableView
- (void)iniTableView{
    self.contactsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - tableViewY - TOP_BAR_HEIGHT)];
    self.contactsTableView.dataSource = self;
    self.contactsTableView.delegate = self;
    [self.view addSubview:self.contactsTableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
    self.contactsTableView.tableHeaderView = self.searchBar;
    self.contactsTableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
}
//初始化数据加载
- (void)initData{
    XXTModelGlobal *modelGlobal = [XXTModelGlobal sharedModel];
    XXTUserRole *userRole = modelGlobal.currentUser;
    if ([userRole.contactGroupArr count] == 0) {
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadContactGroup:) object:nil];
        [thread start];

    }
    
    [self updateContactGroup];
}
//下载通讯录
- (void)downloadContactGroup:(NSThread *)thread{
    Dao *dao = [Dao sharedDao];
    int isSuccess = [dao requestForGetContactList];
    if (isSuccess ==  1) {
        [self performSelectorOnMainThread:@selector(updateContactGroup) withObject:nil waitUntilDone:YES];
    }

}
//更新通讯录
- (void)updateContactGroup{
    XXTModelGlobal *modelGlobal = [XXTModelGlobal sharedModel];
    XXTUserRole *userRole = modelGlobal.currentUser;
    data = [[NSMutableArray alloc]init];

    for (XXTGroup *group in userRole.contactGroupArr) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:group.groupName forKey:@"groupname"];
        NSLog(@"groupname %@",group.groupName);
        NSArray *groupMemberArr = group.groupMemberArr;
        [dict setObject:groupMemberArr forKey:@"users"];
        [data addObject:dict];
    }
    [contactsTableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (animated) {
//        [self.contactsTableView flashScrollIndicators];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma UITableViewDelegate mark -

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
//    NSAssert(YES, @"This method should be handled by a subclass!");
    [self.contactsTableView scrollRectToVisible:self.searchBar.frame animated:animated];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [data count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 0;
    if (![self isExpanded:section]) {
        num = 0;
    } else{
        NSDictionary * d = [data objectAtIndex:section];
        num = [[d objectForKey:@"users"] count];
        
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        ContactView *contactView = [[ContactView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 62)];
        [contactView setTag:CONTACT_VIEW_TAG];
        [cell addSubview:contactView];
    }
    ContactView *contactView = (ContactView *)[cell viewWithTag:CONTACT_VIEW_TAG];
    NSDictionary* item= (NSDictionary*)[data objectAtIndex: indexPath.section];
	NSArray *users = (NSArray*)[item objectForKey:@"users"];
    
	if (users == nil) {
		return cell;
	}
	//加载数据
    XXTContactPerson *user = [users objectAtIndex:indexPath.row];
    [contactView setData:user];
	[cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.hidesBottomBarWhenPushed = YES;
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
//    ChatViewController *chatViewController = [[ChatViewController alloc]init];
    
    [self.navigationController pushViewController:chatViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
	
    
	UIView *hView;
	if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
        UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
	{
		hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 40)];
	}
	else
	{
		hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        //self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
	}
    //UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
	UIButton* eButton = [[UIButton alloc] init];
    
	//按钮填充整个视图
	eButton.frame = hView.frame;
	[eButton addTarget:self action:@selector(expandButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
	eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
	//根据是否展开，切换按钮显示图片
	if ([self isExpanded:section])
		[eButton setImage: [ UIImage imageNamed: @"btn_down.png" ] forState:UIControlStateNormal];
	else
		[eButton setImage: [ UIImage imageNamed: @"btn_right.png" ] forState:UIControlStateNormal];
    
    
	//由于按钮的标题，
	//4个参数是上边界，左边界，下边界，右边界。
	eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[eButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
	[eButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    
    
	//设置按钮显示颜色
	eButton.backgroundColor = [UIColor lightGrayColor];
	[eButton setTitle:[[data objectAtIndex:section] objectForKey:@"groupname"] forState:UIControlStateNormal];
	[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	[eButton setBackgroundImage: [ UIImage imageNamed: @"btn_listbg.png" ] forState:UIControlStateNormal];//btn_line.png"
	//[eButton setTitleShadowColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
	//[eButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    
	[hView addSubview: eButton];
    
	return hView;
    
}


//对指定的节进行“展开/折叠”操作
-(void)collapseOrExpand:(int)section{
	Boolean expanded = NO;
	//Boolean searched = NO;
	NSMutableDictionary* d=[data objectAtIndex:section];
	
	//若本节model中的“expanded”属性不为空，则取出来
	if([d objectForKey:@"expanded"]!=nil)
		expanded=[[d objectForKey:@"expanded"]intValue];
	
	//若原来是折叠的则展开，若原来是展开的则折叠
	[d setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
    
}


//返回指定节的“expanded”值
-(Boolean)isExpanded:(int)section{
	Boolean expanded = NO;
	NSMutableDictionary* d=[data objectAtIndex:section];
	
	//若本节model中的“expanded”属性不为空，则取出来
	if([d objectForKey:@"expanded"]!=nil)
		expanded=[[d objectForKey:@"expanded"]intValue];
	
	return expanded;
}


//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
	
	UIButton* btn= (UIButton*)sender;
	int section= btn.tag; //取得tag知道点击对应哪个块
	
	//	NSLog(@"click %d", section);
	[self collapseOrExpand:section];
	
	//刷新tableview
	[contactsTableView reloadData];
	
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.filteredPersons = self.famousPersons;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.filteredPersons = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.filteredPersons = [self.filteredPersons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
    
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([[segue identifier] isEqualToString:@"JumpToChat"]) {
    NSLog(@"ssss");
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
//    }x
}

@end
