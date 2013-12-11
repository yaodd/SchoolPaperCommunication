//
//  IssueQAViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-10.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "IssueQAViewController.h"
#import "AppDelegate.h"
#import "Dao.h"
#import "XXTModelGlobal.h"
#import <AVFoundation/AVFoundation.h>

#define PHOTO_VIEW_HEIGHT   50.0f


@interface IssueQAViewController ()
{
    //用于制造输入提示字
    UILabel *placeHolder;
    NSString *placeHolderStr;
    
    //用于录音
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    
}

@end

@implementation IssueQAViewController
@synthesize issueTV;
@synthesize issueToolView;
@synthesize choosePhotoButton;
@synthesize takePhotoButton;
@synthesize recordAudioButton;
@synthesize issueType;
@synthesize currentQuestion;
@synthesize photoIV;

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

- (void)initLayout
{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.frame = SCREEN_RECT;
    } else{
        self.view.frame = CGRectMake(0, 0, SCREEN_RECT.size.width, SCREEN_RECT.size.height - 20);
    }
    if (issueType == IssueTypeAnswer) {
        placeHolderStr = @"输入你独到的见解吧...";
    } else{
        placeHolderStr = @"输入你的问题让大家帮帮忙...";
    }
    placeHolder = [[UILabel alloc]init];
    placeHolder.frame =CGRectMake(10, 8, 200, 20);
    placeHolder.text = placeHolderStr;
    [placeHolder setFont:[UIFont systemFontOfSize:15]];
    [placeHolder setTextColor:[UIColor blackColor]];
    placeHolder.enabled = NO;//lable必须设置为不可用
    placeHolder.backgroundColor = [UIColor clearColor];
    [issueTV addSubview:placeHolder];
    CGRect issueFrame = issueTV.frame;
    issueFrame.size.height = self.view.bounds.size.height - 44 - TOP_BAR_HEIGHT;
    issueTV.frame = issueFrame;
    CGRect toolViewFrame = issueToolView.frame;
    toolViewFrame.origin.y = issueTV.frame.size.height + issueTV.frame.origin.y;
//    toolViewFrame.origin.y = self.view.frame.size.height - 44;
    NSLog(@"frameHeight %f",self.view.frame.size.height);
    issueToolView.frame = toolViewFrame;
    
    photoIV = [[UIImageView alloc]init];
    [photoIV setHidden:YES];
    [self.view addSubview:photoIV];
    
    UIBarButtonItem *issueItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(issueItemAction:)];
    self.navigationItem.rightBarButtonItem = issueItem;
