//
//  ChooseTemplateViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ChooseTemplateViewController.h"
#import "AppDelegate.h"
#import "Dao.h"
#import "XXTModelGlobal.h"
#import "TemplateHolder.h"
#import "SendMassMsgViewController.h"

#define TEMPLATE_VIEW_TAG   111111

#define OFFENUSE_TEMP_INDEX      0
#define RECOMMENDED_TEMP_INDEX   1
#define ALL_TEMP_INDEX           2

@interface ChooseTemplateViewController ()
{
    BOOL isSearching;
}
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; // UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897
@end

@implementation ChooseTemplateViewController
@synthesize templateTableView;
@synthesize displayTempArr;
@synthesize offenUseTempArr;
@synthesize recommendedTempArr;
@synthesize allTempArr;
@synthesize searchBar;
@synthesize chooseTempTypeSC;
@synthesize choosenTemp;

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
    self.templateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT)];
    self.templateTableView.dataSource = self;
    self.templateTableView.delegate = self;
    [self.templateTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.templateTableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
//    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
     UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44 + 6 + 29 + 6)];
     [headView setBackgroundColor:[UIColor whiteColor]];
     [headView addSubview:self.searchBar];
     UIView *sepectorView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
     [sepectorView setBackgroundColor:[UIColor colorWithWhite:235.0/255 alpha:1.0]];
     [self.searchBar addSubview:sepectorView];
     NSArray *items = [NSArray arrayWithObjects:@"常用模板",@"推荐模板",@"全部模板", nil];
     chooseTempTypeSC = [[UISegmentedControl alloc]initWithItems:items];
    [chooseTempTypeSC addTarget:self action:@selector(chooseTmepTypeAction:) forControlEvents:UIControlEventValueChanged];
    [chooseTempTypeSC setSelectedSegmentIndex:OFFENUSE_TEMP_INDEX];
     [chooseTempTypeSC setFrame:CGRectMake(6, 50, 308, 29)];
     [chooseTempTypeSC setWidth:102 forSegmentAtIndex:0];
     [chooseTempTypeSC setWidth:104 forSegmentAtIndex:1];
     [chooseTempTypeSC setWidth:102 forSegmentAtIndex:2];
     [chooseTempTypeSC setTintColor:[UIColor colorWithRed:13.0/255 green:152.0/255 blue:219.0/255 alpha:1.0]];
     
     [headView addSubview:chooseTempTypeSC];

    self.templateTableView.tableHeaderView = headView;
