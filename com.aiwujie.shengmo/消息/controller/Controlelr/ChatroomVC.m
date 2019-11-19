//
//  ChatroomVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/24.
//  Copyright © 2019 a. All rights reserved.
//

#import "ChatroomVC.h"
#import "XYreadoneCell.h"
#import "XYreadoneContent.h"
#import "XYredMessageCell.h"
#import "XYredMessageContent.h"
#import "LDOwnInformationViewController.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"
#import "FlowFlower.h"
#import "XYreadoneCell.h"
#import "XYreadoneContent.h"
#import "NTImageBrowser.h"
#import "LDMemberViewController.h"
//照片选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "groupinfoModel.h"
#import "LDGiftgrouplistVC.h"
#import "ToreceiveViewController.h"
#import "redgrouplistVC.h"
#import "XYgiftMessageContent.h"
#import "LDMyWalletPageViewController.h"
#import "SendredsViewController.h"
#import "SendNav.h"
#import "XYgiftgroupMessageCell.h"
#import "XYgiftMessageContent.h"
#import "charuserinfoView.h"
#import <RongRTCLib/RongRTCLib.h>
#import "chatpersonViewModel.h"
#import "enterRoomView.h"
#import "roominfoView.h"
#import "YSActionSheetView.h"
#import "LDChargeCenterViewController.h"
#import "XYchatroomContent.h"
#import "LDchatroominfoVC.h"
#import "chatuserinfolistView.h"
#import "SuspensionAssistiveTouch.h"
#import "myroominfoView.h"
#import "UIButton+MSExtendTouchArea.h"
#import "mikeinfoView.h"
#import "chatmikeModel.h"
#import "chatmikelistView.h"
#import "newgiftshowView.h"
#import "chatpersonModel.h"

@interface ChatroomVC ()<RCPluginBoardViewDelegate,TZImagePickerControllerDelegate,RongRTCRoomDelegate,roomDelegate,userlistDelegate,mkinfoDelegate,mikelistDelegate,RongRTCActivityMonitorDelegate>
{
    CGRect viewRect;
}

@property (nonatomic,strong) UIView *navbgView;
@property (nonatomic,assign) NSInteger messageId;
@property (nonatomic,assign) BOOL isadmin;
//礼物界面
@property (nonatomic,strong) GifView *gif;
@property (nonatomic,assign) BOOL isgif;
/**
 创建礼物掉落的效果
 */
//创建礼物下落的定时器
@property (nonatomic,strong) NSTimer * gifTimer;
//掉落礼物的view
@property (nonatomic,strong) FlowFlower *flowFlower;
//存储选中的礼物
@property (nonatomic,strong) UIImage *gifImage;
//掉落的时间
@property (nonatomic,assign) int second;
@property (nonatomic,copy)   NSString *sendimgUrl;
@property (nonatomic,strong) groupinfoModel *infoModel;
@property (nonatomic,assign) BOOL iscanPush;
@property (nonatomic,strong) NSMutableArray *sendimageUrl;
@property (nonatomic,strong) RongRTCRoom *room;
@property (nonatomic,strong) NSMutableArray<RongRTCAVInputStream *>*Newstreams;
@property (nonatomic,strong) charuserinfoView *personView;

@property (nonatomic,strong) mikeinfoView *infoView;
@property (nonatomic,strong) UIImageView *mikeBtn1;
@property (nonatomic,strong) UIButton *infoBtn;
@property (nonatomic,strong) UIButton *choosevoiceBtn;
@property (nonatomic,assign) BOOL isSounds;
@property (nonatomic,strong) chatpersonViewModel *viewModel;
@property (nonatomic,copy)   NSString *total;
@property (nonatomic,copy)   NSString *rule;
@property (nonatomic,strong) enterRoomView *enterView;
@property (nonatomic,strong) roominfoView *alertView;
@property (nonatomic,strong) myroominfoView *myalertView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,copy)   NSString *userID;
@property (nonatomic,copy)   NSString *mink0userId;
@property (nonatomic,copy)   NSString *mink1userId;
@property (nonatomic,strong) chatuserinfolistView *userlistView;
@property (nonatomic,strong) chatmikelistView *mikelistView;
@property (nonatomic,copy)   NSString *popStr;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *bgView;
//允许上麦人数
@property (nonatomic,copy) NSString *micnum;
//
@property (nonatomic,copy) NSString *mictype;
@property (nonatomic,strong) NSMutableArray *mikeinfoArray;
@property (nonatomic,strong) NSMutableArray *useridArray;

@property (nonatomic,strong) newgiftshowView *giftshowView;
@end

@implementation ChatroomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popStr = @"1";
    // Do any additional setup after loading the view.

    self.isSounds = YES;
    self.mink0userId = @"";
    self.mink1userId = @"";
    self.Newstreams = [NSMutableArray array];
    self.mikeinfoArray = [NSMutableArray array];
    self.useridArray = [NSMutableArray array];
    [self createHeadView];
    
    self.conversationType = ConversationType_CHATROOM;
    self.targetId = self.roomidStr;
    [[RCIMClient sharedRCIMClient] joinChatRoom:self.targetId messageCount:10 success:^{
        
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"加入聊天室失败"];
        });
    }];
    self.sendimageUrl = [NSMutableArray array];
    //注册自定义消息Cell
    [self registerClass:[XYgiftgroupMessageCell class] forMessageClass:[XYgiftMessageContent class]];
    [self registerClass:[XYredMessageCell class] forMessageClass:[XYredMessageContent class]];
    [self registerClass:[XYreadoneCell classForKeyedArchiver] forMessageClass:[XYreadoneContent class]];
    
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self addredEnvelope];
    self.conversationMessageCollectionView.frame = CGRectMake(0, 190, WIDTH, HEIGHT-190);
    
    // 加入房间
    [self extracted];
    [self getuserlist];
    [self isshowbtnClick];
    [self createdicinfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstNotificationFunc:) name:@"chatroomgif" object:nil];
    
    self.giftshowView.frame = CGRectMake(WIDTH, 190, 300, 46);
    [self.view addSubview:self.giftshowView];
    [RongRTCEngine sharedEngine].monitorDelegate = self;
}

- (void)didReportStatForm:(RongRTCStatisticalForm*)form
{
    NSMutableArray *useridarray = [NSMutableArray array];
    if (form.recvStats.count!=0) {
        for (int i = 0; i<form.recvStats.count; i++) {
            RongRTCStreamStat *stat = [form.recvStats objectAtIndex:i];
            NSString *talkid = stat.trackId;
            if ([stat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
                NSArray *arrays = [talkid componentsSeparatedByString:@"_"];
                NSString *userid = [arrays firstObject];
                [useridarray addObject:userid];
            }
            self.infoView.talkArray = [NSMutableArray array];
            self.infoView.talkArray = useridarray;
         
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.infoView.collectionView reloadData];
            });
        }
    }
}

/**
 接受到有人送礼物的消息

 @param notification 礼物消息
 */
- (void)firstNotificationFunc:(NSNotification *)notification{
    NSString *name = [notification name];
    NSLog(@"打印%@",name);
    NSDictionary *dict = notification.object;
    
    NSString *msgtext = [dict objectForKey:@"msgtext"]?:@"";
    NSString *sendtype = [dict objectForKey:@"sendtype"];
    NSString *giftname = [dict objectForKey:@"giftname"];
    
    XYChatroomgiftContent *xychat = [XYChatroomgiftContent new];
    xychat.msgtext = msgtext.copy;
    xychat.sendtype = sendtype.copy;
    xychat.giftname = giftname.copy;
    
    [self.room setRoomAttributeValue:@"str" forKey:@"key" message:xychat completion:^(BOOL isSuccess, RongRTCCode desc) {

    }];
}

/**
 加入聊吧
 */
