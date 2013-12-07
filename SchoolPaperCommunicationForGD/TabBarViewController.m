//
//  TabBarViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "InfoViewController.h"
#import "ContactsViewController.h"
#import "FunctionListViewController.h"
#import "DynamicsViewController.h"
#import "SetUpViewController.h"
#import "ShareListViewController.h"
@interface TabBarViewController (){
    NSArray *titleArray;
    NSMutableArray *tabButtonArray;
}

@end

@implementation TabBarViewController
@synthesize tabBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setHidesBottomBarWhenPushed:YES];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initControllers];
    [self initTabBar];

}

- (void)initControllers{
    InfoViewController *infoViewController = [[InfoViewController alloc]init];
    UINavigationController *tab1 = [[UINavigationController alloc]initWithRootViewController:infoViewController];
    
    ContactsViewController *contactsViewController = [[ContactsViewController alloc]init];
    UINavigationController *tab2 = [[UINavigationController alloc]initWithRootViewController:contactsViewController];
    
    FunctionListViewController *functionListViewController = [[FunctionListViewController alloc]init];
    UINavigationController *tab3 = [[UINavigationController alloc]initWithRootViewController:functionListViewController];
    
    ShareListViewController *dynamicsViewController = [[ShareListViewController alloc]init];
    UINavigationController *tab4 = [[UINavigationController alloc]initWithRootViewController:dynamicsViewController];
    
    SetUpViewController *setUpViewController = [[SetUpViewController alloc]init];
    UINavigationController *tab5 = [[UINavigationController alloc]initWithRootViewController:setUpViewController];
    
//    self.tabBarController.viewControllers = @[tab1,tab2,tab3,tab4,tab5];
    
    self.viewControllers = @[tab1,tab2,tab3,tab4,tab5];
}

- (void)initTabBar{
//    self.tabBar.hidden = YES;
    CGFloat tabBarY;
//    if (IOS_VERSION_7_OR_ABOVE) {
        tabBarY = self.view.frame.size.height - 49;
//    }
//    else{
//        tabBarY = self.view.frame.size.height - 49 - 44 - 20;
//    }

    
    tabBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    tabBarView.userInteractionEnabled = YES;
    [tabBarView setBackgroundColor:[UIColor colorWithRed:92.0/255 green:92.0/255 blue:92.0/255 alpha:1.0]];
//    [self.view addSubview:tabBarView];
    [self.tabBar addSubview:tabBarView];
    
    NSArray *selectedImages = [[NSArray alloc]initWithObjects:@"news_chosen",@"contact_chosen",@"circle_chosen",@"study_chosen",@"setting_chosen",nil];
    NSArray *unselectedImages = [[NSArray alloc]initWithObjects:@"news",@"contact",@"circle",@"study",@"setting",nil];
    titleArray = [[NSArray alloc]initWithObjects:@"消息",@"通讯录",@"家校圈",@"学习",@"设置", nil];
//    self.title = [titleArray objectAtIndex:0];
    tabButtonArray = [[NSMutableArray alloc]init];
    
    float coordinax = 0;
    for (int index = 0; index < 5; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setShowsTouchWhenHighlighted:NO];
//        [button setTintColor:[UIColor clearColor]];
//        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        
        button.tag = index;
//        button.frame = CGRectMake(17+coordinax, 9, 30, 25);
        button.frame = CGRectMake(0 + coordinax, 0, 64, 49);
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(-4, 17, 10, 17)];
        
        [button setImage:[UIImage imageNamed:[unselectedImages objectAtIndex:index]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[selectedImages objectAtIndex:index]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
        
        [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(32, -15, 0, 15)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:13.0/255 green:152.0/255 blue:219.0/255 alpha:1.0] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [tabBarView addSubview:button];
        [tabButtonArray addObject:button];
        coordinax += 64;
    }
}

-(void)changeViewController:(id) sender
{
    UIButton *button = (UIButton *) sender;
    self.selectedIndex = button.tag;
    button.selected = YES;
//    self.title = [titleArray objectAtIndex:button.tag];
    for (UIButton *tempButton in tabButtonArray) {
        if (tempButton.tag != button.tag) {
            tempButton.selected = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
