//
//  commentCell.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "commentCell.h"

@implementation commentCell
@synthesize userComment;
@synthesize userHead;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization coded
        
        userHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        userHead.image = [UIImage imageNamed:@"photo"];
        userHead.layer.cornerRadius = userHead.frame.size.width/2;
        userHead.layer.masksToBounds = YES;
        userHead.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:userHead];
        
        userComment = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 240, 20)];
        userComment.backgroundColor = [UIColor clearColor];
        userComment.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0];
        userComment.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        userComment.textAlignment = NSTextAlignmentLeft;
        userComment.lineBreakMode = NSLineBreakByCharWrapping;
        userComment.numberOfLines = 0;
        [self.contentView addSubview:userComment];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