- (void)extracted {

    [[RongRTCEngine sharedEngine] joinRoom:self.roomidStr completion:^(RongRTCRoom * _Nullable room, RongRTCCode code) {
        self.room = room;
        room.delegate = self;
        [[RongRTCAVCapturer sharedInstance] useSpeaker:YES];
        
        //获取全部订阅
        for (RongRTCRemoteUser *user in room.remoteUsers) {
            
            if (user.remoteAVStreams.count!=0) {
                [self.useridArray addObject:user.userId];
            }
            for (RongRTCAVInputStream *stream in user.remoteAVStreams) {
                [self.Newstreams addObject:stream];
                
                if (stream.state == RongRTCInputStreamStateNormal) {
                    
                }
            }
        }
        //订阅资源
        [self.room.remoteUsers.firstObject subscribeAVStream:self.Newstreams tinyStreams:nil completion:^(BOOL isSuccess, RongRTCCode desc) {

        }];
        
        [self creatmikeuserlistwith:self.useridArray];
    }];
}

/**
 获取聊吧信息
 */
-(void)createdicinfo
{
    NSString *roomid = self.roomidStr?:@"";
    NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
    [NetManager afPostRequest:url parms:@{@"roomid":roomid?:@""} finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dit = [responseObj objectForKey:@"data"];
            self.infoDic = [NSDictionary dictionary];
            self.infoDic = dit.copy;
            self.titleLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"",@")"];
            [self.bgView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"background"]]];
            self.micnum = [dit objectForKey:@"micnum"];
            self.mictype = [dit objectForKey:@"mictype"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 麦上人员列表数据
 */
-(void)creatmikeuserlistwith:(NSMutableArray *)userArray
{
    NSString *uids = [userArray componentsJoinedByString:@","];
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/getUsersPic"];
    NSDictionary *params = @{@"uid":uids,@"roomid":roomidStr};
    
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            self.infoView.dataSource = [NSMutableArray array];
            NSArray *data = [NSArray yy_modelArrayWithClass:[chatmikeModel class] json:responseObj[@"data"]];
            [self.infoView.dataSource addObjectsFromArray:data];
            [self.infoView.collectionView reloadData];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 是否展示麦上头像
 */
-(void)isshowbtnClick
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/chatmikeOpenOrClose"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            NSString *state = [NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
            if ([state intValue]==1) {
               
                [self.mikeBtn1 setHidden:NO];
                [self.choosevoiceBtn setHidden:NO];
            }
            else    
            {
               
                [self.mikeBtn1 setHidden:YES];
                [self.choosevoiceBtn setHidden:YES];
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 获取用户列表
 */
-(void)getuserlist
{
    self.viewModel = [[chatpersonViewModel alloc] init];
    self.viewModel = [[chatpersonViewModel alloc] init];
    [self.viewModel getNewsList];
    self.personView.delegate = self;

    self.personView.dataSource = [NSMutableArray array];
    [self.viewModel chooseInfo];
    self.rule = self.viewModel.rule;
    __weak typeof(self) weakSelf = self;
    weakSelf.viewModel.newsListBlock = ^{
        weakSelf.personView.dataSource = weakSelf.viewModel.news;
        weakSelf.total = weakSelf.viewModel.total;
        weakSelf.titleLab.text = [NSString stringWithFormat:@"%@%@%@%@",[weakSelf.infoDic objectForKey:@"name"]?:@"",@"(",weakSelf.total?:@"",@")"];
        [weakSelf.personView.collectionView reloadData];
    };
    weakSelf.viewModel.infoBlock = ^{
        weakSelf.rule = weakSelf.viewModel.rule;
    };
}


/**
 监听发布的资源消息

 @param streams 发布的资源消息
 */
-(void)didPublishStreams:(NSArray<RongRTCAVInputStream *> *)streams{
    
    NSString *newUid = [NSString new];
    if (self.mink0userId.length==0) {
        if (streams.count!=0) {
            self.mink0userId = [streams firstObject].userId;
            newUid = self.mink0userId.copy;
        }
    }
    else
    {
        if (streams.count>=2) {
            self.mink1userId = [streams objectAtIndex:1].userId;
            newUid = self.mink1userId.copy;
        }
    }
    
    NSString *url = [PICHEADURL stringByAppendingString:getUserInfoUrl];
    NSDictionary *parameters;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        parameters = @{@"uid":newUid?:@"",@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }else{
        parameters = @{@"uid":newUid?:@"",@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
            NSString *nickname = responseObj[@"data"][@"nickname"];
            NSString *msg = [NSString stringWithFormat:@"%@上麦成功",nickname?:@""];
            if ([self.rule intValue]==1) {
                [MBProgressHUD showMessage:msg toView:self.view];
            }

        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
    if (self.isSounds) {
        self.Newstreams = streams.copy;
        // 订阅资源
        [self.room.remoteUsers.firstObject subscribeAVStream:self.Newstreams tinyStreams:nil completion:^(BOOL isSuccess, RongRTCCode desc) {
            NSLog(@"---desc%ld",(long)desc);

        }];
    }
    
    if (streams.count!=0) {
        
        for (int i = 0; i<streams.count; i++) {
            RongRTCAVInputStream *stream = [streams objectAtIndex:i];
            if(stream.streamType==RTCMediaTypeAudio)
            {
                [self.useridArray addObject:stream.userId];
                [self creatmikeuserlistwith:self.useridArray];
            }
        }

    }
}

/**
 取消发布资源

 @param streams 资源消息
 */
- (void)didUnpublishStreams:(NSArray<RongRTCAVInputStream *>*)streams
{
    if ([self.rule intValue]==1) {
         [MBProgressHUD showMessage:@"下麦成功"];
    }
    
    NSString *userId = [streams firstObject].userId;

    
    //取消订阅资源
    [self.room.remoteUsers.firstObject unsubscribeAVStream:streams completion:^(BOOL isSuccess, RongRTCCode desc) {

    }];
    
    if ([self.useridArray indexOfObject:userId] != NSNotFound) {
        NSInteger inde =[self.useridArray indexOfObject:userId];
        [self.useridArray removeObjectAtIndex:inde];
        [self creatmikeuserlistwith:self.useridArray];
    }else{
        
        NSLog(@"不存在");
    }
    
}

/**
 用户加入

 @param user 新加入的用户
 */
-(void)didJoinUser:(RongRTCRemoteUser*)user
{
    [self getuserlist];
    NSString *url = [PICHEADURL stringByAppendingString:getUserInfoUrl];
    NSString *uid = [NSString stringWithFormat:@"%@",user.userId];
    NSDictionary *params = [NSDictionary new];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        params = @{@"uid":uid?:@"",@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }else{
        params = @{@"uid":uid?:@"",@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSString *name = [data objectForKey:@"nickname"]?:@"";
            NSString *headPic = [data objectForKey:@"head_pic"]?:@"";
            [self.enterView.iconimg sd_setImageWithURL:[NSURL URLWithString:headPic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            self.enterView.nameLab.text = [NSString stringWithFormat:@"%@%@",name,@" 来了"];
            
            self.enterView.frame = CGRectMake(WIDTH, HEIGHT-130, 200, 34);
            [self.view addSubview:self.enterView];
            [UIView animateWithDuration:1
                             animations:^{
                                 
                self.enterView.transform = CGAffineTransformMakeTranslation(-160, 0);
            }completion:^(BOOL finished) {
                
                int64_t delayInSeconds = 1; // 延迟的时间
                __weak typeof(self)weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     //weakSelf.enterView.transform = CGAffineTransformIdentity;
                    [UIView animateWithDuration:1 animations:^{
                        //weakSelf.enterView.transform = CGAffineTransformMakeTranslation(0, 0);
                        weakSelf.enterView.alpha = 0.1;
                    } completion:^(BOOL finished) {
                        weakSelf.enterView.transform = CGAffineTransformIdentity;
                        weakSelf.enterView.alpha = 1;
                    }];
                });
            }];
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 用户离开

 @param user 离开人员
 */
-(void)didLeaveUser:(RongRTCRemoteUser*)user
{
    [self getuserlist];
}

/**
 创建头部视图
 */
-(void)createHeadView
{
    self.bgView= [UIImageView new];
    self.bgView.frame = CGRectMake(0, 0, WIDTH, 90);
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"background"]]];
    self.bgView.userInteractionEnabled = YES;
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:normal];
    backBtn.frame = CGRectMake(12, 50, 16, 22);
    [backBtn addTarget:self action:@selector(backBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn extendTouchArea:UIEdgeInsetsMake(10, 10, 30, 10)];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.frame = CGRectMake(30, 50, WIDTH-60, 22);
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"",@")"];
    self.titleLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backBtnclick)];
    [self.titleLab addGestureRecognizer:singleTap22];
    
    self.choosevoiceBtn = [[UIButton alloc] init];
    self.choosevoiceBtn.frame = CGRectMake(WIDTH-90, 50, 35, 35);
    [self.choosevoiceBtn setImage:[UIImage imageNamed:@"打开声音"] forState:normal];
    [self.choosevoiceBtn addTarget:self action:@selector(voiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.infoBtn = [[UIButton alloc] init];
    self.infoBtn.frame = CGRectMake(WIDTH-50, 50, 35, 35);
    [self.infoBtn setImage:[UIImage imageNamed:@"聊天室详情"] forState:normal];
    [self.infoBtn addTarget:self action:@selector(infoBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.mikeBtn1 = [[UIImageView alloc] init];
    self.mikeBtn1.frame = CGRectMake(WIDTH-128, 50, 34, 34);
    self.mikeBtn1.image = [UIImage imageNamed:@"排麦"];
    self.mikeBtn1.userInteractionEnabled = YES;
    self.mikeBtn1.layer.masksToBounds = YES;
    self.mikeBtn1.layer.cornerRadius = 17;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mikebtn1Click)];
    [self.mikeBtn1 addGestureRecognizer:singleTap1];
    
    self.navbgView = [[UIView alloc] init];
    if (ISIPHONEX) {
        self.navbgView.frame = CGRectMake(0, 0, WIDTH, 88);
    }else{
        self.navbgView.frame = CGRectMake(0, 0, WIDTH, 64);;
    }
    
    [self.navbgView addSubview:self.bgView];
    
    self.navbgView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:self.navbgView];
    
    [self setCustomLeftButtonItem];

    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    
    [self.bgView addSubview:backBtn];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.choosevoiceBtn];
    [self.bgView addSubview:self.infoBtn];
    [self.bgView addSubview:self.mikeBtn1];

    [self.navigationController.view addSubview:self.bgView];
    
    self.personView = [[charuserinfoView alloc] init];
    self.personView.frame = CGRectMake(0, 140, WIDTH-50, 50);
    self.personView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.personView];
    
    self.infoView = [[mikeinfoView alloc] init];
    self.infoView.delegate = self;
    self.infoView.dataSource = [NSMutableArray array];
    self.infoView.frame = CGRectMake(0, 90, WIDTH, 50);
    self.infoView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    [self.view addSubview:self.infoView];
    
    UIButton *userlistBtn = [[UIButton alloc] init];
    userlistBtn.frame = CGRectMake(WIDTH-45, 145, 40, 40);
    [userlistBtn setImage:[UIImage imageNamed:@"聊天室-人员列表"] forState:normal];
    [userlistBtn addTarget:self action:@selector(userlistbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userlistBtn];
    
}

- (void)setCustomLeftButtonItem{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame =CGRectMake(0, 0, 57, 44);
    [btn setTitle:@"" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    UIBarButtonItem *leftItem0 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem0;
}

-(void)notifyUpdateUnreadMessageCount
{
    [super notifyUpdateUnreadMessageCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCustomLeftButtonItem];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    });
}

-(enterRoomView *)enterView
{
    if(!_enterView)
    {
        _enterView = [[enterRoomView alloc] init];
    }
    return _enterView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navbgView.hidden = NO;
    self.bgView.hidden = NO;
    [self vhl_setNavBarShadowImageHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navbgView.hidden = YES;
    self.bgView.hidden = YES;
    [self vhl_setNavBarShadowImageHidden:NO];
}

/**
 聊天页面发红包 礼物  闪照
 */
-(void)addredEnvelope
{
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-礼物"] title:@"礼物" atIndex:6 tag:2001];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-红包"] title:@"红包" atIndex:7 tag:2002];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"闪照"] title:@"闪照" atIndex:8 tag:2003];
}


