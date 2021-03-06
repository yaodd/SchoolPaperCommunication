//
//  ChatViewController.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ChatViewController.h"
#import "XXTModelGlobal.h"
#import "PersonDetailViewController.h"
#import "Dao.h"
//#import <Foundation/Foundation.h>
#import "BubbleView.h"
#import "VoiceView.h"
#import "ImageView.h"
#import "XXTModelController.h"
#define BUBBLE_VIEW_TAG     111111
#define VOICE_VIEW_TAG      222222
#define IMAGE_VIEW_TAG      333333
#define HEAD_VIEW_TAG       444444

@interface ChatViewController ()
{
    NSMutableArray *aryMessages;  //数据源
    
    //用于录音
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
        
    
    XXTModelGlobal *modelGlobal;
    XXTUserRole *userRole;
    
}

@end

@implementation ChatViewController
@synthesize sendButton;
@synthesize sendTextField;
@synthesize sendView;
@synthesize chatTableView;
@synthesize recordButton;
@synthesize avPlay;
@synthesize currentPid;

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
    [self initLayout];
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
//初始化布局
- (void)initLayout{
    UIBarButtonItem *detailButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"usersinfo"] style:UIBarButtonItemStylePlain target:self action:@selector(detailAction:)];
    self.navigationItem.rightBarButtonItem = detailButton;
    CGFloat sendViewHeight = 44;
    self.chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - sendViewHeight - TOP_BAR_HEIGHT)];
    [self.chatTableView setBackgroundColor:[UIColor colorWithRed:230.0/255 green:243.0/255 blue:250.0/255 alpha:1.0]];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTapGesture:)];
    [self.chatTableView addGestureRecognizer:tapGesture];
    [self.view addSubview:chatTableView];
    
    self.sendView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - sendViewHeight - TOP_BAR_HEIGHT, self.view.frame.size.width, sendViewHeight)];
    [self.sendView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:sendView];
    UIView *sepector = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    [sepector setBackgroundColor:[UIColor colorWithWhite:187.0/255 alpha:1.0]];
    [self.sendView addSubview:sepector];
    
    CGFloat leftButtonX = 5;
    CGFloat buttonY = 6;
    self.imagePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imagePickerButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [self.imagePickerButton setImage:[UIImage imageNamed:@"photo_click"] forState:UIControlStateHighlighted];
    [self.imagePickerButton setFrame:CGRectMake(leftButtonX, buttonY, 33, 33)];
    [self.imagePickerButton addTarget:self action:@selector(imagePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView addSubview:self.imagePickerButton];

    leftButtonX += (33 + 8);
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [self.recordButton setImage:[UIImage imageNamed:@"record_click"] forState:UIControlStateHighlighted];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.recordButton setFrame:CGRectMake(leftButtonX, buttonY, 33, 33)];
    [self.recordButton addTarget:self action:@selector(beginRecord:) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchDragExit];
    [self.recordButton addTarget:self action:@selector(finishRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView addSubview:self.recordButton];
    
    leftButtonX += (33 + 8);
    self.sendTextField = [[UITextField alloc]initWithFrame:CGRectMake(leftButtonX, buttonY, 189, 32)];
    self.sendTextField.delegate = self;
    [self.sendTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.sendTextField.layer setCornerRadius:5];
    [self.sendTextField.layer  setBorderWidth:1];
    [self.sendTextField.layer setBorderColor:[UIColor colorWithWhite:187.0/255 alpha:1.0].CGColor];
    [self.sendTextField setPlaceholder:@"输入消息"];
    [self.sendView addSubview:self.sendTextField];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setFrame:CGRectMake(self.view.frame.size.width - sendViewHeight - 6, 0, 56, 44)];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.sendButton setTintColor:[UIColor colorWithRed:13.0/255 green:152.0/255 blue:219.0/255 alpha:1.0]];
    [self.sendView addSubview:sendButton];
}
//个人详细信息响应
- (void)detailAction:(id)sender{
    [self setHidesBottomBarWhenPushed:YES];
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonDetailViewController *personDetailViewController = [storyborad instantiateViewControllerWithIdentifier:@"PersonDetail"];
    [personDetailViewController setCurrentPid:currentPid];
    [self.navigationController pushViewController:personDetailViewController animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
}
//点击tableView任何地方都收起键盘
- (void)tableViewTapGesture:(id)sender{
    [self.sendTextField resignFirstResponder];
}
//初始化历史消息记录
- (void)initHistoryMsg{
    modelGlobal = [XXTModelGlobal sharedModel];
    userRole = modelGlobal.currentUser;
    NSArray *hisMsgArray = [userRole getMessagesBetweenMeAndPerson:currentPid];
    NSLog(@"array count %d",[hisMsgArray count]);
    aryMessages = [NSMutableArray array];
    for (XXTMessageBase *message in hisMsgArray) {
        [aryMessages addObject:message];
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
    NSString *content = [sendTextField text];
    if (content.length != 0) {
        XXTMessageSend *msg = [[XXTMessageSend alloc]initWithGroupIds:nil personIds:[NSArray arrayWithObjects:currentPid, nil] content:content images:nil audio:nil];
        [aryMessages addObject:msg];
        [self.chatTableView reloadData];
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:YES];
        [self sendWithMessage:msg];
    }
    else{
        NSLog(@"发送内容不能为空！");
    }
    
}
//发送消息函数
- (void)sendWithMessage:(XXTMessageSend *)message{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(sendMsgSelector:) object:message];
    [thread start];
}
//异步发送消息
- (void)sendMsgSelector:(XXTMessageSend *)msg{
    if (msg.content == nil) {
        msg.content = @"";
    }
    Dao *dao = [Dao sharedDao];
    [XXTModelController prepareToInstantMessage:msg];
    NSInteger isSuccess = [dao requestForSendInstantMessage:msg];
    if (isSuccess) {
        NSLog(@"消息发送成功");
    }
    
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
    __block CGRect frame2 = self.chatTableView.frame;
    CGFloat sendViewHeight = 44;
    if (frame.origin.y != screenHeight - keyboardSize.height - sendViewHeight) {
        frame.origin.y = screenHeight - keyboardSize.height - sendViewHeight;//lxf
        frame2.origin.y = screenHeight - keyboardSize.height - frame2.size.height - sendViewHeight;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.sendView.frame = frame;
                             self.chatTableView.frame = frame2;
                         } completion:^(BOOL finished) {
                             self.sendView.frame = frame;
                             self.chatTableView.frame = frame2;
                         }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    CGFloat sendViewHeight = 44;

    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect frame = self.sendView.frame;
    __block CGRect frame2 = self.chatTableView.frame;
    frame.origin.y = screenHeight - sendViewHeight;//lxf
    frame2.origin.y = 0;
    self.sendView.frame = frame;
    self.chatTableView.frame = frame2;
    
    //    [UIView animateWithDuration:fAniTimeSecond animations:^{
    //        self.viewItems.frame = frame;
    //    }];
}
-(void)textFieldDoneEditing: (id) sender
{
    NSLog(@"resign");
	[sender resignFirstResponder];
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
    XXTMessageBase *message = [aryMessages objectAtIndex:row];
    CGFloat height = 0;
    UIFont *font = [UIFont systemFontOfSize:16];
	CGSize size = [message.content sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    height = size.height;
    if (message.content.length == 0) {
        if ([message.audios count] != 0) {
            height = 22;
        }
        else if ([message.images count] != 0) {
            height = 150;
        }

    }
    return height + 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XXTMessageBase *msg = [aryMessages objectAtIndex:indexPath.row];
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
        [photo.layer setCornerRadius:23.0f];
        [photo setTag:HEAD_VIEW_TAG];
        [cell addSubview:photo];
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    BubbleView *bubbleView = (BubbleView *)[cell viewWithTag:BUBBLE_VIEW_TAG];
    VoiceView *voiceView = (VoiceView *)[cell viewWithTag:VOICE_VIEW_TAG];
    ImageView *imageView = (ImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
    UIImageView *photo = (UIImageView *)[cell viewWithTag:HEAD_VIEW_TAG];
    if ([msg isKindOfClass:[XXTMessageSend class]]) {
        photo.frame = CGRectMake(10, 10, 46, 46);
        [photo setImage:[UIImage imageNamed:@"photo1"]];
    } else{
        photo.frame = CGRectMake(320-56, 10, 46, 46);
        [photo setImage:[UIImage imageNamed:@"photo"]];
    }

    if (msg.content.length != 0) {
        [bubbleView setHidden:NO];
        [bubbleView setData:msg];
        [voiceView setHidden:YES];
        [imageView setHidden:YES];
        
    } else if ([msg.audios count] != 0) {
        [voiceView setHidden:NO];
        [voiceView setData:msg];
        [bubbleView setHidden:YES];
        [imageView setHidden:YES];
    } else if ([msg.images count] != 0){
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
    XXTMessageReceive *msg = [[XXTMessageReceive alloc]initWithContent:@"位家长、同学、教师，新年快乐，在新的一年里，祝大家身体健康！" imageObjects:nil audioObjects:nil];
    
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
        
        NSData *data = [NSData dataWithContentsOfURL:urlPlay];
        XXTAudio *audio = [[XXTAudio alloc]init];
        audio.audiodata = data;
        audio.duration = cTime;
        XXTMessageSend *msg = [[XXTMessageSend alloc]initWithGroupIds:nil personIds:[NSArray arrayWithObjects:currentPid, nil] content:nil images:nil audio:[NSArray arrayWithObjects:audio, nil]];
        [aryMessages addObject:msg];
        [self.chatTableView reloadData];
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:YES];
        [self sendWithMessage:msg];
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
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing =YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//打开相机,从相机获取
- (void)touch_photo:(id)sender {
    // for iphone
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        
    }
    imagePicker.delegate =self;
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
        
        UIImage *editedImage = [[UIImage alloc] init];
        editedImage = image;
        CGRect rect = CGRectMake(0, 0, 150, 150);
        UIGraphicsBeginImageContext(rect.size);
        [editedImage drawInRect:rect];
        editedImage = UIGraphicsGetImageFromCurrentImageContext();
        XXTImage *xxtImage = [[XXTImage alloc]init];
        xxtImage.thumbPicImage = editedImage;
        xxtImage.originPicImage = image;
        XXTMessageSend *msg = [[XXTMessageSend alloc]initWithGroupIds:nil personIds:[NSArray arrayWithObjects:currentPid, nil] content:nil images:[NSArray arrayWithObjects:xxtImage, nil] audio:nil];
        [aryMessages addObject:msg];
        [self.chatTableView reloadData];
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height) animated:YES];
        [self sendWithMessage:msg];//发送
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"MEdia");
    }
}

#pragma VoiceViewDelegate mark -
- (void)playAudio:(XXTAudio *)audio{
    if (self.avPlay.playing) {
        [self.avPlay stop];
        return;
    }
    if (audio.audiodata != nil) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:audio.audiodata error:nil];
        self.avPlay = player;
        [self.avPlay play];
        NSLog(@"play");
    } else{
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadAudio:) object:audio];
        [thread start];
    }
}
//下载音频
- (void)downloadAudio:(XXTAudio *)audio{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:audio.audioURL]];
    if (data != nil) {
        audio.audiodata = data;
        [self playAudio:audio];//如果下载成功，递归回去播放音频.
    }
    
}

@end
