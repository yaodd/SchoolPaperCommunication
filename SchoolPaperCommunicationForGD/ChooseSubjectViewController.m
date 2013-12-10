//
//  ChooseSubjectViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ChooseSubjectViewController.h"
#import "IssueQAViewController.h"
#define IMAGEVIEW_TAG   111111
#define LABEL_TAG       222222

@interface ChooseSubjectViewController ()

@end

@implementation ChooseSubjectViewController
@synthesize chooseSubjectTV;
@synthesize subjectArray;

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
    [self initData];
}

- (void)initData{
    subjectArray = [[NSMutableArray alloc]init];
    NSArray *imageArr = [NSArray arrayWithObjects:@"yuwen40*40",@"shuxue40*40",@"yingyu40*40",@"zhengzhi40*40",@"lishi40*40",@"dili40*40",@"wuli40*40",@"shengwu40*40",@"huaxue40*40",@"yinyue40*40", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:@"语文",@"数学",@"英语",@"政治",@"历史",@"地理",@"物理",@"生物",@"化学",@"音乐", nil];
    for (int i = 0; i < 10 ; i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:[imageArr objectAtIndex:i]],@"image",[nameArr objectAtIndex:i],@"name", nil];
        [subjectArray addObject:dict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [subjectArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        UIImageView *subjectIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [subjectIV setTag:IMAGEVIEW_TAG];
        [cell addSubview:subjectIV];
        
        UILabel *subjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 22, 100, 20)];
        [subjectLabel setTag:LABEL_TAG];
        [subjectLabel setTextColor:[UIColor colorWithWhite:52.0/255 alpha:1.0]];
        [subjectLabel setBackgroundColor:[UIColor clearColor]];
        [subjectLabel setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:subjectLabel];
        
    }
    UIImageView *subjectIV = (UIImageView *)[cell viewWithTag:IMAGEVIEW_TAG];
    UILabel *subjectLabel = (UILabel *)[cell viewWithTag:LABEL_TAG];
    
    NSDictionary *dict = [subjectArray objectAtIndex:indexPath.row];
    UIImage *image = [dict objectForKey:@"image"];
    NSString *name = [dict objectForKey:@"name"];
    [subjectIV setImage:image];
    [subjectLabel setText:name];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    IssueQAViewController *issueQAViewController = [[IssueQAViewController alloc]initWithNibName:@"IssueQAViewController" bundle:nil];
    [issueQAViewController setIssueType:IssueTypeQuestion];
    [self.navigationController pushViewController:issueQAViewController animated:YES];
}

@end