/**
 页面pop消失

 @param parent 当前页面
 */
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        
        if (self.popBlock) {
            self.popBlock(@"");
        }
        
        if ([self.rule intValue]==1) {
            if (self.myBlock) {
                self.myBlock([NSDictionary dictionary]);
            }
        }
        if ([self.popStr intValue]==1) {
            [SuspensionAssistiveTouch defaultTool].str0 = self.mink0userId.copy;
            [SuspensionAssistiveTouch defaultTool].str1 = self.mink1userId.copy;
            [SuspensionAssistiveTouch defaultTool].infoDic = self.infoDic.copy;
            [SuspensionAssistiveTouch defaultTool].roomidStr = self.roomidStr.copy;
            [[SuspensionAssistiveTouch defaultTool] showView];
        }
        
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId success:^{
            
        } error:^(RCErrorCode status) {
            
        }];
    }
}

#pragma mark -

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if (tag==2001) {
        
        //礼物功能
        self.isgif = YES;
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:NO :^{
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            cvc.type = @"0";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        _gif.isfromGroup = YES;
        _gif.groupid = self.roomidStr;
        [_gif getPersonUid:self.targetId andSign:@"赠送给某人"andUIViewController:self];
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            
            NSString *imagename = [dic objectForKey:@"image"];
            NSDictionary *para = @{@"number":dic[@"num"],@"imageName":imagename,@"orderid":dic[@"orderid"]};
            XYgiftMessageContent *addcontent = [XYgiftMessageContent messageWithDict:para];
            addcontent.number = dic[@"num"];
            addcontent.imageName = dic[@"image"];
            addcontent.orderid = dic[@"orderid"];
            
            [weakSelf sendMessage:addcontent pushContent:@"礼物"];
            
            RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"你给大家打赏了礼物" extra:nil];
            BOOL saveToDB = YES; //是否保存到数据库中
            RCMessage *savedMsg;
            if (saveToDB) {
                savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];
            } else {
                savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];
            }
            [weakSelf appendAndDisplayMessage:savedMsg];
        };
        [self.tabBarController.view addSubview:_gif];
    }
    if (tag==2002) {
        
        kPreventRepeatClickTime(2);
        self.isgif = NO;
        
        SendredsViewController * allTicketVC = [[SendredsViewController alloc] init];// 包装一个导航栏控制器
        SendNav * nav = [[SendNav alloc]initWithRootViewController:allTicketVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        allTicketVC.myBlock = ^(NSDictionary * _Nonnull dic) {
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *fuid = self.targetId;
            NSString *time = [[TimeManager defaultTool] getNowTimeTimestamp];
            NSString *orderid = [NSString stringWithFormat:@"%@%@%@",uid,fuid,time];
            
            NSString *message = [dic objectForKey:@"message"];
            if (message.length==0) {
                message = @"恭喜发财，大吉大利";
            }

            NSString *url = [PICHEADURL stringByAppendingString:qunGiveRedbagUrl];
            NSString *num = [dic objectForKey:@"money"];
            NSString *nums = [dic objectForKey:@"number"];
            NSDictionary *params = @{@"uid":uid,@"num":num,@"nums":nums,@"orderid":orderid};
            
            [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    __weak typeof (self) weakSelf = self;
                    XYredMessageContent *addcontent = [[XYredMessageContent alloc] init];
                    addcontent.message = message;
                    addcontent.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
                    addcontent.isopen = @"0";
                    addcontent.orderid = orderid;

                    [weakSelf sendMessage:addcontent pushContent:message];
                }else
                {
                    [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        };
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    if (tag==2003) {
        //阅后即焚
        self.isgif = YES;
        self.sendimgUrl = [NSString new];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1) {
            self.sendimgUrl = [NSString new];
            TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:9 delegate:self];
            imagePC.isSelectOriginalPhoto = NO;
            imagePC.allowTakePicture = YES; // 在内部显示拍照按钮
            imagePC.allowPickingVideo = NO;
            imagePC.allowPickingImage = YES;
            imagePC.allowPickingOriginalPhoto = NO;
            imagePC.barItemTextColor = TextCOLOR;
            imagePC.barItemTextFont = [UIFont systemFontOfSize:14];
            [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
                
            }];
            [self presentViewController:imagePC animated:YES completion:^{
                
            }];
        }else
        {
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"闪图限vip可用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"闪图" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"开通vip" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }];
            [control addAction:action0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:^{
                
            }];
        }
    }
}

