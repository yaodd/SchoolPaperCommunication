//
//  StudyViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-9.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "StudyViewController.h"
#import "AppDelegate.h"
#import "QuestionView.h"
@interface StudyViewController ()

@end

@implementation StudyViewController

@synthesize myHeadImageView;
@synthesize myQuestionButton;
@synthesize chooseGradeButton;
@synthesize chooseStateButton;
@synthesize chooseSubjectButton;
@synthesize questionTableView;
@synthesize chooseView;

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
}
- (void)initLayout{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [chooseView.layer setCornerRadius:5];
    [chooseView.layer setBorderColor:[UIColor colorWithRed:20.0/255 green:31.0/255 blue:1.0 alpha:1.0].CGColor];
    [chooseView.layer setBorderWidth:1.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate mark
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 368;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QuestionView"owner:self options:nil];
        
        QuestionView *questionView = [nib objectAtIndex:0];
        [questionView setFrame:CGRectMake(6, 0, questionView.frame.size.width, 358)];
        [questionView initLayout];
        [cell addSubview:questionView];
    }
    
    return cell;
}

- (IBAction)myQuestionAction:(id)sender {
}

- (IBAction)chooseSubjectAction:(id)sender {
}

- (IBAction)chooseGradeAction:(id)sender {
}

- (IBAction)chooseStateAction:(id)sender {
}
@end
