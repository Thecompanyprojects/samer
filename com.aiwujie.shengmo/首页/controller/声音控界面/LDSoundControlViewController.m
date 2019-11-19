//
//  LDSoundControlViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/16.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSoundControlViewController.h"
#import "LDOwnInformationViewController.h"
#import "SoundControlCell.h"
#import "SoundControlModel.h"
#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface LDSoundControlViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) AVPlayer *audioPlayer;//音频播放器，用于播放录音文件

@property (nonatomic,copy) NSString *media;//录音文件

//首页tableview及数据源
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

//分页page
@property (nonatomic,assign) int tablePage;

//存储正在播放的按钮
@property (nonatomic,strong) SoundControlCell *selectCell;

@end

@implementation LDSoundControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"声音控";
    _dataArray = [NSMutableArray array];
    [self createTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _tablePage = 0;
        [self createDatatype:@"1"];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _tablePage++;
        [self createDatatype:@"2"];
    }];
    [self createButton];
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"录制语音"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getUserInfoUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            RecordViewController *rvc = [[RecordViewController alloc] init];
            rvc.mediaString = responseObj[@"data"][@"media"];
            [self.navigationController pushViewController:rvc animated:YES];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)createDatatype:(NSString *)type{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,userListNewthUrl];
    
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"layout":@"1",@"type":@"4",@"loginid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]?:@""};

    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000 && integer != 2001) {
            if (integer == 4001) {
                if ([type intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [_tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            if ([type intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SoundControlModel class] json:responseObj[@"data"]]];
            [self.dataArray addObjectsFromArray:data];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count?:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SoundControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundControl"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SoundControlCell" owner:self options:nil].lastObject;
    }
    if (indexPath.row==self.dataArray.count-1) {
        [cell.lineView setHidden:YES];
    }
    else
    {
        [cell.lineView setHidden:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        SoundControlModel *model = _dataArray[indexPath.row];
        cell.model = model;
        if ([_media isEqualToString:model.media] && _audioPlayer != nil) {
            if (_audioPlayer.rate == 1) {
                [cell.playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
            }else if (_audioPlayer.rate == 0){
                [cell.playButton setBackgroundImage:[UIImage imageNamed:@"播放暂停"] forState:UIControlStateNormal];
            }
        }else{
            [cell.playButton setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
        }
    }
    [cell.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)playButtonClick:(UIButton *)button{
    SoundControlCell *cell = (SoundControlCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SoundControlModel *model = _dataArray[indexPath.row];
    if ([_media isEqualToString:model.media]) {
        _selectCell = cell;
        if (_audioPlayer.rate == 1) {
            [cell.playButton setBackgroundImage:[UIImage imageNamed:@"播放暂停"] forState:UIControlStateNormal];
            [_audioPlayer pause];
        }else if (_audioPlayer.rate == 0){
            [cell.playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
            [_audioPlayer play];
        }
    }else{
        if (_audioPlayer != nil) {
            [self playDidFinish];
        }
        _media = model.media;
        _selectCell = cell;
        [cell.playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
        self.audioPlayer = [self myAudioPlayer];
        [self addDistanceNotification];
        [self setAudioSessionPlay];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.audioPlayer play];
        //播放完毕发出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    SoundControlModel *model = _dataArray[indexPath.row];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
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
    _media = @"";
    if (_selectCell != nil) {
        [_selectCell.playButton setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
        _selectCell = nil;
    }
    [self removeDistanceNotification];
    NSLog(@"播放完毕");
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVPlayer *)myAudioPlayer{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"AVPlayer初始化了");
    NSError *error=nil;
    if (error || _media.length == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"创建播放器过程中发生错误~"];
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    _audioPlayer=[[AVPlayer alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_media]]];
    return _audioPlayer;
}

/**
 *  添加距离通知
 */
- (void)addDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
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
        
    }else{
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_audioPlayer != nil) {
        [self playDidFinish];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
