//
//  ChatViewController.h
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-11-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "EGORefreshTableHeaderView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "VoiceView.h"
@interface ChatViewController : ViewController <UITableViewDataSource,
                                                UITableViewDelegate,
                                                ChatDelegate,
                                                EGORefreshTableHeaderDelegate,
                                                AVAudioRecorderDelegate,
                                                UIImagePickerControllerDelegate,
                                                UINavigationControllerDelegate,
                                                    VoiceViewDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (strong, nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) UIView *sendView;
@property (strong, nonatomic) UITextField *sendTextField;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (strong, nonatomic) UIButton *imagePickerButton;

@property (strong, nonatomic) NSString *chatWithUser;
- (IBAction)imagePickerAction:(id)sender;

- (IBAction)beginRecord:(id)sender;
- (IBAction)finishRecord:(id)sender;
- (IBAction)cancelRecord:(id)sender;

- (IBAction)sendAction:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
