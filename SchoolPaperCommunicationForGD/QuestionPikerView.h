//
//  QuestionPikerView.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PIKER_VIEW_HEIGHT   265

@interface QuestionPikerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, retain) UIPickerView *pikerView;
@property (nonatomic, retain) NSMutableArray *pikerDataArray;
@property (nonatomic, retain) UIView *blurView;
- (void)showPikerView;
- (void)hidePikerView;
@end
