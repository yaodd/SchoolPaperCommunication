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
#import "XXTModelGlobal.h"
#define kRefreshFooter 1
#define kRefreshHeader 0
#define kFontOfText @"Heiti SC"
#define kIndexOfMine 0
#define kIndexOfClass 1
#define kIndexOfTeacher 2
#define kIndexOfSchool 3


@interface ShareListViewController ()

@end

@implementation ShareListViewController
{
    BOOL isIOS7;
    
    int refreshFlag;
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    CGFloat newContentOffsetY;
    
    CGFloat originY;
    NSInteger contentHeight;
    
    UIButton *scopeSelectBtn;
    UILabel *scopeTitle;
    UIImageView *scopeIndicator;
    NSDictionary *scopeTitleArr;
    
    Dao *dao;
    
    XXTMicroblogCircleType blogCircleType;
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
    //Get the size of screen and the version of system
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    CGRect screenFrame =  [[UIScreen mainScreen] bounds];
    NSLog(@"%ld", (long)screenFrame.size.height);
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        originY = 64;
        isIOS7 = YES;
        contentHeight = screenFrame.size.height - 64;
    }else{
        originY = 0;
        isIOS7 = NO;
        contentHeight = screenFrame.size.height - 44;
    }
    
    scopeIndex = kIndexOfSchool;
    blogCircleType = XXTMicroblogCircleTypeSchool;
    
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInt:kIndexOfMine], [NSNumber numberWithInt:kIndexOfClass], [NSNumber numberWithInt:kIndexOfTeacher], [NSNumber numberWithInt:kIndexOfSchool], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"我的分享", @"班圈", @"教师圈", @"学校圈", nil];
    
    scopeTitleArr = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    [self initViewsOnNavigationBar];
    
    [self initViewsOnTop];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY + themeImage.frame.size.height, 320, contentHeight-111-49)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self initHeaderRefresh];
    [self initFooterRefresh];
    
    NSThread *loadDataThread = [[NSThread alloc] initWithTarget:self selector:@selector(reloadTableViewOldDataSource) object:nil];
    [loadDataThread start];
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
    scopeSelectBtn.titleLabel.text = @"学校圈";
    scopeSelectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    scopeSelectBtn.titleLabel.textColor = [UIColor whiteColor];
    [scopeSelectBtn setTitle:@"学校圈" forState:UIControlStateNormal];
    
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
    userName.frame = CGRectMake(100, 42+originY, 100, 24);
    userName.backgroundColor = [UIColor clearColor];
    userName.textAlignment = NSTextAlignmentLeft;
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont fontWithName:kFontOfText size:18.0f];
    userName.shadowOffset = CGSizeMake(1, 1);
    userName.shadowColor = [UIColor blackColor];
    userName.text = @"李小林";
    [self.view addSubview:userName];
    
    myMessage = [[UIButton alloc] initWithFrame:CGRectMake(100, 70+originY, 75, 25.5)];
    myMessage.backgroundColor = [UIColor clearColor];
    [myMessage setImage:[UIImage imageNamed:@"newsbutton"] forState:UIControlStateNormal];
    [myMessage setImage:[UIImage imageNamed:@"newsbutton_click"] forState:UIControlStateSelected];
    [self.view addSubview:myMessage];
}

