//
//  MyMessageViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *messageList;

@end