/**
 * 重写方法，过滤消息或者修改消息
 *
 * @param messageCotent 消息内容
 *
 * @return 返回消息内容
 */
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    [super willSendMessage:messageCotent];
    return messageCotent;
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    if ([model.objectName isEqualToString:@"ec:groupgiftinfo"]) {
        
        kPreventRepeatClickTime(2);
        
        XYgiftMessageContent *cons = (XYgiftMessageContent*)model.content;
        NSString *orderid = cons.orderid;
        NSDictionary *params = @{@"orderid":orderid?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        NSString *url = [PICHEADURL stringByAppendingString:@"Api/friend/getQunGift"];
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                
                //礼物
                _gifTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                //face
                XYgiftMessageContent *oldHongBao = (XYgiftMessageContent *)model.content;
                
                UIImage *faceImage = [UIImage imageNamed:oldHongBao.imageName];
                [[NSRunLoop currentRunLoop] addTimer:_gifTimer forMode:NSRunLoopCommonModes];
                //飞行
                _flowFlower = [FlowFlower flowerFLow:@[faceImage]];
                [_flowFlower startFlyFlowerOnView:self.view];
                
                NSString *giftstr = [NSString stringWithFormat:@"%@",@"你领取了Ta的礼物"];
                RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:giftstr extra:nil];
                BOOL saveToDB = YES; //是否保存到数据库中
                RCMessage *savedMsg;
                if (saveToDB) {
                    savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];
                    
                } else {
                    savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_RECEIVE messageId:-1 content:warningMsg];
                }
                [self appendAndDisplayMessage:savedMsg];
                
            }
            else
            {
                
                [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
                LDGiftgrouplistVC *vc = [[LDGiftgrouplistVC alloc] init];
                vc.imageName = cons.imageName;
                vc.number = cons.number;
                vc.orderid = cons.orderid;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }
    
    if ([model.objectName isEqualToString:@"ec:groupenvelopeinfo"]) {
        //红包
        kPreventRepeatClickTime(5);
        XYredMessageContent *cons = (XYredMessageContent*)model.content;
        NSString *messge = cons.message;
        BOOL iscan = YES;
        NSString *str1 = @"";
        if (model.extra.length!=0) {
            str1 = [model.extra substringToIndex:1];
        }
        else
        {
            str1 = @"0";
        }
        NSString *str2 = [cons.isopen substringToIndex:1];
        if (model.extra.length!=0) {
            if ([str1 isEqualToString:@"1"]) {
                iscan = NO;
                
            }
            else
            {
                iscan = YES;
                
            }
        }
        else
        {
            if ([str2 isEqualToString:@"0"]) {
                iscan = YES;
            }
            else
            {
                iscan = NO;
            }
        }
        if (!iscan)
        {
            redgrouplistVC *VC = [redgrouplistVC new];
            VC.message = cons.message;
            VC.orderid = cons.orderid;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            
            NSString *newsurl = [PICHEADURL stringByAppendingString:yetRedbagUrl];
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSDictionary *checkprara = @{@"orderid":cons.orderid,@"uid":uid};
            [NetManager afPostRequest:newsurl parms:checkprara finished:^(id responseObj) {
                
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    redgrouplistVC *VC = [redgrouplistVC new];
                    VC.message = cons.message;
                    VC.orderid = cons.orderid;
                    [self.navigationController pushViewController:VC animated:YES];
                }
                else
                {
                    WSRewardConfig *info = ({
                        WSRewardConfig *info = [[WSRewardConfig alloc] init];
                        info.money = 100.0;
                        info.headImgurl = model.userInfo.portraitUri;
                        info.content = messge;
                        info.userName = model.userInfo.name;
                        info;
                    });
                    
                    [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
                        NSLog(@"取消领取");
                    } finishBlock:^(float money) {
                        NSLog(@"领取金额：%f",money);
                        
                        NSString *orderid = cons.orderid;
                        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
                        NSDictionary *params = @{@"uid":uid,@"orderid":orderid};
                        NSString *url = [PICHEADURL stringByAppendingString:qunGetRedbagUrl];
                        
                        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                            
                            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                                
                                XYredMessageContent *mes = [[XYredMessageContent alloc] init];
                                mes.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
                                mes.isopen = @"1";
                                mes.isopen = [NSString stringWithFormat:@"1/%@",model.messageUId];
                                RCMessage *oldMess = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
                                [[RCIMClient sharedRCIMClient] setMessageExtra:oldMess.messageId value:mes.isopen];
                                
                                for (RCMessageModel *model in self.conversationDataRepository) {
                                    if (model.messageId == oldMess.messageId) {
                                        if (model.messageId == oldMess.messageId) {
                                            XYredMessageContent *oldHongBao = (XYredMessageContent *)model.content;
                                            oldHongBao.isopen = mes.isopen;
                                            model.content = oldHongBao;
                                        }
                                    }
                                }
                                [self.conversationMessageCollectionView reloadData];
                                
                                NSString *giftstr = [NSString stringWithFormat:@"%@",@"你领取了Ta的红包"];
                                RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:giftstr extra:nil];
                                BOOL saveToDB = YES; //是否保存到数据库中
                                RCMessage *savedMsg;
                                if (saveToDB) {
                                    savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];
                                    
                                } else {
                                    savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_RECEIVE messageId:-1 content:warningMsg];
                                }
                                [self appendAndDisplayMessage:savedMsg];
                                
                                
                                redgrouplistVC *VC = [redgrouplistVC new];
                                VC.message = cons.message;
                                VC.orderid = cons.orderid;
                                [self.navigationController pushViewController:VC animated:YES];
                                
                                
                            }else
                            {
                                [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
                                redgrouplistVC *VC = [redgrouplistVC new];
                                VC.message = cons.message;
                                VC.orderid = cons.orderid;
                                [self.navigationController pushViewController:VC animated:YES];
                            }
                            
                        } failed:^(NSString *errorMsg) {
                            
                        }];
                        
                    }];
                }
                
            } failed:^(NSString *errorMsg) {
                
            }];
            
        }
    }
    
    if ([model.objectName isEqualToString:@"ec:messagereadone"]) {
        
        XYreadoneContent *content = (XYreadoneContent*)model.content;
        [[NTImageBrowser sharedShow] showImageBrowserWithImageView:content.imageUrl];
        
        XYreadoneContent *mes = [[XYreadoneContent alloc] init];
        mes.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
        mes.isopen = @"1";
        mes.isopen = [NSString stringWithFormat:@"1/%@",model.messageUId];
        RCMessage *oldMess = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
        [[RCIMClient sharedRCIMClient] setMessageExtra:oldMess.messageId value:mes.isopen];
        
        for (RCMessageModel *model in self.conversationDataRepository) {
            if (model.messageId == oldMess.messageId) {
                if (model.messageId == oldMess.messageId) {
                    XYreadoneContent *oldHongBao = (XYreadoneContent *)model.content;
                    oldHongBao.isopen = mes.isopen;
                    model.content = oldHongBao;
                }
            }
        }
        [self.conversationMessageCollectionView reloadData];
    }
}

/**
 礼物定时器release
 */
-(void)timeFireMethod{
    _second ++;
    if (_second >= 3) {
        [_flowFlower endFlyFlower];
        [_gifTimer invalidate];
        _flowFlower = nil;
        _gifTimer = nil;
    }
}
#pragma mark - TZImagePickerControllerDelegate

// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self thumbnaiWithImage:photos andAssets:assets];
}

//上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.sendimageUrl = [NSMutableArray array];
    // 创建一个队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    // 设置最大线程数
    queue.maxConcurrentOperationCount = 1;
    //创建一个队列数组
    NSMutableArray *operaQueueArray = [NSMutableArray array];
    for (NSInteger i = 0; i < imageArray.count; i++) {
        
        UIImageJPEGRepresentation(imageArray[i], 0.5);
        
        NSBlockOperation *blockOpera = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //默认创建的信号为0
            
            //网络请求
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 0.1);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                
                //上传的参数(上传图片，以文件流的格式)
                [formData appendPartWithFileData:imageData
                                            name:@"file"
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([[responseObject objectForKey:@"retcode"] intValue]==2000) {
                    NSString *str = [responseObject objectForKey:@"data"];
                    
                    self.sendimgUrl = [PICHEADURL stringByAppendingString:str];
                    [self.sendimageUrl addObject:self.sendimgUrl];
                    
                }
                else
                {
                    
                }
                dispatch_semaphore_signal(semaphore); //这里请求成功信号量 +1 为1
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_semaphore_signal(semaphore); //这里请求失败信号量 +1 为1
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //走到这里如果信号量为0 则不再执行下面的代码 一直等待 信号量不是0 出现 才会执行下面代码,然后信号量为 - 1
        }];
        
        //将创建的任务添加到数组中
        [operaQueueArray addObject:blockOpera];
    }
    //添加依赖关系
    for (int i = 0; i < operaQueueArray.count; i++) {
        if (i > 0) {
            [operaQueueArray[i] addDependency:operaQueueArray[i - 1]];
        }
    }
    [queue addOperations:operaQueueArray waitUntilFinished:NO];
    [queue addObserver:self forKeyPath:@"operationCount" options:0 context:nil];
    
}

//监听网络请求
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"operationCount"]) {
        NSOperationQueue *queue = (NSOperationQueue *)object;
        if (queue.operationCount == 0) {
            //主线程刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                for (int i = 0; i<self.sendimageUrl.count; i++) {
                    NSString *strs = [self.sendimageUrl objectAtIndex:i];
                    [self sendoneimage:strs];
                }
            });
        }
    }
}

#pragma mark - 发送及时消息

-(void)sendoneimage:(NSString *)urls
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1) {
        NSString *img = urls;
        NSDictionary *para = @{@"imageUrl":img,@"isopen":@"0"};
        XYreadoneContent *content = [XYreadoneContent messageWithDict:para];
        content.imageUrl = urls;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self sendMessage:content pushContent:dataStr];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能仅限VIP可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }
}

//点击聊天头像查看个人信息

- (void)didTapCellPortrait:(NSString *)userId{

    BOOL isshang;
    if ([userId intValue]==[self.mink0userId intValue]||[userId intValue]==[self.mink1userId intValue]) {
        isshang = YES;
    }
    else
    {
        isshang = NO;
    }
    [self showuserinfoView:userId andisshang:isshang];
}

-(void)createData:(NSString *)userId{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    avc.userID = userId;
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)backBtnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 语音聊天室功能

-(void)mikebtn1Click
{
    NSLog(@"排麦");
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.mikelistView];
    self.mikelistView.dataSource = [NSMutableArray array];
    self.mikelistView.delegate = self;
    [self.mikelistView.backBtn addTarget:self action:@selector(mikelistbackClick) forControlEvents:UIControlEventTouchUpInside];
    self.viewModel = [[chatpersonViewModel alloc] init];
    [self.viewModel getmikeinfo];
    self.rule = self.viewModel.rule;
    __weak typeof(self) weakSelf = self;
    weakSelf.viewModel.newsListBlock = ^{
        weakSelf.mikelistView.dataSource = weakSelf.viewModel.news;
        [weakSelf.mikelistView.table reloadData];
    };
    self.maskView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
    [UIView animateWithDuration:.35 animations:^{
        self.mikelistView.transform = CGAffineTransformMakeTranslation(-WIDTH+15, 0);
        self.maskView.alpha = .3;
        self.maskView.transform = CGAffineTransformMakeTranslation(0, -HEIGHT);
    }];
}

-(void)mikelistinfovc:(NSString *)userId
{
     [self createData:userId];
}

-(void)mikelistbackClick
{
    [UIView animateWithDuration:.35 animations:^{
        self.maskView.alpha = .0;
        self.maskView.transform = CGAffineTransformIdentity;
        self.mikelistView.transform = CGAffineTransformIdentity;
    }];
}

-(void)infoBtnClick
{
    LDchatroominfoVC *InfoVC = [[LDchatroominfoVC alloc] init];
    InfoVC.rule = self.rule.copy;
    InfoVC.infoDic = self.infoDic.copy;
    InfoVC.roomId = self.roomidStr;
    InfoVC.myBlock = ^(NSDictionary * _Nonnull dic) {
        NSString *roomid = self.roomidStr?:@"";
        NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
        [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                self.infoDic = [NSDictionary dictionary];
                self.infoDic = [responseObj objectForKey:@"data"];
                self.titleLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"",@")"];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    };
    [self.navigationController pushViewController:InfoVC animated:YES];
}

-(void)voiceBtnClick
{
    self.isSounds = !self.isSounds;
    if (self.isSounds) {
       
        [self.choosevoiceBtn setImage:[UIImage imageNamed:@"打开声音"] forState:normal];
        // 订阅资源
        [self.room.remoteUsers.firstObject subscribeAVStream:self.Newstreams tinyStreams:nil completion:^(BOOL isSuccess, RongRTCCode desc) {
            [self.choosevoiceBtn setImage:[UIImage imageNamed:@"打开声音"] forState:normal];
        }];
    }
    else
    {
        [self.choosevoiceBtn setImage:[UIImage imageNamed:@"静音1"] forState:normal];
        //取消订阅资源
        [self.room.remoteUsers.firstObject unsubscribeAVStream:self.Newstreams completion:^(BOOL isSuccess, RongRTCCode desc) {
             [self.choosevoiceBtn setImage:[UIImage imageNamed:@"静音1"] forState:normal];
        }];
    }
    
    if (!self.isSounds) {
        [[RongRTCAVCapturer sharedInstance] setMicrophoneDisable:YES];
    }else
    {
        [[RongRTCAVCapturer sharedInstance] setMicrophoneDisable:NO];
    }
}

#pragma mark - 弹出个人选项界面

