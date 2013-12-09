//
//  ShareListCell.h
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareListCellDelegate;

@interface ShareListCell : UITableViewCell

@property (nonatomic, retain) id<ShareListCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *userHead;
@property (nonatomic, retain) UIButton *userHeadBtn;
@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UILabel *shareDate;
@property (nonatomic, retain) UILabel *shareContent;
@property (nonatomic, retain) UIImageView *shareImg;
@property (nonatomic, retain) UIButton *commentBtn;
@property (nonatomic, retain) UIButton *likeBtn;
@property (nonatomic, retain) UIButton *commentBackground;
@property (nonatomic, retain) UILabel *numberOflike;
@property (nonatomic, retain) UILabel *numberOfComment;
@property (nonatomic, retain) UIButton *bottomView;

@end

@protocol ShareListCellDelegate

- (void)jumpToShareDetailDelegate;

@end