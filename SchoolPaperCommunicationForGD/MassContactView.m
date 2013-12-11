//
//  MassContactView.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-13.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MassContactView.h"
#import "XXTContactPerson.h"

@implementation MassContactView
@synthesize chooseButton;
@synthesize nameLabel;
@synthesize groupHolder;
@synthesize indexPath;
@synthesize contactHolder;
@synthesize sepector;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contactHolder = [[ContactHolder alloc]init];
        self.groupHolder = [[GroupHolder alloc]init];
        chooseButton = [[UIButton alloc]initWithFrame:CGRectMake(55, 9.5, 25, 25)];
        [chooseButton setUserInteractionEnabled:NO];
//        [chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chooseButton];
        CGFloat labelX = 55 + 25 + 15;
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(labelX,14.5, self.frame.size.width - labelX, 18)];
        [nameLabel setTextColor:[UIColor colorWithWhite:52.0/255 alpha:1.0]];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:nameLabel];
        
        sepector = [[UIView alloc]initWithFrame:CGRectMake(55, 43, self.frame.size.width, 1)];
        [sepector setBackgroundColor:[UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0]];
        
        [self addSubview:sepector];

    }
    return self;
}

- (void)setDataWithContactHolder:(GroupHolder *)holder indexPath:(NSIndexPath *)Path{
    
    self.indexPath = Path;
    
    self.contactHolder = [holder.contactHolderArr objectAtIndex:indexPath.row];
    self.groupHolder = holder;
    if (indexPath.row == [groupHolder.contactHolderArr count] - 1) {
        CGRect rect = sepector.frame;
        rect.origin.x = 0;
        sepector.frame = rect;
    } else {
        CGRect rect = sepector.frame;
        rect.origin.x = 55;
        sepector.frame = rect;
    }
    NSString *nameStr = contactHolder.contactPerson.name;
    BOOL isChosen = contactHolder.isChosen;
    GroupChosenType type = holder.groupChosenType;
    if (isChosen) {
        if (type == GroupChosenTypeAll) {
            [chooseButton setImage:[UIImage imageNamed:@"allselected"] forState:UIControlStateNormal];
        } else{
            [chooseButton setImage:[UIImage imageNamed:@"someselected"] forState:UIControlStateNormal];
        }
    } else{
        [chooseButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
    [nameLabel setText:nameStr];
}
- (void)chooseAction:(UIButton *)button{
    BOOL isChosen = contactHolder.isChosen;
    if (isChosen) {
        [chooseButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    } else{
        [chooseButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    [contactHolder setIsChosen:!isChosen];
    [self.delegate MassContactView:self withIndexPath:indexPath];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
