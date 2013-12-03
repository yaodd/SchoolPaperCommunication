//
//  DynamicPswViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "DynamicPswViewController.h"
#import "XXTAlertView.h"

@interface DynamicPswViewController ()

@end

@implementation DynamicPswViewController
@synthesize phoneTF;
@synthesize getDynamicButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initLayout];
}
- (void)initLayout{
    [phoneTF.layer setCornerRadius:5.0f];
    [phoneTF.layer setBorderWidth:1.0f];
    [phoneTF.layer setBorderColor:[UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1.0].CGColor];
    
    [getDynamicButton.layer setCornerRadius:5.0f];
    [getDynamicButton.layer setBorderWidth:1.0f];
    [getDynamicButton.layer setBorderColor:[UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1.0].CGColor];
    
    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 39)];
    UIImageView *leftImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 12, 14)];
    [leftImageView1 setImage:[UIImage imageNamed:@"usericon"]];
    [leftView1 addSubview:leftImageView1];
    phoneTF.leftView = leftView1;
    [phoneTF setLeftViewMode:UITextFieldViewModeAlways];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getDynamicAction:(id)sender {
    XXTAlertView *alertView = [[XXTAlertView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 200, 100)];
    [alertView show];
    
}
@end