-(void)showuserinfoView:(NSString *)userId andisshang:(BOOL )isshang;
{
    if ([userId intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        self.userID = userId.copy;
        self.maskView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
        [self.view addSubview:self.maskView];
        
        self.myalertView.userId = userId.copy;
        [self.myalertView getuserinfofromWeb];
        self.myalertView.isshang = isshang;
        
        if ([self.rule intValue]==1) {
            if (isshang) {
                [self.myalertView.mikeBtn setTitle:@"下麦" forState:normal];
            }
            else
            {
                if ([self.micnum intValue]>self.useridArray.count) {
                    [self.myalertView.mikeBtn setTitle:@"上麦" forState:normal];
                }
                else
                {
                    [self.myalertView.mikeBtn setTitle:@"排麦" forState:normal];
                }
            }
       }
       else
       {
           if (isshang) {
               [self.myalertView.mikeBtn setTitle:@"下麦" forState:normal];
           }
           else
           {
               //自由麦序
               if ([self.mictype intValue]==1) {
                   
                   NSMutableArray *array = [NSMutableArray new];
                   for (int i = 0; i<self.mikelistView.dataSource.count; i++) {
                       chatpersonModel *model = [self.mikelistView.dataSource objectAtIndex:i];
                       NSString *uid = model.uid;
                       [array addObject:uid];
                   }
                   BOOL isbool = [array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
                   if (isbool) {
                       [self.myalertView.mikeBtn setTitle:@"取消排麦" forState:normal];
                   }
                   else
                   {
                       if ([self.micnum intValue]>self.useridArray.count) {
                           //上麦
                           [self.myalertView.mikeBtn setTitle:@"上麦" forState:normal];
                       }
                       else
                       {
                           //排麦
                           [self.myalertView.mikeBtn setTitle:@"排麦" forState:normal];
                       }
                   }

                   
               }
               else
               {
                   
                   
                   NSMutableArray *array = [NSMutableArray new];
                   for (int i = 0; i<self.mikelistView.dataSource.count; i++) {
                       chatpersonModel *model = [self.mikelistView.dataSource objectAtIndex:i];
                       NSString *uid = model.uid;
                       [array addObject:uid];
                   }
                   BOOL isbool = [array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
                   if (isbool) {
                        [self.myalertView.mikeBtn setTitle:@"取消排麦" forState:normal];
                   }
                   else
                   {
                        [self.myalertView.mikeBtn setTitle:@"排麦" forState:normal];
                   }

               }
           
           }

       }
       
        self.myalertView.frame = CGRectMake(0, HEIGHT+20, WIDTH, 240);
        CGFloat hei;
        if (ISIPHONEX) {
            hei = 230;
        }
        else
        {
            hei = 200;
        }
        [self.view addSubview:self.myalertView];
        
        [UIView animateWithDuration:.35 animations:^{
            self.myalertView.transform = CGAffineTransformMakeTranslation(0, -hei);
            self.maskView.alpha = .3;
            self.maskView.transform = CGAffineTransformMakeTranslation(0, -HEIGHT);
        }];
    }
    else
    {
        self.userID = userId.copy;
        self.maskView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
        [self.view addSubview:self.maskView];
        self.alertView.userId = userId.copy;
        [self.alertView getuserinfofromWeb];
        self.alertView.isshang = isshang;
        if (isshang) {
            [self.alertView.mikeBtn setTitle:@"下麦" forState:normal];
        }
        else
        {
            [self.alertView.mikeBtn setTitle:@"上麦" forState:normal];
        }
        CGFloat hei = 300;
        if ([self.rule intValue]==1) {
            [self.alertView.mikeBtn setHidden:NO];
            [self.alertView.bannedBtn setHidden:NO];
            [self.alertView.kickedBtn setHidden:NO];
            
            self.alertView.frame = CGRectMake(0, HEIGHT+20, WIDTH, 300);
            hei = 300;
        }
        else
        {
            [self.alertView.mikeBtn setHidden:YES];
            [self.alertView.bannedBtn setHidden:YES];
            [self.alertView.kickedBtn setHidden:YES];
            self.alertView.frame = CGRectMake(0, HEIGHT+20, WIDTH, 240);
            hei = 240;
        }
        
        [self.view addSubview:self.alertView];
        
        [UIView animateWithDuration:.35 animations:^{
            self.alertView.transform = CGAffineTransformMakeTranslation(0, -hei);
            self.maskView.alpha = .3;
            self.maskView.transform = CGAffineTransformMakeTranslation(0, -HEIGHT);
        }];
    }
}

-(void)alertViewheadClick
{
    [self createData:self.userID];
}

-(roominfoView *)alertView
{
    if(!_alertView)
    {
        _alertView = [roominfoView new];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap222)];
        [_alertView addGestureRecognizer:singleTap];
        [_alertView.giftBtn addTarget:self action:@selector(giftbtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.focusBtn addTarget:self action:@selector(focusbtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.noticeBtn addTarget:self action:@selector(noticebtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.mikeBtn addTarget:self action:@selector(mikebtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.bannedBtn addTarget:self action:@selector(bannedbtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.kickedBtn addTarget:self action:@selector(kickedbtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.infoBtn addTarget:self action:@selector(alertViewheadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertView;
}

-(myroominfoView *)myalertView
{
    if(!_myalertView)
    {
        _myalertView = [[myroominfoView alloc] init];
        _myalertView.backgroundColor = [UIColor clearColor];
        _myalertView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap222)];
        [_myalertView addGestureRecognizer:singleTap];
        [_myalertView.infoBtn addTarget:self action:@selector(alertViewheadClick) forControlEvents:UIControlEventTouchUpInside];
        [_myalertView.mikeBtn addTarget:self action:@selector(mikebtnClick2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myalertView;
}

-(UIView *)maskView
{
    if(!_maskView)
    {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .0;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [_maskView addGestureRecognizer:singleTap];
    }
    return _maskView;
}

-(newgiftshowView *)giftshowView
{
    if(!_giftshowView)
    {
        _giftshowView = [[newgiftshowView alloc] init];
        
    }
    return _giftshowView;
}


-(void)handleSingleTap
{
    [UIView animateWithDuration:.35 animations:^{
        if ([self.userID intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            self.myalertView.transform = CGAffineTransformIdentity;
        }
        else
        {
             self.alertView.transform = CGAffineTransformIdentity;
        }
        self.maskView.alpha = .0;
        self.maskView.transform = CGAffineTransformIdentity;
        self.userlistView.transform = CGAffineTransformIdentity;
    }];
}

-(void)handleSingleTap222
{
    [UIView animateWithDuration:.35 animations:^{
        if ([self.userID intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            self.myalertView.transform = CGAffineTransformIdentity;
        }
        else
        {
            self.alertView.transform = CGAffineTransformIdentity;
        }
        self.maskView.alpha = .0;
        self.maskView.transform = CGAffineTransformIdentity;
    }];
}

-(void)giftbtnClick
{
    [self handleSingleTap];
    BOOL ismines = NO;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
        ismines = YES;
    }
    _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:ismines :^{
        LDChargeCenterViewController *cvc = [[LDChargeCenterViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
    _gif.isfromchatroom = YES;
    [_gif getPersonUid:self.userID andSign:@"赠送给某人"andUIViewController:self];
    [self.tabBarController.view addSubview:_gif];
}

-(void)focusbtnClick
{
    [self handleSingleTap];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.userID intValue]) {
        return;
    }
    if (self.alertView.isfocus) {
        //关注
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID?:@""};
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    else
    {
        //取消关注
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要取消悄悄关注吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID?:@""};
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setoverfollow];
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                
            } failed:^(NSString *errorMsg) {
                
            }];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }
}

-(void)noticebtnClick
{
    [self handleSingleTap];
    NSString *nickname = self.alertView.model.nickname?:@"";
    if (nickname.length!=0) {
        self.chatSessionInputBarControl.inputTextView.text = [NSString stringWithFormat:@"%@%@%@",@"@",nickname,@" "];
    }
}

-(void)mikebtnClick
{
    [self handleSingleTap];
    if ([self.rule intValue]==1) {
        if (!self.alertView.isshang) {
            
            if ([self.micnum intValue]>self.useridArray.count) {
                //上麦
                 [self othershangmai];
            }
            else
            {
                //排麦
                [self lineupmikeclick];
            }
        }
        else
        {
            //下麦
            if ([self.userID intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                [self minexiamai];
            }
            else
            {
                [self otherxiamai];
            }
        }
    }
}

-(void)mikebtnClick2
{
    [self handleSingleTap];
    if ([self.rule intValue]==1) {
        if (!self.myalertView.isshang) {
            if ([self.micnum intValue]>self.useridArray.count) {
                //上麦
                [self mineshangmai];
            }
            else
            {
                //排麦
                [self lineupmikeclick];
            }
        }
        else
        {
            [self minexiamai];
        }
    }
    else
    {
        if (self.myalertView.isshang) {
            [self minexiamai];
        }
        else
        {
            
            if ([self.mictype intValue]==1) {
                NSMutableArray *array = [NSMutableArray new];
                for (int i = 0; i<self.mikelistView.dataSource.count; i++) {
                    chatpersonModel *model = [self.mikelistView.dataSource objectAtIndex:i];
                    NSString *uid = model.uid;
                    [array addObject:uid];
                }
                BOOL isbool = [array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
                if (isbool) {
                    [self unlineupmikeclick];
                }
                else
                {
                    if ([self.micnum intValue]>self.useridArray.count) {
                        //上麦
                        [self mineshangmai];
                    }
                    else
                    {
                        //排麦
                        [self lineupmikeclick];
                    }
                }
            }
            else
            {
                NSMutableArray *array = [NSMutableArray new];
                for (int i = 0; i<self.mikelistView.dataSource.count; i++) {
                     chatpersonModel *model = [self.mikelistView.dataSource objectAtIndex:i];
                     NSString *uid = model.uid;
                     [array addObject:uid];
                 }
                 
                BOOL isbool = [array containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
                if (isbool) {
                    //取消排麦
                    [self unlineupmikeclick];
                }
                else
                {
                    //排麦
                    [self lineupmikeclick];
                }
            }
            

        }
    }
}

/**
 排麦
 */
-(void)lineupmikeclick
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/setChatListMic"];
    NSString *uid = self.myalertView.userId.copy?:@"";
    NSString *roomid = roomidStr.copy;
    NSDictionary *param = @{@"uid":uid,@"roomid":roomid};
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        NSString *msg = [responseObj objectForKey:@"msg"];
        [MBProgressHUD showMessage:msg];
    } failed:^(NSString *errorMsg) {
        
    }];
}

// 取消排麦
-(void)unlineupmikeclick
{
    NSString *url = [PICHEADURL stringByAppendingString:@"api/power/delChatListMic"];
    NSString *uid = self.myalertView.userId.copy?:@"";
    NSString *roomid = roomidStr.copy;
    NSDictionary *param = @{@"uid":uid,@"roomid":roomid};
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        NSString *msg = [responseObj objectForKey:@"msg"];
        [MBProgressHUD showMessage:msg];
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 管理员自己上麦
 */
-(void)mineshangmai
{
    //上麦
    if ([self.userID intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        NSString *url = [PICHEADURL stringByAppendingString:chatroomUpMicrophoneUrl];
        NSDictionary *params = @{@"roomid":self.roomidStr?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
//            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
                [self.room.localUser publishDefaultAVStream:^(BOOL isSuccess, RongRTCCode desc) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *name = self.myalertView.model.nickname;
                        NSString *msg = [NSString stringWithFormat:@"%@上麦成功",name];
                        [MBProgressHUD showMessage:msg toView:self.view];
                        [self.useridArray addObject:self.userID.copy];
                        [self creatmikeuserlistwith:self.useridArray];
                    });
                    
                }];
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

/**
 别人上麦
 */
-(void)othershangmai
{
    NSString *url = [PICHEADURL stringByAppendingString:chatroomUpMicrophoneUrl];
    NSDictionary *params = @{@"roomid":self.roomidStr,@"uid":self.alertView.model.uid?:@""};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
            XYchatroomContent *xychat = [XYchatroomContent new];
            xychat.userId = self.userID.copy;
            xychat.content = @"1";
            xychat.head_pic = self.alertView.model.head_pic?:@"";
            __weak typeof (self) weakSelf = self;
            [self.room setRoomAttributeValue:@"str" forKey:@"key" message:xychat completion:^(BOOL isSuccess, RongRTCCode desc) {
                
                NSString *name = weakSelf.alertView.model.nickname;
                NSString *msg = [NSString stringWithFormat:@"%@上麦成功",name];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:msg toView:weakSelf.view];
                    
                });
            }];

        
    } failed:^(NSString *errorMsg) {
        
    }];
}
    

/**
 自己下麦
 */
-(void)minexiamai
{
    NSString *url = [PICHEADURL stringByAppendingString:chatroomDownMicrophoneUrl];
    NSDictionary *params = @{@"roomid":self.roomidStr,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
            NSDictionary *data = [responseObj objectForKey:@"data"];

            if([data count]) {
                
                NSString *uid = [data objectForKey:@"uid"];
                NSString *url = [PICHEADURL stringByAppendingString:chatroomUpMicrophoneUrl];
                NSDictionary *params = @{@"roomid":self.roomidStr,@"uid":uid?:@""};
                [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                    
                    XYchatroomContent *xychat = [XYchatroomContent new];
                    xychat.userId = uid.copy;
                    xychat.content = @"1";
                    xychat.head_pic = [data objectForKey:@"head_pic"]?:@"";
                    __weak typeof (self) weakSelf = self;
                    [self.room setRoomAttributeValue:@"str" forKey:@"key" message:xychat completion:^(BOOL isSuccess, RongRTCCode desc) {
                        
                        NSString *name = [data objectForKey:@"nickname"];
                        NSString *msg = [NSString stringWithFormat:@"%@上麦成功",name];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showMessage:msg toView:weakSelf.view];
                            
                        });
                    }];
                    
                    
                } failed:^(NSString *errorMsg) {
                    
                }];
                
            }

            [self.room.localUser unpublishDefaultAVStream:^(BOOL isSuccess, RongRTCCode desc) {

                NSString *name = self.myalertView.model.nickname;
                NSString *msg = [NSString stringWithFormat:@"%@下麦成功",name];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:msg toView:self.view];
                    if ([self.useridArray indexOfObject:self.userID] != NSNotFound) {
                        NSInteger inde =[self.useridArray indexOfObject:self.userID];
                        [self.useridArray removeObjectAtIndex:inde];
                        [self creatmikeuserlistwith:self.useridArray];
                    }else{
                        
                        NSLog(@"不存在");
                    }
                });
                
            }];
        }
        else
        {
            [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"] toView:self.view];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 别人下麦
 */
-(void)otherxiamai
{
    NSString *url = [PICHEADURL stringByAppendingString:chatroomDownMicrophoneUrl];
    NSDictionary *params = @{@"roomid":self.roomidStr,@"uid":self.alertView.model.uid?:@""};
    
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            
            NSDictionary *data = [responseObj objectForKey:@"data"];
            if([data count]) {
                
                NSString *uid = [data objectForKey:@"uid"];
                NSString *url = [PICHEADURL stringByAppendingString:chatroomUpMicrophoneUrl];
                NSDictionary *params = @{@"roomid":self.roomidStr,@"uid":uid?:@""};
                [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                    
                    XYchatroomContent *xychat = [XYchatroomContent new];
                    xychat.userId = uid.copy;
                    xychat.content = @"1";
                    xychat.head_pic = [data objectForKey:@"head_pic"]?:@"";
                    __weak typeof (self) weakSelf = self;
                    [self.room setRoomAttributeValue:@"str" forKey:@"key" message:xychat completion:^(BOOL isSuccess, RongRTCCode desc) {
                        
                        NSString *name = [data objectForKey:@"nickname"];
                        NSString *msg = [NSString stringWithFormat:@"%@上麦成功",name];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showMessage:msg toView:weakSelf.view];
                            
                        });
                    }];
                    
                    
                } failed:^(NSString *errorMsg) {
                    
                }];
                
            }
            
            
            XYchatroomContent *xychat = [XYchatroomContent new];
            xychat.userId = self.userID.copy;
            xychat.content = @"0";
            xychat.head_pic = self.alertView.model.head_pic?:@"";
            __weak typeof (self) weakSelf = self;
            [self.room setRoomAttributeValue:@"str" forKey:@"key" message:xychat completion:^(BOOL isSuccess, RongRTCCode desc) {
                
                NSString *name = weakSelf.alertView.model.nickname;
                NSString *msg = [NSString stringWithFormat:@"%@下麦成功",name];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([weakSelf.useridArray indexOfObject:weakSelf.userID] != NSNotFound) {
                        NSInteger inde =[weakSelf.useridArray indexOfObject:weakSelf.userID];
                        [weakSelf.useridArray removeObjectAtIndex:inde];
                        [weakSelf creatmikeuserlistwith:weakSelf.useridArray];
                    }else{
                        NSLog(@"不存在");
                    }
                    [MBProgressHUD showMessage:msg toView:weakSelf.view];
                    
                });
            }];
        } else
        {
            [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"] toView:self.view];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

//禁言
-(void)bannedbtnClick
{
    [self handleSingleTap];
    if ([self.rule intValue]==1) {
        NSString *url = [PICHEADURL stringByAppendingString:chatroomUserGagAction];
        NSString *roomid = self.roomidStr;
        NSString *userid = self.userID?:@"";
        NSString *method = @"1";
        NSDictionary *para = @{@"roomid":roomid,@"userid":userid,@"method":method};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                [MBProgressHUD showMessage:@"禁言成功"];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

//踢出
-(void)kickedbtnClick
{
    [self handleSingleTap];
    if ([self.rule intValue]==1) {
        NSString *url = [PICHEADURL stringByAppendingString:chatroomUserBlockAction];
        NSString *roomid = self.roomidStr;
        NSString *userid = self.userID?:@"";
        NSString *method = @"1";
        NSDictionary *para = @{@"roomid":roomid,@"userid":userid,@"method":method};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                [MBProgressHUD showMessage:@"踢出成功"];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

- (void)didReceiveMessage:(RCMessage *)message
{
    if ([message.objectName isEqualToString:@"roomActionContent"]) {
        
        XYchatroomContent *content = (XYchatroomContent*)message.content;
        NSString *cons = content.content;
        NSString *userId = content.userId?:@"";

        if ([userId intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            if ([cons intValue]==1) {
                //上麦
                //发布资源
                [self.room.localUser publishDefaultAVStream:^(BOOL isSuccess, RongRTCCode desc) {
                    [self.useridArray addObject:userId];
                    [self creatmikeuserlistwith:self.useridArray];
                }];

            }
            if ([cons intValue]==0) {
                //下麦
               
                [self.room.localUser unpublishDefaultAVStream:^(BOOL isSuccess, RongRTCCode desc) {

                    if ([self.useridArray indexOfObject:userId] != NSNotFound) {
                        NSInteger inde =[self.useridArray indexOfObject:userId];
                        [self.useridArray removeObjectAtIndex:inde];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self creatmikeuserlistwith:self.useridArray];
                        });
                    }else{
                        
                        NSLog(@"不存在");
                    }
                    
                }];
            }
        }
    }
    if ([message.objectName isEqualToString:@"roomgiftContent"]) {
        XYChatroomgiftContent *content = (XYChatroomgiftContent*)message.content;
        NSString *sendtype = content.sendtype;
        NSString *msgtext = content.msgtext;
        NSString *giftname = content.giftname;
        
        if ([sendtype intValue]==1) {
            //礼物
            kPreventRepeatClickTime(5);
            int64_t delayInSeconds = 3; // 延迟的时间
            //飞行
            UIImage *faceImage = [UIImage imageNamed:giftname];
            _flowFlower = [FlowFlower flowerFLow:@[faceImage]];
            [_flowFlower startFlyFlowerOnView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_flowFlower endFlyFlower];
                _flowFlower = nil;
            });
        }
        else
        {
            NSLog(@"msgtext-%@",msgtext);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.giftshowView.messageLab.text = msgtext?:@"";
                self.giftshowView.giftImg.image = [UIImage imageNamed:giftname];
                [UIView animateWithDuration:2 animations:^{
                    self.giftshowView.transform = CGAffineTransformMakeTranslation(-240, 0);
                } completion:^(BOOL finished) {
                    int64_t delayInSeconds = 10; // 延迟的时间
                    __weak typeof(self)weakSelf = self;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [UIView animateWithDuration:2 animations:^{
                            weakSelf.giftshowView.alpha = 0.1;
                        } completion:^(BOOL finished) {
                            weakSelf.giftshowView.transform = CGAffineTransformIdentity;
                            weakSelf.giftshowView.alpha = 1;
                        }];
                    });
                }];
                
            });
        }
    }
}