- (IBAction)scopeSelectBtnPressed:(id)sender
{
    if(scopeDropDown == nil){
        CGFloat height = scopeTitleArr.count * 29.0f;
        scopeDropDown = [[NIDropDown alloc] showDropDown:sender :&height :scopeTitleArr.allKeys];
        [self.view addSubview:scopeDropDown];
        scopeDropDown.delegate = self;
    }else {
        [scopeDropDown hideDropDown:sender];
        [self dropDownRel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSString *title = scopeSelectBtn.titleLabel.text;
    NSLog(@"查看家校圈范围-----%@", title);
    
    scopeIndex = [[scopeTitleArr objectForKey:title] intValue];
    switch (scopeIndex) {
        case kIndexOfMine:
            blogCircleType = XXTMicroblogCircleTypeMine;
            break;
            
        case kIndexOfClass:
            blogCircleType = XXTMicroblogCircleTypeClass;
            break;
        
        case kIndexOfTeacher:
            blogCircleType = XXTMicroblogCircleTypeTeacher;
            break;
            
        case kIndexOfSchool:
            blogCircleType = XXTMicroblogCircleTypeSchool;
            break;
            
        default:
            break;
    }

    [self dropDownRel];
}

-(void)dropDownRel{
    //    [dropDown release];
    scopeDropDown = nil;
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

- (void)reloadTableViewOldDataSource
{
    NSLog(@"refreshFooterView is reloading!");
    
    dao = [Dao sharedDao];
    NSInteger state = [dao requestForMicroblogsListWithType:blogCircleType isPull:0 pageSize:20];
    //返回值state为0时表示读取数据失败，1时为读取数据成功
    NSLog(@"requst state - %d", (int)state);
    
    //从后台读取数据后将其赋值到本地成员变量上
    NSArray *arr = [[XXTModelGlobal sharedModel].currentUser.microblogsArrOfArr objectAtIndex:blogCircleType];
    _dataArray = arr;
    
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(doneLoadingOldTableViewData) toTarget:self withObject:nil];
}

- (void)doneLoadingOldTableViewData
{
    _reloading = NO;
    
	[_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    //更新界面
    [_tableView reloadData];
    
    //更新完列表后调整底部刷新控件的位置
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
    //新建线程处理读取后台数据
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(reloadTableViewOldDataSource) object:nil];
    [thread start];
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

- (void)reloadTableViewNewDataSource{
    
    NSLog(@"refreshHeaderView is reloading!");

    dao = [Dao sharedDao];
    NSInteger state = [dao requestForMicroblogsListWithType:XXTMicroblogCircleTypeSchool isPull:1 pageSize:50];
    //返回值state为0时表示读取数据失败，1时为读取数据成功
    NSLog(@"requst state--%d", (int)state);
    
    //从后台读取数据后将其赋值到本地成员变量上
    NSArray *arr = [[XXTModelGlobal sharedModel].currentUser.microblogsArrOfArr objectAtIndex:blogCircleType];
    _dataArray = arr;
    
    _reloading = YES;
    [self performSelectorOnMainThread:@selector(doneLoadingNewTableViewData) withObject:nil waitUntilDone:YES];


}

- (void)doneLoadingNewTableViewData{
    
    //  model should call this when its done loading
    [_tableView reloadData];
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
    //更新完列表后调整底部刷新控件的位置
    [self setRefreshViewFrame];
    NSLog(@"refreshHeaderView end reloading!");
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    //新建线程处理读取后台数据
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(reloadTableViewNewDataSource) object:nil];
    [thread start];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
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

#pragma Mark - tableView delegate & datasourse

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    XXTMicroblog *micro = [_dataArray objectAtIndex:row];
    
    //The following code is for getting the exact height of text content
    NSString *content = micro.content;
    CGSize size = CGSizeMake(240, 2000);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Heiti SC" size:15.0], NSFontAttributeName,[UIColor colorWithRed:135/255.0 green:132/255.0 blue:134/255.0 alpha:1.0], NSForegroundColorAttributeName, nil];
    CGFloat height;
    if(isIOS7 == YES){
        CGRect contentFrame = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];//This method only valid in ios7
        height += contentFrame.size.height;
    }else {
        CGSize contentSize = [content sizeWithFont:[UIFont fontWithName:@"Heiti SC" size:15.0] forWidth:size.width lineBreakMode:NSLineBreakByCharWrapping];
        height += contentSize.height;

    }
    
    height += 105.0f;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
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
    
    NSInteger row = indexPath.row;
    XXTMicroblog *micro = [_dataArray objectAtIndex:row];
    
    //Translate the shareDateTime to NSString
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   [formatter setDateStyle:NSDateFormatterMediumStyle];
   [formatter setTimeStyle:NSDateFormatterShortStyle];
   [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:micro.dateTime];
    cell.shareDate.text = dateString;
    
    //The following code is for getting the exact height of text content
    NSString *content = micro.content;
    CGSize size = CGSizeMake(240, 2000);
    cell.shareContent.text = content;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Heiti SC" size:15.0], NSFontAttributeName,[UIColor colorWithRed:135/255.0 green:132/255.0 blue:134/255.0 alpha:1.0], NSForegroundColorAttributeName, nil];
    CGRect contentFrame;
    if(isIOS7 == YES){
        contentFrame = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];//This method only valid in ios7
    }else {
        CGSize contentSize = [content sizeWithFont:[UIFont fontWithName:@"Heiti SC" size:15.0] forWidth:size.width lineBreakMode:NSLineBreakByCharWrapping];
        contentFrame = CGRectMake(cell.shareContent.frame.origin.x, cell.shareContent.frame.origin.y, cell.shareContent.frame.size.width, contentSize.height);
    }
    cell.shareContent.frame = CGRectMake(cell.shareContent.frame.origin.x, cell.shareContent.frame.origin.y, contentFrame.size.width, contentFrame.size.height);
    
    //Adjust the height of comment background
    cell.commentBackground.frame = CGRectMake(cell.commentBackground.frame.origin.x, cell.commentBackground.frame.origin.y, cell.commentBackground.frame.size.width, contentFrame.size.height+50);
    
    //Adjust the origin Y of bottomView
    cell.bottomView.frame = CGRectMake(cell.bottomView.frame.origin.x, cell.commentBackground.frame.size.height-30, cell.bottomView.frame.size.width, cell.bottomView.frame.size.height);
    
    //Fix the exact number of comment and like
    cell.numberOfComment.text = [NSString stringWithFormat:@"%ld", (long)micro.commentCount];
    cell.numberOflike.text = [NSString stringWithFormat:@"%ld", (long)micro.likeCount];
    
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
