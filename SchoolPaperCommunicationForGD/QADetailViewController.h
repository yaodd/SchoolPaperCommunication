//
//  QADetailViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionView.h"
#import "XXTQuestion.h"
@interface QADetailViewController : UIViewController

@property (nonatomic, retain) UIScrollView *qaScrollView;
@property (nonatomic, retain) QuestionView *questionView;
@property (nonatomic, retain) XXTQuestion *xxtQuestion;
@property (nonatomic, retain) NSMutableArray *answerArray;
@end