- (void)didKickedOutOfTheRoom:(RongRTCRoom *)room
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touserinfovc:(NSString *)userId
{
    BOOL isshang;
    if ([self.useridArray indexOfObject:userId] != NSNotFound) {
        isshang = YES;
    }
    else
    {
        isshang = NO;
    }
    [self showuserinfoView:userId andisshang:isshang];
}

#pragma mark - 人员列表查看

-(chatuserinfolistView *)userlistView
{
    if(!_userlistView)
    {
        _userlistView = [[chatuserinfolistView alloc] init];
        _userlistView.layer.masksToBounds = YES;
        _userlistView.layer.cornerRadius = 5;
        _userlistView.frame = CGRectMake(WIDTH, 100, WIDTH-30, HEIGHT-100);
    }
    return _userlistView;
}

-(chatmikelistView *)mikelistView
{
    if(!_mikelistView)
    {
        _mikelistView = [[chatmikelistView alloc] init];
        _mikelistView.layer.masksToBounds = YES;
        _mikelistView.layer.cornerRadius = 5;
        _mikelistView.frame = CGRectMake(WIDTH, 100, WIDTH-30, HEIGHT-100);
    }
    return _mikelistView;
}


-(void)userlistbtnClick
{
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.userlistView];
    self.userlistView.dataSource = [NSMutableArray array];
    self.userlistView.delegate = self;
    [self.userlistView.backBtn addTarget:self action:@selector(userlistbackClick) forControlEvents:UIControlEventTouchUpInside];
    self.viewModel = [[chatpersonViewModel alloc] init];
    [self.viewModel getNewsList];
    self.rule = self.viewModel.rule;
    __weak typeof(self) weakSelf = self;
    weakSelf.viewModel.newsListBlock = ^{
        weakSelf.userlistView.dataSource = weakSelf.viewModel.news;
        [weakSelf.userlistView.table reloadData];
    };
    self.maskView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
    [UIView animateWithDuration:.35 animations:^{
        self.userlistView.transform = CGAffineTransformMakeTranslation(-WIDTH+15, 0);
        self.maskView.alpha = .3;
        self.maskView.transform = CGAffineTransformMakeTranslation(0, -HEIGHT);
    }];
}

