//
//  ChatViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ChatViewController.h"
//#import <Foundation/Foundation.h>
#import "BubbleView.h"
#import "VoiceView.h"
#import "ImageView.h"
#define BUBBLE_VIEW_TAG     111111
#define VOICE_VIEW_TAG      222222
#define IMAGE_VIEW_TAG      333333
#define HEAD_VIEW_TAG       444444
@interface ChatViewController ()
{
    NSMutableArray *aryMessages;
    
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
        
    UIImagePickerController *imagePicker;
}

@end

@implementation ChatViewController
@synthesize sendButton;
@synthesize sendTextField;
@synthesize sendView;
@synthesize chatTableView;
@synthesize recordButton;
@synthesize avPlay;

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
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = self.chatWithUser;
   
    [self initHistoryMsg];
    [self initFresh];
    [self initRecord];
    AppDelegate *appDelegate = [self appDelegate];
    appDelegate.chatDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	// Do any additional setup after loading the view.
}
//初始化历史消息记录
- (void)initHistoryMsg{
    aryMessages = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        MessageVO *msg = [[MessageVO alloc]init];
        msg.strId = @"strId";
        msg.strText = @"adwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdwadwdasdw";
        msg.strUserid = @"userId";
        msg.strTime = @"2011/11/11";
        msg.strFromUsername = @"FromUserName";
        msg.strToUsername = @"toUserName";
        if (i % 2) {
            msg.msgMode = kMsgMode_Receive;
        } else{
            msg.msgMode = kMsgMode_Send;
        }
        if (i % 3 == 0) {
            msg.msgType = kMsgType_Audio;
        } else if (i % 3 == 1){
            msg.msgType = kMsgType_Text;
        } else{
            msg.msgType = kMsgType_Image;
        }
        [aryMessages addObject:msg];
    }
}

//初始化下拉刷新
- (void)initFresh{
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.chatTableView.bounds.size.height, self.view.frame.size.width, self.chatTableView.bounds.size.height)];
        view.delegate = self;
        [self.chatTableView addSubview:view];
        _refreshHeaderView = view;