//    self.templateTableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    
    //生成一个headView作为tableView的headView
    
     

    
}
//筛选按钮响应
- (void)chooseTmepTypeAction:(UISegmentedControl *)segmentedControl{
//    NSLog(@"index %d",segmentedControl.selectedSegmentIndex);
    //选择常用模板
    [self.searchBar resignFirstResponder];
    if (segmentedControl.selectedSegmentIndex == OFFENUSE_TEMP_INDEX) {
        displayTempArr = offenUseTempArr;
    }
    //选择推荐模板
    if (segmentedControl.selectedSegmentIndex == RECOMMENDED_TEMP_INDEX) {
        displayTempArr = recommendedTempArr;
        
    }
    //选择全部模板
    if (segmentedControl.selectedSegmentIndex == ALL_TEMP_INDEX) {
        displayTempArr = allTempArr;
    }
    [self.templateTableView reloadData];

}
- (void)viewWillAppear:(BOOL)animated{
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

//生成一个headView---封装
//- (UIView *)createHeadView
//{
//    UIView *headView =[UIView alloc]ini
//}
- (void)initData
{
    displayTempArr = [[NSMutableArray alloc]init];
    offenUseTempArr = [[NSMutableArray alloc]init];
    recommendedTempArr = [[NSMutableArray alloc]init];
    allTempArr = [[NSMutableArray alloc]init];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadDataSelector:) object:nil];
    [thread start];
}
- (void)loadDataSelector:(NSThread *)thread
{
    NSInteger isSuccess = [[Dao sharedDao] requestForMessageTemplates];
    if (isSuccess) {
        NSLog(@"模板获取成功");
        [self performSelectorOnMainThread:@selector(updateData) withObject:nil waitUntilDone:YES];
    }
}
- (void)updateData
{
    XXTUserRole *userRole = [XXTModelGlobal sharedModel].currentUser;
    NSLog(@"template count %d",[userRole.messageTemplatesArr count]);
    for (XXTMessageTemplate *template in userRole.messageTemplatesArr) {
        TemplateHolder *holder = [[TemplateHolder alloc]init];
        [holder setMessageTemplate:template];
        [holder setIsExpanded:NO];
        if (template.type == XXTMessageTemplateTypeOffenUse) {
            [offenUseTempArr addObject:holder];
        } else if (template.type == XXTMessageTemplateTypeRecommend){
            [recommendedTempArr addObject:holder];
        }
        [allTempArr addObject:holder];
    }
    displayTempArr = offenUseTempArr;
    [templateTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate Datasourse mark
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TemplateHolder *holder = [displayTempArr objectAtIndex:indexPath.row];
    XXTMessageTemplate *msgTemp = holder.messageTemplate;
    NSString *contentStr = msgTemp.content;
    BOOL isExpanded = holder.isExpanded;
    CGFloat height;
    if (isExpanded) {
        CGSize size = [contentStr sizeWithFont:LABEL_FONT constrainedToSize:CGSizeMake(LABEL_WIDTH - 10, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        height = size.height + 30;
    } else{
        height = TEMPLATE_VIEW_HEIGHT_DEFAULT;
    }
    
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [displayTempArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        TemplateView *templateView = [[TemplateView alloc]initWithFrame:CGRectZero];
        templateView.delegate = self;
        [templateView setTag:TEMPLATE_VIEW_TAG];
        [cell addSubview:templateView];
    }
    TemplateHolder *templateHolder = [displayTempArr objectAtIndex:indexPath.row];
    TemplateView *templateView = (TemplateView *)[cell viewWithTag:TEMPLATE_VIEW_TAG];
    [templateView setDataWithTemplateHolder:templateHolder];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    
    int index1 = indexPath.row;
    int index2 = -1;
    TemplateHolder *curHolder = [displayTempArr objectAtIndex:index1];
    for (int i = 0; i < [displayTempArr count] ;i ++) {
        TemplateHolder *holder = [displayTempArr objectAtIndex:i];
        if(index1 != i && holder.isExpanded) {      //找到之前展开的项，
            index2 = i;                             //标记index
            holder.isExpanded = NO;                 //收回去
            NSLog(@"%d",i);
            break;
        }
    }
    curHolder.isExpanded = YES;
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:index1 inSection:0];
    NSIndexPath *indexPath2 = [[NSIndexPath alloc]init];
    if (index2 == -1) {
        indexPath2 = nil;                       //如果没有已展开项，则为nil
    } else{
        indexPath2 = [NSIndexPath indexPathForRow:index2 inSection:0];
    }
    NSArray *array = [[NSArray alloc]initWithObjects:indexPath1,indexPath2, nil];//一定要把indexPath2放后面，否则当indexPath2为nil时，indexPath1不会进入数组。
    //        [templateTableView reloadData];
    [templateTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];  //展开,收回动画。
    [templateTableView reloadData];
}
#pragma UISearchDisplayDelegate mark
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    NSLog(@"end");
    [searchBar setFrame:CGRectMake(0, 0, searchBar.frame.size.width, 44)];
}
 

#pragma TemplateViewDelegate mark
- (void)templateView:(TemplateView *)templateView withHolder:(TemplateHolder *)holder{
    [self.delegate ChooseTemplateController:self passBackWithTemplate:holder.messageTemplate];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma UISearchBarDelegate mark
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [chooseTempTypeSC setSelectedSegmentIndex:ALL_TEMP_INDEX];
    displayTempArr = [NSMutableArray array];
    for (TemplateHolder *holder in allTempArr) {
        if ([self isMatchWithSeatchText:searchText originalText:holder.messageTemplate.content]) {
            [displayTempArr addObject:holder];
        }
    }
    [self.templateTableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    displayTempArr = allTempArr;
    [self.templateTableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}
//字符串匹配搜索算法
- (BOOL)isMatchWithSeatchText:(NSString *)searchText originalText:(NSString *)originalText{
    BOOL result = YES;
    int start = 0;
    for (int i = 0; i < searchText.length; i ++) {
        unichar c = [searchText characterAtIndex:i];
        for (int k = start; k < originalText.length; k ++) {
            if (c == [originalText characterAtIndex:k]) {
                start = k + 1;
                break;
            }
            if (k == originalText.length - 1) {
                result = NO;
            }
        }
    }
    
    return result;
}

@end
