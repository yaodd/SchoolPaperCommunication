//
//  QADetailViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "QADetailViewController.h"
#import "AppDelegate.h"
#import "AnswerView.h"
#import "XXTModelGlobal.h"
#import "Dao.h"
#import "IssueQAViewController.h"

@interface QADetailViewController ()

@end

@implementation QADetailViewController
@synthesize questionView;
@synthesize qaScrollView;
@synthesize currentQuesion;
@synthesize answerArray;

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
    [self initLayout];
}
- (void)initLayout
{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    qaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_BAR_HEIGHT)];
    [self.view addSubview:qaScrollView];
    
    UIImage *qHeadImage = [UIImage imageNamed:@"questions"];
    CGRect qHeadFrame = CGRectMake(0, 0, self.view.frame.size.width, 25);
    UIView *qHeadView = [self createHeadViewWithTitle:@"问题" image:qHeadImage frame:qHeadFrame];
    [qaScrollView addSubview:qHeadView];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QuestionView"owner:self options:nil];
    questionView = [nib objectAtIndex:0];
    [questionView setDataWithQuestion:currentQuesion];
    CGRect qViewFrame = questionView.frame;
    qViewFrame.origin.x = 0;
    qViewFrame.origin.y = 25;
    qViewFrame.size.width = self.view.frame.size.width;
    [questionView setFrame:qViewFrame];
    CGRect qTimeFrame = questionView.timeLabel.frame;
    qTimeFrame.origin.x += 6;
    questionView.timeLabel.frame = qTimeFrame;
    CGRect qSepectorFrame = questionView.sepectorView.frame;
    qSepectorFrame.size.width = self.view.frame.size.width;
    questionView.sepectorView.frame = qSepectorFrame;
    
    UIImage *aHeadImage = [UIImage imageNamed:@"answers"];
    CGRect aHeadFrame = CGRectMake(0, questionView.frame.size.height + questionView.frame.origin.y, self.view.frame.size.width, 25);
    UIView *aHeadView = [self createHeadViewWithTitle:@"答案" image:aHeadImage frame:aHeadFrame];
    [qaScrollView addSubview:aHeadView];

    [qaScrollView addSubview:questionView];
    CGFloat answerViewY = aHeadView.frame.origin.y + aHeadView.frame.size.height;
    [self initData:answerViewY];
    
    UIBarButtonItem *issueItem = [[UIBarButtonItem alloc]initWithTitle:@"我要回答" style:UIBarButtonItemStylePlain target:self action:@selector(issueItemAction:)];
    self.navigationItem.rightBarButtonItem = issueItem;
    
}
- (void)issueItemAction:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    IssueQAViewController *issueQAViewController = [[IssueQAViewController alloc]initWithNibName:@"IssueQAViewController" bundle:nil];
    [issueQAViewController setIssueType:IssueTypeAnswer];
    [issueQAViewController setCurrentQuestion:currentQuesion];
    [self.navigationController pushViewController:issueQAViewController animated:YES];
}
- (void)initData:(CGFloat)answerViewY
{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadAnswersSelector:) object:[NSNumber numberWithFloat:answerViewY]];
        [thread start];
    
}
//异步加载当前问题的答案数据，参数为第一个答案的UI坐标的Y值
- (void)loadAnswersSelector:(NSNumber *)number
{
    answerArray = [[NSMutableArray alloc]init];
    int isSuccess = [[Dao sharedDao] requestForQuestionDetail:currentQuesion];
    if (isSuccess) {
        NSLog(@"获取答案详情成功 %d",[currentQuesion.answersArr count]);
        answerArray = currentQuesion.answersArr;
        //加载完数据后更新ScrollView
        [self performSelectorOnMainThread:@selector(updateScrollView:) withObject:number waitUntilDone:YES];
    }
}
//更新ScrollView
- (void)updateScrollView:(NSNumber *)number{
    CGFloat answerViewY = [number floatValue];
    for (int i = 0; i < [answerArray count]; i++) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AnswerView"owner:self options:nil];
        AnswerView *answerView = [nib objectAtIndex:0];
        XXTAnswer *xxtAnswer = [answerArray objectAtIndex:i];
        [answerView setDataWithAnswer:xxtAnswer];
        CGRect answerFrame = answerView.frame;
        answerFrame.origin.y = answerViewY;
        answerView.frame = answerFrame;
        [qaScrollView addSubview:answerView];
        answerViewY += answerView.frame.size.height;
    }
    [qaScrollView setContentSize:CGSizeMake(self.view.frame.size.width, answerViewY)];
}
- (UIView *)createHeadViewWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame{
    CGSize imageSize = image.size;
    UIView *questionHeadView = [[UIView alloc]initWithFrame:frame];
    [questionHeadView setBackgroundColor:[UIColor colorWithWhite:236.0/255 alpha:1.0]];
    
    UIImageView *qHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (25 - imageSize.width) / 2, imageSize.width, imageSize.height)];
    [qHeadImageView setImage:image];
    [questionHeadView addSubview:qHeadImageView];
    UILabel *qHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + imageSize.width + 5, 6, 100, 12)];
    [qHeadLabel setTextColor:[UIColor colorWithWhite:156.0/255 alpha:1.0]];
    [qHeadLabel setBackgroundColor:[UIColor clearColor]];
    [qHeadLabel setFont:[UIFont systemFontOfSize:12]];
    [qHeadLabel setText:title];
    [questionHeadView addSubview:qHeadLabel];

    return questionHeadView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
