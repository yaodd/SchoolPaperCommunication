//
//  commentCell.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-7.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "commentCell.h"

@implementation commentCell
@synthesize comment;
@synthesize head;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization coded
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        head = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        head.image = [UIImage imageNamed:@"photo"];
        head.layer.cornerRadius = head.frame.size.width/2;
        head.layer.masksToBounds = YES;
        head.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:head];
        
        comment = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 240, 20)];
        comment.backgroundColor = [UIColor clearColor];
        comment.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0];
        comment.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        comment.textAlignment = NSTextAlignmentLeft;
        comment.lineBreakMode = NSLineBreakByCharWrapping;
        comment.numberOfLines = 0;
        [self.contentView addSubview:comment];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
