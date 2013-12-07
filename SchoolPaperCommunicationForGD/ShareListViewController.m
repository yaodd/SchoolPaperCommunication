//
//  ShareListViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ShareListViewController.h"
#import "AddNewShareViewController.h"
#import "DetailViewController.h"
#define kRefreshFooter 1
#define kRefreshHeader 0
#define kFontOfText @"Heiti SC"
#define kIndexOfClass 0
#define kIndexOfSchool 1
#define kIndexOfTeacher 2
#define kIndexOfHomeSchool 3


@interface ShareListViewController ()

@end

@implementation ShareListViewController
{
    int refreshFlag;
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    CGFloat newContentOffsetY;
    
    CGFloat originY;
    
    UIButton *scopeSelectBtn;
    UILabel *scopeTitle;
    UIImageView *scopeIndicator;
    NSArray *scopeTitleArr;
}
@synthesize tableView = _tableView;
@synthesize userHeadImage;
@synthesize userName;
@synthesize themeImage;
@synthesize seachBar;
@synthesize myMessage;
@synthesize scopeIndex;
@synthesize scopeDropDown;

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
    
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        originY = 66;
    }else{
        originY = 0;
    }
    
    self.title = @"家校圈";
    
    scopeTitleArr = [[NSArray alloc] initWithObjects:@"班圈", @"校圈", @"教师圈", @"家校圈", nil];
    
    [self initViewsOnNavigationBar];
    
    [self initViewsOnTop];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66 + themeImage.frame.size.height, 320, 340)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    _dataArray = [[NSMutableArray alloc] init];
    [self requestData];
    
    [self initHeaderRefresh];
    [self initFooterRefresh];
}

//load views
- (void)initViewsOnNavigationBar
{
    UIButton *customRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customRightBtn.frame = CGRectMake(0, 0, 50, 50);
    [customRightBtn setImage:[UIImage imageNamed:@"create"] forState:UIControlStateNormal];
    [customRightBtn setBackgroundColor:[UIColor colorWithRed:13/255.0 green:152/255.0 blue:219/255.0 alpha:1.0]];
    [customRightBtn addTarget:self action:@selector(addNewShare) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newShareBtn = [[UIBarButtonItem alloc] initWithCustomView:customRightBtn];
    
    self.navigationItem.rightBarButtonItem = newShareBtn;
    
    scopeSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    scopeSelectBtn.backgroundColor = [UIColor colorWithRed:13/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
    [scopeSelectBtn addTarget:self action:@selector(scopeSelectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    scopeSelectBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:22.0];
    scopeSelectBtn.titleLabel.text = @"家校圈";
    scopeSelectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    scopeSelectBtn.titleLabel.textColor = [UIColor whiteColor];
    [scopeSelectBtn setTitle:@"家校圈" forState:UIControlStateNormal];
    
    self.navigationItem.titleView = scopeSelectBtn;
}

- (void)initViewsOnTop{
    themeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 320, 111)];
    themeImage.backgroundColor = [UIColor grayColor];
    [self.view addSubview:themeImage];
    
    seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, originY, 320, 40)];
    seachBar.placeholder = @"搜索";
    seachBar.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:seachBar];
    
    userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 32 + originY, 69, 69)];
    userHeadImage.image = [UIImage imageNamed:@"photo"];
    userHeadImage.layer.masksToBounds = YES;
    userHeadImage.layer.cornerRadius = 34.5f;
    userHeadImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userHeadImage];
    
    userName = [[UILabel alloc] init];
    userName.frame = CGRectMake(100, 104, 100, 24);
    userName.backgroundColor = [UIColor clearColor];
    userName.textAlignment = NSTextAlignmentLeft;
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont fontWithName:kFontOfText size:18.0f];
    userName.shadowOffset = CGSizeMake(1, 1);
    userName.shadowColor = [UIColor blackColor];
    userName.text = @"李小林";
    [self.view addSubview:userName];
    
    myMessage = [[UIButton alloc] initWithFrame:CGRectMake(100, 132, 75, 25.5)];
    myMessage.backgroundColor = [UIColor clearColor];
    [myMessage setImage:[UIImage imageNamed:@"newsbutton"] forState:UIControlStateNormal];
    [myMessage setImage:[UIImage imageNamed:@"newsbutton_click"] forState:UIControlStateSelected];
    [self.view addSubview:myMessage];
}

