//
//  TabBarViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController (){
    NSArray *titleArray;
    NSMutableArray *tabButtonArray;
}

@end

@implementation TabBarViewController

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
    self.tabBar.hidden = YES;
    [self initTabBar];
}

- (void)initTabBar{
    UIImageView *tabBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, 320, 49)];
    tabBarView.userInteractionEnabled = YES;
    [tabBarView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:tabBarView];
    
    NSArray *selectedImages = [[NSArray alloc]initWithObjects:@"business_pressed.png",@"case_pressed",@"serve_pressed",@"about_pressed",@"more_pressed",nil];
    NSArray *unselectedImages = [[NSArray alloc]initWithObjects:@"business.png",@"case",@"service",@"about",@"more",nil];
    titleArray = [[NSArray alloc]initWithObjects:@"消息",@"通讯",@"功能",@"动态",@"设置", nil];
    self.title = [titleArray objectAtIndex:0];
    tabButtonArray = [[NSMutableArray alloc]init];
    
    float coordinax = 0;
    for (int index = 0; index < 5; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(20+coordinax, 49.0/2-10, 25, 25);
        
        [button setBackgroundImage:[UIImage imageNamed:[unselectedImages objectAtIndex:index]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[selectedImages objectAtIndex:index]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:button];
        [tabButtonArray addObject:button];
        coordinax +=62;
    }
}

-(void)changeViewController:(id) sender
{
    UIButton *button = (UIButton *) sender;
    self.selectedIndex = button.tag;
    button.selected = YES;
    self.title = [titleArray objectAtIndex:button.tag];
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
