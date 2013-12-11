//
//  ChooseMassContactViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ChooseMassContactViewController.h"
#import "AppDelegate.h"
#import "XXTModelGlobal.h"
#import "Dao.h"
#import "ContactHolder.h"
#import "GroupHolder.h"

#define MASS_CONTACT_VIEW_TAG   111111

@interface ChooseMassContactViewController ()
{
    BOOL isSearching;

}
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; // UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897

@end

@implementation ChooseMassContactViewController
@synthesize massTableView;
@synthesize searchBar;
@synthesize groupHolderArr;

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
    [self initData];
}

- (void)initLayout
{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.frame = SCREEN_RECT;
    } else{
        self.view.frame = CGRectMake(0, 0, SCREEN_RECT.size.width, SCREEN_RECT.size.height - 20);
    }
    
    isSearching = NO;
    self.massTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT)];
    self.massTableView.dataSource = self;
    self.massTableView.delegate = self;
    [self.massTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.massTableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
    self.massTableView.tableHeaderView = self.searchBar;
    self.massTableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
}

- (void)initData{
    
    XXTUserRole *userRole = [XXTModelGlobal sharedModel].currentUser;
    if (userRole.contactGroupArr == nil) {
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadContactGroup:) object:nil];
        [thread start];
        
    } else{
        groupHolderArr = [[NSMutableArray alloc]init];
        for (XXTGroup *group in userRole.contactGroupArr) {
            GroupHolder *groupHolder = [[GroupHolder alloc]init];
            NSMutableArray *contactHolderArr = [[NSMutableArray alloc]init];
            for (XXTContactPerson *contactPerson in group.groupMemberArr) {
                ContactHolder *contactHolder = [[ContactHolder alloc]init];
                [contactHolder setContactPerson:contactPerson];
                [contactHolder setIsChosen:NO];
                [contactHolderArr addObject:contactHolder];
            }
            [groupHolder setContactHolderArr:contactHolderArr];
            [groupHolder setIsExpand:NO];
            [groupHolder setGroupChosenType:GroupChosenTypeNone];
            [groupHolder setGroupName:group.groupName];
            [groupHolderArr addObject:groupHolder];
        }
        [self.massTableView reloadData];
    }
    
}
//下载通讯录
- (void)downloadContactGroup:(NSThread *)thread{
    Dao *dao = [Dao sharedDao];
    NSInteger isSuccess = [dao requestForGetContactList];
    if (isSuccess ==  1) {
        [self performSelectorOnMainThread:@selector(initData) withObject:nil waitUntilDone:YES];//递归回去加载数据
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

#pragma UITableViewDelegate Datasource mark-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [groupHolderArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
	GroupHolder *groupHolder = [groupHolderArr objectAtIndex:section];
    
	UIView *hView;
	if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
        UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
	{
		hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 44)];
	}
	else
	{
		hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
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
	if (groupHolder.isExpand){
		[eButton setImage: [ UIImage imageNamed:@"arrow_open"] forState:UIControlStateNormal];
        [eButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 45.5, 0, 0)];
        [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,  self.view.frame.size.width - 30, 0, 0)];
    }
	else{
		[eButton setImage: [ UIImage imageNamed:@"arrow_close"] forState:UIControlStateNormal];
        [eButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 50, 0, 0)];
        [eButton setImageEdgeInsets:UIEdgeInsetsMake(5, self.view.frame.size.width - 25.5, 0, 0)];

    }
    
	//由于按钮的标题，
	//4个参数是上边界，左边界，下边界，右边界。
	eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//	[eButton setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 0, 0)];
    
    
	//设置按钮显示颜色
	eButton.backgroundColor = [UIColor lightGrayColor];
	[eButton setTitle:groupHolder.groupName forState:UIControlStateNormal];
	[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [eButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
	[eButton setBackgroundColor:[UIColor whiteColor]];
	[hView addSubview: eButton];
    
    UIView *sepector = [[UIView alloc]initWithFrame:CGRectMake(0, 43, hView.frame.size.width, 1)];
    [sepector setBackgroundColor:[UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0]];
    
    [hView addSubview:sepector];
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:CGRectMake(15, 9.5, 25, 25)];
    [chooseButton setTag:section];
    [chooseButton addTarget:self action:@selector(chooseGroupAction:) forControlEvents:UIControlEventTouchDown];
    if (groupHolder.groupChosenType == GroupChosenTypeNone) {
        [chooseButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    } else if(groupHolder.groupChosenType == GroupChosenTypeSome){
        [chooseButton setImage:[UIImage imageNamed:@"someselected"] forState:UIControlStateNormal];
    } else if (groupHolder.groupChosenType == GroupChosenTypeAll){
        [chooseButton setImage:[UIImage imageNamed:@"allselected"] forState:UIControlStateNormal];
    }
    [hView addSubview:chooseButton];

    UIColor *orangeColor = [UIColor colorWithRed:251.0/255 green:131.0/255 blue:9.0/255 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:147.0/255 green:202.0/255 blue:0 alpha:1.0];
    UIColor *textColor = [[UIColor alloc]init];
    NSString *textStr = [[NSString alloc]init];
    //统计选中数.
    int chosenCount = 0;
    for (ContactHolder *contactHolder in groupHolder.contactHolderArr) {
        if (contactHolder.isChosen) {
            chosenCount++;
        }
    }
    if (chosenCount == [groupHolder.contactHolderArr count]) {
        textColor = orangeColor;
        textStr = [NSString stringWithFormat:@"全选%d人",chosenCount];
    } else if (chosenCount == 0){
        textStr = [NSString stringWithFormat:@""];
    } else{
        textColor = greenColor;
        textStr = [NSString stringWithFormat:@"已选%d人",chosenCount];
    }

    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30 - 100, 16, 90, 14)];
    [numLabel setTextAlignment:NSTextAlignmentRight];
    [numLabel setFont:[UIFont systemFontOfSize:12]];
        [numLabel setText:textStr];
    [numLabel setTextColor:textColor];
    
    [hView addSubview:numLabel];
    
	return hView;
    
}
//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
	
	UIButton* btn= (UIButton*)sender;
	NSInteger section= btn.tag; //取得tag知道点击对应哪个块
	
	//	NSLog(@"click %d", section);
	[self collapseOrExpand:section];
	
	//刷新tableview
	[massTableView reloadData];
	
}
-(void)collapseOrExpand:(int)section{
	BOOL expanded = NO;
	//Boolean searched = NO;
    GroupHolder *groupHolder = [groupHolderArr objectAtIndex:section];
	
	//若本节model中的“expanded”属性不为空，则取出来
    expanded=groupHolder.isExpand;
	
	//若原来是折叠的则展开，若原来是展开的则折叠
	[groupHolder setIsExpand:![groupHolder isExpand]];
    
}
//单组选择全部响应
- (void)chooseGroupAction:(UIButton *)button
{
    NSInteger section = button.tag;
    GroupHolder *groupHolder = [groupHolderArr objectAtIndex:section];
    GroupChosenType type = groupHolder.groupChosenType;
    GroupChosenType curType;
    if (type == GroupChosenTypeNone || type == GroupChosenTypeSome) {
        [button setImage:[UIImage imageNamed:@"allselected"] forState:UIControlStateNormal];
        curType = GroupChosenTypeAll;       //如果一个都没选或者选择一部分，则全选
    }else {
        [button setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        curType = GroupChosenTypeNone;      //如果全选了，则取消全选
    }
    [groupHolder setGroupChosenType:curType];
    [self chooseOneGroup:section];
    
}
//选择或取消选择全部
- (void)chooseOneGroup:(int)section
{
    GroupHolder *groupHolder = [groupHolderArr objectAtIndex:section];
    for (ContactHolder *contactHolder in groupHolder.contactHolderArr) {
        GroupChosenType type = groupHolder.groupChosenType;
        if (type == GroupChosenTypeAll) {
            contactHolder.isChosen = YES;
        } else{
            contactHolder.isChosen = NO;
        }
    }
    [self.massTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    GroupHolder *groupHolder = [groupHolderArr objectAtIndex:section];
    if (groupHolder.isExpand) {
        number = [groupHolder.contactHolderArr count];
    } else{
        number = 0;
    }
    return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        MassContactView *massContactView = [[MassContactView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        massContactView.delegate = self;
        [massContactView setTag:MASS_CONTACT_VIEW_TAG];
        [cell addSubview:massContactView];
        
    }
    MassContactView *massContactView = (MassContactView *)[cell viewWithTag:MASS_CONTACT_VIEW_TAG];
    GroupHolder *groupHolder = [groupHolderArr objectAtIndex:indexPath.section];
    [massContactView setDataWithContactHolder:groupHolder indexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupHolder *groupHolder = [groupHolderArr objectAtIndex:indexPath.section];
    ContactHolder *contactHolder = [groupHolder.contactHolderArr objectAtIndex:indexPath.row];
    BOOL isChosen = contactHolder.isChosen;
    [contactHolder setIsChosen:!isChosen];
    GroupChosenType curType;
    int chosenCount = 0;
    for (ContactHolder *contactHolder in groupHolder.contactHolderArr) {
        if (contactHolder.isChosen) {
            chosenCount ++;
        }
    }
    if (chosenCount == [groupHolder.contactHolderArr count]) {
        curType = GroupChosenTypeAll;
    } else if(chosenCount == 0){
        curType = GroupChosenTypeNone;
    } else{
        curType = GroupChosenTypeSome;
    }
    groupHolder.groupChosenType = curType;
    [self.massTableView reloadData];

}
#pragma MassContactViewDelegate mark
- (void)MassContactView:(MassContactView *)massContactView withIndexPath:(NSIndexPath *)indexPath{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
