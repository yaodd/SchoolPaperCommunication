//
//  ChoosePlayerViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ChoosePlayerViewController.h"
#import "TabBarViewController.h"
#import "PlayerView.h"
#import "XXTModelGlobal.h"
#import "XXTUserRole.h"
#import "XXTModelController.h"


#define PLAYER_VIEW_TAG     111111
@interface ChoosePlayerViewController ()

@end

@implementation ChoosePlayerViewController
@synthesize playerTableView;
@synthesize dataArray;


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
//初始化布局
- (void)initLayout{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.title = @"选择角色";
    [playerTableView setSeparatorColor:[UIColor clearColor]];
    [playerTableView setSectionIndexColor:[UIColor clearColor]];
    
}

//返回前询问
- (void)backAction:(id)sender{
    XXTAlertView *alertView = [[XXTAlertView alloc]initWithTitle:@"返回登录页？" XXTAlertViewType:kXXTAlertViewTypeNoImage otherButtonTitles:@"取消",@"确定", nil];
    alertView.delegate = self;
    [self.navigationController.view addSubview:alertView];
    [alertView show];
}
//自定义alertView委托
#pragma XXTAlertViewDelegate mark
- (void)XXTAlertViewButtonAction:(XXTAlertView *)alertView button:(UIButton *)button{
    if (button.tag == 0) {
        
    } else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
//初始化数据
- (void)initData{
    dataArray = [[NSMutableArray alloc]init];
    XXTModelGlobal *global = [XXTModelGlobal sharedModel];
    dataArray = (NSMutableArray *)global.userObjectArr;
    NSLog(@"array count %d",[dataArray count]);
//    NSArray *playerArray = [NSArray arrayWithObjects:@"老师",@"家长",@"学生", nil];
//    NSArray *headImageArray = [NSArray arrayWithObjects:@"photo",@"photo1",@"photo", nil];
    /*for (int i = 0; i < 3; i ++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[playerArray objectAtIndex:i],@"player",[UIImage imageNamed:[headImageArray objectAtIndex:i]],@"image", nil];
        [dataArray addObject:dict];
    }
     */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        PlayerView *playerView = [[PlayerView alloc]initWithDefault];
        [playerView setTag:PLAYER_VIEW_TAG];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:playerView];
    }
    PlayerView *playerView = (PlayerView *)[cell viewWithTag:PLAYER_VIEW_TAG];
    XXTUserRole *userRole = [dataArray objectAtIndex:indexPath.row];
    [playerView setData:userRole];
    return cell;
}
//选择某一个角色
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [XXTModelController selectUserRole:[dataArray objectAtIndex:indexPath.row]];//更改当前的角色选择；
    TabBarViewController *tabBarViewController = [[TabBarViewController alloc]init];
    [self presentViewController:tabBarViewController animated:YES completion:nil];
}

@end