//    [issueTV becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
//发布QA点击事件
- (void)issueItemAction:(id)sender{
    if (issueTV.text.length == 0 && 1) {    //先判断是否三个元素都为空
        NSLog(@"发布内容不能为空！");
    }else{
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(issueSelector:) object:nil];
        [thread start];
        
    }
    
}
//异步发布QA
- (void)issueSelector:(NSThread *)thread{
    NSInteger isSuccess = 0;   //反馈状态
    NSString *statusStr = [[NSString alloc]init];  //反馈状态字符串
    NSString *contentStr = [issueTV text];         //文字内容
    XXTImage *image = [[XXTImage alloc]init];      //图片内容
    XXTAudio *audio = [[XXTAudio alloc]init];      //音频内容
    int subjectId = 0;                             //课程id。
    
    if (issueType == IssueTypeQuestion) {   //发布问题
        XXTQuestion *newQuestion = [[XXTQuestion alloc]initNewQuestion:contentStr subjectId:subjectId image:image audio:audio];
        isSuccess = [[Dao sharedDao] requestForPostQuestion:newQuestion];
        if (isSuccess) {
            statusStr = @"问题发布成功";
        } else{
            statusStr = @"问题发布失败";
        }
    } else{                                 //发布答案
        
        XXTAnswer *newAnswer = [[XXTAnswer alloc]initNewAnswer:contentStr image:image audio:audio];
        isSuccess = [[Dao sharedDao] requestForPostAnswer:newAnswer forQuestion:currentQuestion];
        if (isSuccess) {
            statusStr = @"答案发送成功";
        }else{
            statusStr = @"答案发送失败";
        }
        
    }
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect issueFrame = self.issueTV.frame;
    __block CGRect toolFrame = self.issueToolView.frame;
    __block CGRect photoFrame = self.photoIV.frame;
    CGFloat toolViewHeight = 44;
    if (toolFrame.origin.y != screenHeight - keyboardSize.height - toolViewHeight) {
        toolFrame.origin.y = screenHeight - keyboardSize.height - toolViewHeight;//lxf
        issueFrame.size.height = screenHeight - keyboardSize.height - toolViewHeight;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.issueTV.frame = issueFrame;
                             self.issueToolView.frame = toolFrame;
                             self.photoIV.frame = photoFrame;
                         } completion:^(BOOL finished) {
                             photoFrame.origin.y = issueToolView.frame.origin.y - PHOTO_VIEW_HEIGHT - 10;
                             self.issueTV.frame = issueFrame;
                             self.issueToolView.frame = toolFrame;
                             self.photoIV.frame = photoFrame;
                         }];
        
    }
    NSLog(@"show");
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    
    CGFloat toolViewHeight = 44;
    
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect toolFrame = self.issueToolView.frame;
    __block CGRect issueFrmae = self.issueTV.frame;
    __block CGRect photoFrame = self.photoIV.frame;

    issueFrmae.size.height = issueFrmae.size.height + keyboardSize.height;
    toolFrame.origin.y = screenHeight - toolViewHeight;//lxf
    photoFrame.origin.y = issueToolView.frame.origin.x - PHOTO_VIEW_HEIGHT - 10;

    self.issueTV.frame = issueFrmae;
    self.issueToolView.frame = toolFrame;
    self.photoIV.frame = photoFrame;

    NSLog(@"hide");
    //    [UIView animateWithDuration:fAniTimeSecond animations:^{
    //        self.viewItems.frame = frame;
    //    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePhotoAction:(id)sender {
    [self pickImageFromAlbum];
}

- (IBAction)takePhotoAction:(id)sender {
    [self pickImageFromTake];
}

- (IBAction)recordAudioAction:(id)sender {
}

//从相册获取图片
- (void)pickImageFromAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing =YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//打开相机,从相机获取
- (void)pickImageFromTake{
    // for iphone
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing =YES;//自定义照片样式
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma UIImagePickerController mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"picker finished");
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        NSString *filePath = [NSString stringWithString:[self getPath:@"image1"]];         //将图片存储到本地documents
        //        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        //        [fileManager createFileAtPath:[filePath stringByAppendingString:@"/image.png"] contents:dataattributes:nil];
        CGFloat photoHiehgt = PHOTO_VIEW_HEIGHT;
        CGFloat photoWidth = PHOTO_VIEW_HEIGHT / image.size.height * image.size.width;
        UIImage *editedImage = [[UIImage alloc] init];
        editedImage = image;
        CGRect rect = CGRectMake(0, 0, photoWidth, photoHiehgt);
        UIGraphicsBeginImageContext(rect.size);
        [editedImage drawInRect:rect];
        editedImage = UIGraphicsGetImageFromCurrentImageContext();
        [self.photoIV setFrame:CGRectMake(10, issueToolView.frame.origin.y - photoHiehgt - 10, photoWidth, photoHiehgt)];
        NSLog(@"imageWidth %f",photoWidth);
        [self.photoIV setHidden:NO];
        [self.photoIV setImage:editedImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"MEdia");
    }
}


#pragma TextViewDelegate mark
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeHolder.text = placeHolderStr;
    }else{
        placeHolder.text = @"";
    }
}
@end
