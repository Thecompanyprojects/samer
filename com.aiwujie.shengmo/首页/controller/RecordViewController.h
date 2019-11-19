//
//  RecordViewController.h
//  yupaopao
//
//  Created by a on 16/8/15.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机

@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）

@property (nonatomic,strong) NSTimer *limitTimer;//录音时间的计时,用于限制录音时间

@property (weak, nonatomic) IBOutlet UIButton *voiceRecordButton;

@property (nonatomic,copy) NSString *mediaString;

@end