- (IBAction)scopeSelectBtnPressed:(id)sender
{
    if(scopeDropDown == nil){
        CGFloat height = scopeTitleArr.count * 29.0f;
        scopeDropDown = [[NIDropDown alloc] showDropDown:sender :&height :scopeTitleArr];
        [self.view addSubview:scopeDropDown];
        scopeDropDown.delegate = self;
    }else {
        [scopeDropDown hideDropDown:sender];
        [self dropDownRel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self dropDownRel];
}

-(void)dropDownRel{
    //    [dropDown release];
    scopeDropDown = nil;
}

- (void)requestData
{
    NSArray *arr = @[@"aaa",@"bbb", @"ccc"];
    [_dataArray addObject:arr];
    //sleep(2);
    [self performSelectorOnMainThread:@selector(reloadUI) withObject:nil waitUntilDone:NO];
}

- (void)addNewShare{
    //[self.view setHidden:YES];
    AddNewShareViewController *addNewController = [[AddNewShareViewController alloc] init];
    [self.navigationController pushViewController:addNewController animated:YES];
}

///////////////////////////////
//About the footer refresh View
- (void)initFooterRefresh
{
    if(_refreshFooterView == nil){
        EGORefreshTableFooterView *view = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
        view.delegate = self;
        [_tableView addSubview:view];
        _refreshFooterView = view;
    }
    
    _reloading = NO;
}

- (void)reloadMoreData
{
    NSLog(@"refreshFooterView is reloading!");
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(requestData) toTarget:self withObject:nil];
}

- (void)reloadUI
{
    _reloading = NO;
    
    //停止下拉的动作,恢复表格的便宜
	[_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    //更新界面
    [_tableView reloadData];
    [self setRefreshViewFrame];
    NSLog(@"refreshFooterView end reloading!");
}

-(void)setRefreshViewFrame
{
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(_tableView.bounds.size.height, _tableView.contentSize.height);
    _refreshFooterView.frame =CGRectMake(0.0f, height, self.view.frame.size.width, _tableView.bounds.size.height);
}

#pragma mark - EGORefreshTableFooterDelegate
//出发下拉刷新动作，开始拉取数据
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self reloadMoreData];
}
//返回当前刷新状态：是否在刷新
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _reloading;
}
//返回刷新时间
-(NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}

#pragma mark - UIScrollView

//此代理在scrollview滚动时就会调用
//在下拉一段距离到提示松开和松开后提示都应该有变化，变化可以在这里实现
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    contentOffsetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    newContentOffsetY = scrollView.contentOffset.y;
    
    if(newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY){
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }else if(newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY){
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }else{
    }
}
//松开后判断表格是否在刷新，若在刷新则表格位置偏移，且状态说明文字变化为loading...
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   oldContentOffsetY = scrollView.contentOffset.y;
    
    if(oldContentOffsetY < contentOffsetY){
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }else{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

////////////////////////////////
//About the header refresh View
- (void)initHeaderRefresh
{
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
        view.delegate = self;
        [_tableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)reloadTableViewDataSource{
    
    NSLog(@"refreshHeaderView is reloading!");
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;

}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    [_tableView reloadData];
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    NSLog(@"refreshHeaderView end reloading!");
    
}
/*
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
*/
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma Mark - tableView delegate & datasourse

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [_dataArray count];
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShareListCell";
    ShareListCell *cell = (ShareListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[ShareListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//shareListCell delegate
- (void)jumpToShareDetailDelegate
{
    DetailViewController *controller = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
