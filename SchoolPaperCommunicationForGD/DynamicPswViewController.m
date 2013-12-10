//
//  DynamicPswViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-4.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "DynamicPswViewController.h"
#import "XXTAlertView.h"
#import "Dao.h"


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
    UIImageView *leftImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 12, 14)];
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
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(getDynamicSelector:) object:nil];
    [thread start];
    
}
//异步获取动态密码
- (void)getDynamicSelector:(NSThread *)thread{
    NSString *accountStr = phoneTF.text;
    Dao *dao = [Dao sharedDao];
    NSInteger isSuccess = [dao requestForDynamicPasswordForAccount:accountStr];
    if (accountStr.length != 0) {
        if (isSuccess) {
            [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:YES];
        }else{
            NSLog(@"动态密码发送失败！");
        }

    }else{
        NSLog(@"手机号不能为空");
    }
}
//发送成功
- (void)showAlertView{
    XXTAlertView *alertView = [[XXTAlertView alloc]initWithTitle:@"发送成功" XXTAlertViewType:kXXTAlertViewTypeSucceed otherButtonTitles:@"返回", nil];
    alertView.delegate = self;
    [self.navigationController.view addSubview:alertView];
    [alertView show];
}
#pragma XXTAlertViewDelegate mark -
- (void)XXTAlertViewButtonAction:(XXTAlertView *)alertView button:(UIButton *)button{
    if (button.tag == 0) {
//        NSLog(@"tag 0");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else{
        NSLog(@"tag 1");
    }
}
@end