-(void)userlistbackClick
{
    [UIView animateWithDuration:.35 animations:^{
        self.maskView.alpha = .0;
        self.maskView.transform = CGAffineTransformIdentity;
        self.userlistView.transform = CGAffineTransformIdentity;
    }];
}

-(void)userlistinfovc:(NSString *)userId
{
    [self createData:userId];
}

-(void)refreshView
{
    self.viewModel = [[chatpersonViewModel alloc] init];
    [self.viewModel getNewsList];
    self.rule = self.viewModel.rule;
    __weak typeof(self) weakSelf = self;
    weakSelf.viewModel.newsListBlock = ^{
        [weakSelf.userlistView.table.mj_header endRefreshing];
        weakSelf.userlistView.dataSource = weakSelf.viewModel.news;
        [weakSelf.userlistView.table reloadData];
    };
}

-(void)refreshmikeView
{
    self.viewModel = [[chatpersonViewModel alloc] init];
    [self.viewModel getmikeinfo];
    self.rule = self.viewModel.rule;
    __weak typeof(self) weakSelf = self;
    weakSelf.viewModel.newsListBlock = ^{
        [weakSelf.mikelistView.table.mj_header endRefreshing];
        weakSelf.mikelistView.dataSource = weakSelf.viewModel.news;
        [weakSelf.mikelistView.table reloadData];
    };
}

- (void)didLongPressCellPortrait:(NSString *)userId {
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        return;
    }
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getGroupUserInfoCache:userId withGroupId:self.targetId];
    NSString *nickname = userInfo.name?:@"";
    if (nickname.length!=0) {
        self.chatSessionInputBarControl.inputTextView.text = [NSString stringWithFormat:@"%@%@%@",@"@",nickname,@" "];
    }
}

/**
 麦上人员点击头像

 @param userId 麦上人员id
 */
-(void)mikeinfovc:(NSString *)userId
{
    if ([self.useridArray indexOfObject:userId] != NSNotFound) {
        
        NSInteger inde =[self.useridArray indexOfObject:userId] ;
        NSLog(@"-2---%ld----",inde);
        [self showuserinfoView:userId andisshang:YES];
        
    }else{
        NSLog(@"不存在");
    }
}

//3.销毁
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
