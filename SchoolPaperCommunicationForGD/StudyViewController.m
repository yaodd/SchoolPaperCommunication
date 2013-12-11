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
#import "Dao.h"
#import "XXTModelGlobal.h"
#import "ChooseSubjectViewController.h"
#import "QuestionPikerView.h"
#import "QADetailViewController.h"


#define QUESTION_VIEW_TAG   111111


@interface StudyViewController ()
{
    QuestionPikerView *questionPikerView;
}

@end

@implementation StudyViewController

@synthesize myHeadImageView;
@synthesize myQuestionButton;
@synthesize chooseGradeButton;
@synthesize chooseStateButton;
@synthesize chooseSubjectButton;
@synthesize questionTableView;
@synthesize chooseView;
@synthesize studyViewType;
//@synthesize questionPikerView;
@synthesize questionArray;
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
- (void)initLayout{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIView *headView = [self createHeadView];
    [self.questionTableView setTableHeaderView:headView];
//    [self.questionTableView setContentOffset:CGPointMake(0, headView.frame.size.height)];
//    [self.questionTableView setAllowsSelection:NO];
//    self.questionPikerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 300)];
//    self.questionPikerView.delegate = self;
//    self.questionPikerView.dataSource = self;
//    [self.questionPikerView setBackgroundColor:[UIColor whiteColor]];
//    [self.questionTableView addSubview:questionPikerView];
    if (studyViewType == StudyViewTypeAll) {
        UIBarButtonItem *issueItem = [[UIBarButtonItem alloc]initWithTitle:@"提问" style:UIBarButtonItemStylePlain target:self action:@selector(issueAction:)];
        self.navigationItem.rightBarButtonItem = issueItem;
    }
    
    questionPikerView = [[QuestionPikerView alloc]initWithFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, self.tabBarController.view.frame.size.width, PIKER_VIEW_HEIGHT)];
    [self.tabBarController.view addSubview:questionPikerView];
    
    
}
- (void)issueAction:(id)sender{
    [self setHidesBottomBarWhenPushed:YES];
    ChooseSubjectViewController *chooseSubjectViewController = [[ChooseSubjectViewController alloc]initWithNibName:@"ChooseSubjectViewController" bundle:nil];
    [self.navigationController pushViewController:chooseSubjectViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];

}

