//
//  RecordViewController.m
//  yupaopao
//
//  Created by a on 16/8/15.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "VoiceRecordTableViewCell.h"

//#import "EMVoiceConverter.h"

@interface RecordViewController (){
    
    NSURL *_recordedTmpFile;
}

@property (nonatomic,strong) AVPlayer *audioPlayer;//音频播放器，用于播放录音文件

@property (nonatomic,copy) NSString *mediaalong;

@end

@implementation RecordViewController


AVAudioRecorder *recorder;
NSError *error;
VoiceRecordTableViewCell *voiceRecordView;

static int myTime = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"录制语音";
    
    [self createButton];
    
    [_voiceRecordButton addTarget:self action:@selector(voiceButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_voiceRecordButton addTarget:self action:@selector(voiceButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceRecordButton addTarget:self action:@selector(voiceButtonTouchUpOutside:) forControlEvents:UIControlEventTouchDragExit];
    
    voiceRecordView = [[NSBundle mainBundle]loadNibNamed:@"VoiceRecordTableViewCell" owner:self options:nil].firstObject;

    voiceRecordView.frame = CGRectMake((WIDTH - 180)/2, (HEIGHT - 400)/2, 180, 200);
    voiceRecordView.hidden = NO;
    [self.view addSubview:voiceRecordView];
}

- (void)voiceButtonTouchDown:(UIButton *) button{
    
    if (_recordedTmpFile == nil) {
        
         NSLog(@"开始录音");
        
        if (![self.audioRecorder isRecording]) {
            
            myTime = 0;
            
            _limitTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(audiotimerLimit) userInfo:nil repeats:YES];
            
            [self setAudioSession];
            [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
            self.timer.fireDate = [NSDate distantPast];
        }

    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已有语音,请删除后重新录制~"];
    
    }
    
}

-(void)audiotimerLimit{

    myTime++;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1) {
        if (myTime == 30) {
            
            [AlertTool alertWithViewController:self andTitle:@"录音结束" andMessage:@"最多允许录音30秒~"];

            [self.audioRecorder stop];
            
            self.timer.fireDate = [NSDate distantFuture];
            
            [_limitTimer invalidate];
            
            _limitTimer = nil;
        }
    }
    else
    {
        if (myTime == 10) {
            
            [AlertTool alertWithViewController:self andTitle:@"录音结束" andMessage:@"最多允许录音10秒~"];

            [self.audioRecorder stop];
            
            self.timer.fireDate = [NSDate distantFuture];
            
            [_limitTimer invalidate];
            
            _limitTimer = nil;
        }
    }

    
}

- (void)voiceButtonTouchUpInside:(UIButton *) button{
//    voiceRecordView.hidden = YES;
    [self.audioRecorder stop];
    
    self.timer.fireDate = [NSDate distantFuture];
    
    NSLog(@"松开录音按钮");
}

- (void)voiceButtonTouchUpOutside:(UIButton *) button{
    NSLog(@"取消录音");
    [self.audioRecorder deleteRecording];
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    [_limitTimer invalidate];
    
    _limitTimer = nil;
    
    if (flag) {
        
        if (myTime <= 2) {
            
            [self.audioRecorder deleteRecording];
            
            _recordedTmpFile = nil;
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"录音需大于2秒~"];
            
        }else{
        
            _recordedTmpFile = recorder.url;
            
            _mediaalong = [NSString stringWithFormat:@"%.f",roundf([self getVoiceDurationSeconds])];
            
//           NSLog(@"%f,%.f",[self getVoiceDurationSeconds],roundf([self getVoiceDurationSeconds]));
        }
        
    }else{
    
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"录音失败~"];
        
    }
    
//    NSLog(@"%@",recorder.url);
    
}
- (IBAction)playButtonClick:(id)sender {
    
    if (_recordedTmpFile != nil) {
        
        self.audioPlayer = [self myAudioPlayer];
        
        [self addDistanceNotification];
        
        [self setAudioSessionPlay];
        
        [_audioPlayer play];
        
        //播放完毕发出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"没有要播放的语音~"];
    
    }
}

/**
 *  设置音频会话
 */
-(void)setAudioSessionPlay{
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

-(void)playDidFinish{
    
    _audioPlayer = nil;
    
    [self removeDistanceNotification];
    
    NSLog(@"播放完毕");
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVPlayer *)myAudioPlayer{
    
    NSLog(@"AVPlayer初始化了");
    NSError *error=nil;
    
    _audioPlayer=[[AVPlayer alloc]initWithURL:_recordedTmpFile];
    
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    
    return _audioPlayer;
}


- (IBAction)deleteButtonClick:(id)sender {
    
    if (_recordedTmpFile != nil) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除录制的语音"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [_audioRecorder deleteRecording];
            
            _recordedTmpFile = nil;
            
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"没有要删除的语音~"];
    
    }
}

#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:@"myrecord.wav"];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

-(float)getVoiceDurationSeconds{
    NSURL * nsurl = [self getSavePath];
    
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:nsurl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(44100) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSLog(@"AVAudioRecorder初始化了");
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/50.0)*(power+60.0);
    [voiceRecordView setImageByVoiceVolume:(int)(progress*10)];
    NSLog(@"音频强度%f",power);
}

/**
 *  添加距离通知
 */
- (void)addDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

/**
 *  删除距离通知
 */
- (void)removeDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

#pragma mark - 处理近距离监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//传感器已启动前提条件下，如果用户接近 近距离传感器，此时属性值为YES
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

//页面消失的时候结束语音播放
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    if (_audioPlayer != nil) {
        
        [self playDidFinish];
        
    }
}

- (void)createButton {
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
}

-(void)rightButtonOnClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"删除已上传语音" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
    
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/mediaDel"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [action setValue:MainColor forKey:@"_titleTextColor"];
        
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    [alert addAction:cancel];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)backButtonOnClick{
    
    if (_recordedTmpFile == nil) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存录制的语音"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSData *recordData = [NSData dataWithContentsOfURL:_recordedTmpFile];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.wav", str];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/MediaUpload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                //            NSString *file = [NSString string];
                //            file = [[self getSavePath] absoluteString];
                //以文件流的格式
                [formData appendPartWithFileData:recordData name:@"file" fileName:fileName mimeType:@"wav"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [_timer invalidate];
                
                _timer = nil;
                
                [self createMediaData:responseObject[@"data"]];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);
                
            }];
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)createMediaData:(NSString *)media{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/MediaEdit"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"media":media,@"mediaalong":_mediaalong};
   
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            if (self.mediaString.length != 0) {
                
                [self deleteOldMediaData];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [_audioRecorder deleteRecording];
                
                _recordedTmpFile = nil;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

-(void)deleteOldMediaData{
    
    NSDictionary *parameters = @{@"filename":_mediaString};

    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:delPicture] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [_audioRecorder deleteRecording];
            
            _recordedTmpFile = nil;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
