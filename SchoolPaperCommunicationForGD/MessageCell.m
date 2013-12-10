//
//  MessageCell.m
//  SchoolPaperCommunicationForGD
//
//  Created by 欧 展飞 on 13-12-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize head;
@synthesize name;
@synthesize content;
@synthesize dateTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        head = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        head.backgroundColor = [UIColor clearColor];
        head.image = [UIImage imageNamed:@"photo"];
        head.layer.cornerRadius = 22.5;
        head.layer.masksToBounds = YES;
        [self.contentView addSubview:head];
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(head.frame.size.width+20, 15, 100, 20)];
        name.textColor = [UIColor colorWithRed:86/255.0 green:122/255.0 blue:150/255.0 alpha:1.0];
        name.textAlignment = NSTextAlignmentLeft;
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
        [self.contentView addSubview:name];
        
        dateTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 15, 100, 20)];
        dateTime.backgroundColor = [UIColor clearColor];
        dateTime.textAlignment = NSTextAlignmentRight;
        dateTime.textColor = [UIColor colorWithWhite:184/255.0 alpha:1.0];
        dateTime.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
        [self.contentView addSubview:dateTime];
        
        content = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, 40, 245, 20)];
        content.backgroundColor = [UIColor clearColor];
        content.textColor = [UIColor colorWithWhite:52/255.0 alpha:1.0f];
        content.textAlignment = NSTextAlignmentLeft;
        content.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
        [self.contentView addSubview:content];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
