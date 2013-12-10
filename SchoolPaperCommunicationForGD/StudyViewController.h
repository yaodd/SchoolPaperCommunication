//
//  StudyViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-9.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *myHeadImageView;
@property (strong, nonatomic) IBOutlet UIButton *myQuestionButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseSubjectButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseGradeButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseStateButton;
@property (strong, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (nonatomic, retain) UIPickerView *questionPikerView;

@property (nonatomic, retain) NSMutableArray *questionArray;
- (IBAction)myQuestionAction:(id)sender;
- (IBAction)chooseSubjectAction:(id)sender;
- (IBAction)chooseGradeAction:(id)sender;
- (IBAction)chooseStateAction:(id)sender;

@end
