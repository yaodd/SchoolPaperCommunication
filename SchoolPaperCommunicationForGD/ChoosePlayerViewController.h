//
//  ChoosePlayerViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTAlertView.h"

@interface ChoosePlayerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,XXTAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *playerTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end
