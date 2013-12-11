//
//  SendMassMsgViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "SendMassMsgViewController.h"
#import "AppDelegate.h"
#import "ChooseMassContactViewController.h"
#import "ChooseTemplateViewController.h"


//#define PHOTO_VIEW_HEIGHT   44
//#define PHOTO_VIEW_WIDTH    44
//#define MEDIA_VIEW_HEIGHT   64
#define MAX_PHOTO_NUM       4

@interface SendMassMsgViewController ()
{
    //用于制造输入提示字
    UILabel *placeHolder;
    NSString *placeHolderStr;
    
    CGFloat viewHeight;
    
    NSMutableArray *photoArray;//存放照片，最多四张
    
}

@end

@implementation SendMassMsgViewController
@synthesize contactsView;
@synthesize contactsLabel;
@synthesize contentTV;
@synthesize chooseContactsButton;
@synthesize choosePhotoButton;
@synthesize chooseTemplateButton;
@synthesize recordAudioButton;
@synthesize toolView;
@synthesize mediaView;


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
    [self initData];
}
- (void)initLayout
{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.frame = SCREEN_RECT;
    } else{
        self.view.frame = CGRectMake(0, 0, SCREEN_RECT.size.width, SCREEN_RECT.size.height - 20);
    }
    placeHolderStr = [NSString stringWithFormat:@"输入短信内容..."];
    placeHolder = [[UILabel alloc]init];
    placeHolder.frame =CGRectMake(10, 8, 200, 20);
    placeHolder.text = placeHolderStr;
    [placeHolder setFont:[UIFont systemFontOfSize:15]];
    [placeHolder setTextColor:[UIColor blackColor]];
    placeHolder.enabled = NO;//lable必须设置为不可用
    placeHolder.backgroundColor = [UIColor clearColor];
    [contentTV addSubview:placeHolder];
    contentTV.delegate = self;
    
    viewHeight = self.view.frame.size.height;
    CGRect contentTVFrame = contentTV.frame;
    contentTVFrame.size.height = viewHeight - TOP_BAR_HEIGHT - contactsView.frame.size.height - toolView.frame.size.height;
    contentTV.frame = contentTVFrame;
    
    CGRect toolViewFrame = toolView.frame;
    toolViewFrame.origin.y = contentTV.frame.origin.y + contentTV.frame.size.height;
    toolView.frame = toolViewFrame;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)initData
{
    photoArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect contentTVFrame = self.contentTV.frame;
    __block CGRect toolViewFrame = self.toolView.frame;
    __block CGRect mediaViewFrame = self.mediaView.frame;
    CGFloat toolViewHeight = 44;
    if (toolViewFrame.origin.y != screenHeight - keyboardSize.height - toolViewHeight) {
        NSLog(@"show1 y %f",self.toolView.frame.origin.y);
        toolViewFrame.origin.y = screenHeight - keyboardSize.height - toolViewHeight;//lxf
        contentTVFrame.size.height = screenHeight - keyboardSize.height - toolViewHeight - self.mediaView.frame.size.height - contactsView.frame.size.height;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.contentTV.frame = contentTVFrame;
                             self.toolView.frame = toolViewFrame;
                             self.mediaView.frame = mediaViewFrame;
                         } completion:^(BOOL finished) {
                             mediaViewFrame.origin.y = toolView.frame.origin.y - mediaView.frame.size.height;
                             self.contentTV.frame = contentTVFrame;
                             self.toolView.frame = toolViewFrame;
                             self.mediaView.frame = mediaViewFrame;
//                             NSLog(@"show2 y %f",self.toolView.frame.origin.y);

                         }];
        
    }
//    NSLog(@"show");
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    CGFloat toolViewHeight = 44;
    
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect contentTVFrame = self.contentTV.frame;
    __block CGRect toolViewFrame = self.toolView.frame;
    __block CGRect mediaViewFrame = self.mediaView.frame;

    
    contentTVFrame.size.height = viewHeight - TOP_BAR_HEIGHT - contactsView.frame.size.height - toolView.frame.size.height;
    toolViewFrame.origin.y = contentTVFrame.origin.y + contentTVFrame.size.height;//lxf

    
    mediaViewFrame.origin.y = toolViewFrame.origin.y - mediaView.frame.size.height;
    self.contentTV.frame = contentTVFrame;
    self.toolView.frame = toolViewFrame;
    self.mediaView.frame = mediaViewFrame;
    
    NSLog(@"hide");
    //    [UIView animateWithDuration:fAniTimeSecond animations:^{
    //        self.viewItems.frame = frame;
    //    }];
}


- (IBAction)chooseContactsAction:(id)sender {
    [self setHidesBottomBarWhenPushed:YES];
    [contentTV resignFirstResponder];
    ChooseMassContactViewController *chooseMassContactViewController = [[ChooseMassContactViewController alloc]initWithNibName:@"ChooseMassContactViewController" bundle:nil];
    [self.navigationController pushViewController:chooseMassContactViewController animated:YES];
    
}
- (IBAction)choosePhotoAction:(id)sender {
    [self pickImageFromAlbum];
}

- (IBAction)chooseTemplateAction:(id)sender {
    [self setHidesBottomBarWhenPushed:YES];
    [contentTV resignFirstResponder];
    ChooseTemplateViewController *chooseTemplateViewController = [[ChooseTemplateViewController alloc]initWithNibName:@"ChooseTemplateViewController" bundle:nil];
    chooseTemplateViewController.delegate = self;
    [self.navigationController pushViewController:chooseTemplateViewController animated:YES];
//    [self pickImageFromTake];
}

- (IBAction)recordAudioButton:(id)sender {
    
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
        CGFloat photoHeight = 0;
        CGFloat photoWidth = 0;
        CGFloat mediaHeight = 0;
        CGFloat photoY = 0;
        if (SCREEN_RECT.size.height == 568) {
            photoWidth = 44;
            photoHeight = 44;
            mediaHeight = 64;
            photoY = 10;
        } else{
            photoWidth = 30;
            photoHeight = 30;
            mediaHeight = 44;
            photoY = 7;
        }
        UIImage *editedImage = [[UIImage alloc] init];
        editedImage = image;
        CGRect rect = CGRectMake(0, 0, photoWidth, photoHeight);
        UIGraphicsBeginImageContext(rect.size);
        [editedImage drawInRect:rect];
        editedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        [self.mediaView setFrame:CGRectMake(0, self.toolView.frame.origin.y - mediaHeight, self.view.frame.size.width, mediaHeight)];
        [self.mediaView setBackgroundColor:[UIColor colorWithWhite:235.0/255 alpha:1.0]];
        
        if ([photoArray count] < 4) {
            [photoArray addObject:editedImage];
        }
        for (UIView * photo in mediaView.subviews) {
            if ([photo isKindOfClass:[UIImageView class]]) {
                [photo removeFromSuperview];
            }
        }
        for (int i = 0; i < [photoArray count]; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i * (44 + 6), photoY, photoWidth, photoHeight)];
            UIImage *image = [photoArray objectAtIndex:i];
            [imageView setImage:image];
            [mediaView addSubview:imageView];
        }
        
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
#pragma ChooseTemplateDelegate mark
- (void)ChooseTemplateController:(ChooseTemplateViewController *)controller passBackWithTemplate:(XXTMessageTemplate *)msgTemplate{
    NSString *content = msgTemplate.content;
    placeHolder.text = @"";
    [self.contentTV setText:content];
}
@end