- (void)initData{
    questionArray = [[NSMutableArray alloc]init];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadDataSelector:) object:nil];
    [thread start];
}
- (void)loadDataSelector:(NSThread *)thread{
    
    BOOL isSuccess = [[Dao sharedDao] requestForQuestionListForSubjectId:0 state:0 questioner:1 grade:0 page:1 pageSize:10];
    if (isSuccess) {
        XXTUserRole *userRole = [XXTModelGlobal sharedModel].currentUser;
//        NSLog(@"问题获取成功 arr count %d",[userRole.questionArr count]);

        [self performSelectorOnMainThread:@selector(updateTableView:) withObject:userRole.questionArr waitUntilDone:YES];
    }
}
- (void)updateTableView:(NSMutableArray *)questionArr{
    questionArray = questionArr;
    [questionTableView reloadData];
}
- (UIView *)createHeadView{
    CGFloat viewHeight = 0;
    CGFloat chooseViewY = 0;
    if (studyViewType == StudyViewTypeAll) {
        viewHeight = 95;
        chooseViewY = 58;
    } else{
        viewHeight = 49;
        chooseViewY = 10;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewHeight)];
    if (studyViewType == StudyViewTypeAll) {
        myQuestionButton = [[UIButton alloc]initWithFrame:view.frame];
        [myQuestionButton setBackgroundColor:[UIColor clearColor]];
        [myQuestionButton addTarget:self action:@selector(myQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:myQuestionButton];
        
        myHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
        [myHeadImageView setImage:[UIImage imageNamed:@"photo"]];
        [view addSubview:myHeadImageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(55, 17, 70, 20)];
        [label setText:@"我的提问"];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor colorWithWhite:128.0/255 alpha:1.0]];
        [view addSubview:label];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(292, 19, 8, 12)];
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_right.png"]];
        [view addSubview:arrowImageView];
        
        UIView *sepector = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
        [sepector setBackgroundColor:[UIColor colorWithWhite:179.0/255 alpha:1.0]];
        [view addSubview:sepector];
    }
    
    chooseView = [[UIView alloc]initWithFrame:CGRectMake(6, chooseViewY, 308, 29)];
    UIColor *textColor = [UIColor colorWithRed:80.0/255 green:161.0/255 blue:198.0/255 alpha:1.0];
    CGFloat buttonX = 0;
    chooseSubjectButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, 0, 103, 29)];
    [chooseSubjectButton setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [chooseSubjectButton setBackgroundImage:[UIImage imageNamed:@"left_click"] forState:UIControlStateHighlighted];
    [chooseSubjectButton addTarget:self action:@selector(chooseSubjectAction:) forControlEvents:UIControlEventTouchUpInside];
    [chooseSubjectButton setTitle:@"选择科目" forState:UIControlStateNormal];
    [chooseSubjectButton setTitleColor:textColor forState:UIControlStateNormal];
    [chooseSubjectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [chooseView addSubview:chooseSubjectButton];
    
    buttonX += 103;
    chooseGradeButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, 0, 102, 29)];
    [chooseGradeButton setBackgroundImage:[UIImage imageNamed:@"middle"] forState:UIControlStateNormal];
    [chooseGradeButton setBackgroundImage:[UIImage imageNamed:@"middle_click"] forState:UIControlStateHighlighted];
    [chooseGradeButton addTarget:self action:@selector(chooseGradeAction:) forControlEvents:UIControlEventTouchUpInside];
    [chooseGradeButton setTitle:@"选择年级" forState:UIControlStateNormal];
    [chooseGradeButton setTitleColor:textColor forState:UIControlStateNormal];
    [chooseGradeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [chooseView addSubview:chooseGradeButton];
    
    buttonX += 102;
    chooseStateButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, 0, 103, 29)];
    [chooseStateButton setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [chooseStateButton setBackgroundImage:[UIImage imageNamed:@"right_click"] forState:UIControlStateHighlighted];
    [chooseStateButton addTarget:self action:@selector(chooseStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [chooseStateButton setTitle:@"选择状态" forState:UIControlStateNormal];
    [chooseStateButton setTitleColor:textColor forState:UIControlStateNormal];
    [chooseStateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [chooseView addSubview:chooseStateButton];

    [view addSubview:chooseView];
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate mark
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 56 + 10;        //标题高度
    
    XXTQuestion *question = [questionArray objectAtIndex:indexPath.row];
    NSString *content = question.content;
    XXTImage *qImage = question.qImage;
    XXTAudio *qAudio = [[XXTAudio alloc]init];
    NSArray *qAudioArr = question.qAudios;
    if ([qAudioArr count] != 0) {
        qAudio = [qAudioArr objectAtIndex:0];
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH - 10, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    height += size.height + 10;
    if (qImage != nil) {
        height += (IMAGE_HEIGHT + 10);
    }
    if (qAudio != nil) {
        height += (AUDIO_HEIGHT + 10);
    }
    height += 10;
    
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [questionArray count];
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
        [questionView setTag:QUESTION_VIEW_TAG];
        [cell addSubview:questionView];
    }
    QuestionView *questionView = (QuestionView *)[cell viewWithTag:QUESTION_VIEW_TAG];
    XXTQuestion *question = [questionArray objectAtIndex:indexPath.row];
    [questionView setDataWithQuestion:question];
//    NSLog(@"answer count %d",[question.answersArr count]);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setHidesBottomBarWhenPushed:YES];
    XXTQuestion *currentQuestion = [questionArray objectAtIndex:indexPath.row];
    QADetailViewController *qaDetailViewController = [[QADetailViewController alloc]init];
    [qaDetailViewController setCurrentQuesion:currentQuestion];
    [self.navigationController pushViewController:qaDetailViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)myQuestionAction:(id)sender {
    [self setHidesBottomBarWhenPushed:YES];
    StudyViewController *studyViewController = [[StudyViewController alloc]initWithNibName:@"StudyViewController" bundle:nil];
    [studyViewController setStudyViewType:StudyViewTypeMine];
    [self.navigationController pushViewController:studyViewController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (IBAction)chooseSubjectAction:(id)sender {
    if ([questionPikerView isHidden]) {
        [questionPikerView showPikerView];
    } else{
        [questionPikerView hidePikerView];
    }
}

- (IBAction)chooseGradeAction:(id)sender {
}

- (IBAction)chooseStateAction:(id)sender {
}
#pragma UIPikerViewDelegate Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 320;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [label setFont:[UIFont systemFontOfSize:23]];
    [label setText:@"科目科目"];
    [label setTextColor:[UIColor blackColor]];
    return label;
}

@end
