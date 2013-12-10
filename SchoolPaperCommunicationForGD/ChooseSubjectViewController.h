//
//  ChooseSubjectViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSubjectViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *chooseSubjectTV;
@property (nonatomic, retain) NSMutableArray *subjectArray;

@end
