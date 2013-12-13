//
//  MyMessageViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MessageCell.h"
#import "AppDelegate.h"

@interface MyMessageViewController ()

@end

@implementation MyMessageViewController
{
    NSInteger contentHeight;
}
@synthesize messageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect screenFrame =  [[UIScreen mainScreen] bounds];
        if (IOS_VERSION_7_OR_ABOVE)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
            contentHeight = screenFrame.size.height - 64;
        }else{
            contentHeight = screenFrame.size.height - 44;
        }
        
        //设置界面背景颜色
        self.view.backgroundColor = [UIColor whiteColor];
        
        //初始化tableView
        messageList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
        messageList.delegate = self;
        messageList.dataSource = self;
        messageList.separatorColor = [UIColor clearColor];
        [self.view addSubview:messageList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark
#pragma UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Height for row: %ld", indexPath.row);

    return 65.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row at indexpath :row(%ld), section(%ld)", indexPath.row, indexPath.section);
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