//        [view release];
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}
- (void)initRecord{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    urlPlay = url;
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

//发送消息
- (void)sendAction:(id)sender{
    NSString *sendText = [sendTextField text];
    MessageVO *msg = [[MessageVO alloc]init];
    msg.strId = @"strId";
    msg.strText = sendText;
    msg.strUserid = @"userId";
    msg.strTime = @"2022/12/22";
    msg.strFromUsername = @"FromUserName";
    msg.strToUsername = @"toUserName";
    msg.msgMode = kMsgMode_Send;
    [aryMessages addObject:msg];
    [self.chatTableView reloadData];
    [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect frame = self.sendView.frame;
    
    if (frame.origin.y != screenHeight - keyboardSize.height - 40.) {
        frame.origin.y = screenHeight - keyboardSize.height - 40.;//lxf
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.sendView.frame = frame;
                             
                         } completion:^(BOOL finished) {
                             self.sendView.frame = frame;
                         }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect frame = self.sendView.frame;
    frame.origin.y = screenHeight- 40;//lxf
    self.sendView.frame = frame;
    
    //    [UIView animateWithDuration:fAniTimeSecond animations:^{
    //        self.viewItems.frame = frame;
    //    }];
}


#pragma mark -
//取得当前程序的委托
-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryMessages count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"height");
    int row = [indexPath row];
    MessageVO *message = [aryMessages objectAtIndex:row];
    CGFloat height = 0;
    UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [message.strText sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    height = size.height;
    
    if (message.msgType == kMsgType_Audio) {
        height = 22;
    }
    if (message.msgType == kMsgType_Image) {
        height = 150;
    }
    return height + 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageVO *msg = [aryMessages objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        BubbleView *bubbleView = [[BubbleView alloc]initWithDefault];
        [bubbleView setTag:BUBBLE_VIEW_TAG];
        [bubbleView setHidden:YES];
        [cell addSubview:bubbleView];
        
        VoiceView *voiceView = [[VoiceView alloc]initWithDefault];
        [voiceView setTag:VOICE_VIEW_TAG];
        [voiceView setHidden:YES];
        voiceView.delegate = self;
        [cell addSubview:voiceView];
        
        ImageView *imageView = [[ImageView alloc]initWithDefault];
        [imageView setTag:IMAGE_VIEW_TAG];
        [imageView setHidden:YES];
        [cell addSubview:imageView];
        
        UIImageView *photo = [[UIImageView alloc]init];
        [photo.layer setMasksToBounds:YES];
        [photo.layer setCornerRadius:10.0f];
        [photo setTag:HEAD_VIEW_TAG];
        [cell addSubview:photo];
    }
    BubbleView *bubbleView = (BubbleView *)[cell viewWithTag:BUBBLE_VIEW_TAG];
    VoiceView *voiceView = (VoiceView *)[cell viewWithTag:VOICE_VIEW_TAG];
    ImageView *imageView = (ImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
    UIImageView *photo = (UIImageView *)[cell viewWithTag:HEAD_VIEW_TAG];
    if (msg.msgMode == kMsgMode_Send) {
        photo.frame = CGRectMake(320-60, 10, 50, 50);
        [photo setImage:[UIImage imageNamed:@"photo1"]];
        NSLog(@"1");
    } else{
        photo.frame = CGRectMake(10, 10, 50, 50);
        [photo setImage:[UIImage imageNamed:@"photo"]];
        NSLog(@"2");
    }

    if (msg.msgType == kMsgType_Text) {
        [bubbleView setHidden:NO];
        [bubbleView setData:msg];
        [voiceView setHidden:YES];
        [imageView setHidden:YES];
        
    } else if (msg.msgType == kMsgType_Audio) {
        [voiceView setHidden:NO];
        [voiceView setData:msg];
        [bubbleView setHidden:YES];
        [imageView setHidden:YES];
    } else{
        [imageView setHidden:NO];
        [imageView setData:msg];
        [bubbleView setHidden:YES];
        [voiceView setHidden:YES];
    }
    
    return cell;
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods


- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
    
}

- (void)doneLoadingTableViewData{
    NSLog(@"new1");
    //  model should call this when its done loading
    MessageVO *msg = [[MessageVO alloc]init];
    msg.strId = @"newID";
    msg.strText = @"大家好哇！！！";
    msg.strUserid = @"userId";
    msg.strTime = @"2011/11/11";
    msg.strFromUsername = @"newName";
    msg.strToUsername = @"toUserName";
    //    [aryMessages addObject:msg];
    [aryMessages insertObject:msg atIndex:0];
    [self.chatTableView reloadData];

        _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.chatTableView];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
- (IBAction)imagePickerAction:(id)sender {
//    [self pickImageFromAlbum];
    [self touch_photo:sender];
}

- (IBAction)beginRecord:(id)sender {
    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        NSLog(@"begin");
        [recorder record];
    }
    
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

- (IBAction)finishRecord:(id)sender {
    double cTime = recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
        NSLog(@"发出去");
        MessageVO *msg = [[MessageVO alloc]init];
        msg.audioTime = (NSInteger)cTime;
        msg.audioUrl = urlPlay;
        msg.msgMode = kMsgMode_Send;
        msg.msgType = kMsgType_Audio;
        [aryMessages addObject:msg];
        [self.chatTableView reloadData];
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:YES];
    }else {
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    [recorder stop];
    [timer invalidate];
}
- (IBAction)cancelRecord:(id)sender {
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    
    NSLog(@"取消发送");
}

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    /*
    if (0<lowPassResults<=0.06) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
     */
}
//从相册获取图片
- (void)pickImageFromAlbum
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing =YES;
    
//    [self presentModalViewController:imagePicker animated:YES];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//打开相机,从相机获取
- (IBAction)touch_photo:(id)sender {
    // for iphone
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate =self;
    pickerImage.allowsEditing =YES;//自定义照片样式
    [self presentViewController:pickerImage animated:YES completion:nil];
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
        
        UIImage *editedImage = [[UIImage alloc] init];
        editedImage = image;
        CGRect rect = CGRectMake(0, 0, 150, 150);
        UIGraphicsBeginImageContext(rect.size);
        [editedImage drawInRect:rect];
        editedImage = UIGraphicsGetImageFromCurrentImageContext();
        MessageVO *msg = [[MessageVO alloc]init];
        msg.image = editedImage;
        msg.msgMode = kMsgMode_Send;
        msg.msgType = kMsgType_Image;
        [aryMessages addObject:msg];
        [self.chatTableView reloadData];
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"MEdia");
    }
}

#pragma VoiceViewDelegate mark -
- (void)playAudio:(NSURL *)url{
    if (self.avPlay.playing) {
        [self.avPlay stop];
        return;
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.avPlay = player;
    [self.avPlay play];
    NSLog(@"play");
}

@end
