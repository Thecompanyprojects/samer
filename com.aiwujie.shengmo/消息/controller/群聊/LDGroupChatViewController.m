//
//  LDGroupChatViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupChatViewController.h"
#import "LDGroupAtPersonViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "XYgiftgroupMessageCell.h"
#import "XYgiftMessageContent.h"
#import "LDMyWalletPageViewController.h"
#import "SendNav.h"
#import "SendredsViewController.h"
#import "XYredMessageCell.h"
#import "XYredMessageContent.h"
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
#import "XYshareDymicCell.h"
#import "XYsharedymicContent.h"
#import "XYsharedymicContent.h"
#import "LDDynamicDetailViewController.h"
#import "XYshareuserinfoCell.h"
#import "XYshareuserinfoContent.h"


@interface LDGroupChatViewController ()<RCPluginBoardViewDelegate,RCIMReceiveMessageDelegate,TZImagePickerControllerDelegate>
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
@property (nonatomic,copy) NSString *sendimgUrl;
@property (nonatomic,assign) NSInteger messageId;
@property (nonatomic,assign) BOOL isadmin;
@property (nonatomic,strong) groupinfoModel *infoModel;
@property (nonatomic,assign) BOOL iscanPush;
@property (nonatomic,strong) NSMutableArray *sendimageUrl;
@end

@implementation LDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getgroupinfo];

    self.sendimageUrl = [NSMutableArray array];
    //注册自定义消息Cell
    [self registerClass:[XYgiftgroupMessageCell class] forMessageClass:[XYgiftMessageContent class]];
    [self registerClass:[XYredMessageCell class] forMessageClass:[XYredMessageContent class]];
    [self registerClass:[XYreadoneCell classForKeyedArchiver] forMessageClass:[XYreadoneContent class]];
    [self registerClass:[XYshareDymicCell class] forMessageClass:[XYsharedymicContent class]];
    [self registerClass:[XYshareuserinfoCell class] forMessageClass:[XYshareuserinfoContent class]];
    
    [self createRefreshUserData:self.groupId];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    [RCIM sharedRCIM].receiveMessageDelegate = self;

    //根据tag删除
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1102];
    [self addredEnvelope];

}

-(void)notifyUpdateUnreadMessageCount
{
    [super notifyUpdateUnreadMessageCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createButton];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.iscanPush = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

/**
 聊天页面发红包 礼物  闪照
 */
-(void)addredEnvelope
{
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-礼物"] title:@"礼物" atIndex:6 tag:2001];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-红包"] title:@"红包" atIndex:7 tag:2002];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"闪照"] title:@"闪照" atIndex:8 tag:2003];
}

-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
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
        _gif.groupid = self.groupId?:@"";
        [_gif getPersonUid:self.groupId andSign:@"赠送给某人"andUIViewController:self];
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
            NSDictionary *params = @{@"uid":uid,@"num":num,@"nums":nums,@"orderid":orderid,@"groupid":self.groupId?:@""};
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

#pragma mark - 撤回消息

- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model{
    
    NSMutableArray<UIMenuItem *> *menuList = [[super getLongTouchMessageCellMenuList:model] mutableCopy];
    if (self.isadmin) {
        UIMenuItem *withdrawItem = [[UIMenuItem alloc] initWithTitle:@"管理员撤回" action:@selector(withdrawMenuItem)];
        [menuList addObject:withdrawItem];
        self.messageId = model.messageId;
    }
    return menuList;
}

- (void)withdrawMenuItem{
    //该方法必须是存在的方法不然无法显示出menu
    [self recallMessage:self.messageId];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view
{
    [super didLongTouchMessageCell:model inView:view];
    if ([model.objectName isEqualToString:@"ec:messagereadone"]) {

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

        kPreventRepeatClickTime(5);
        
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
                        
                        kPreventRepeatClickTime(5);
                        
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
    if ([model.objectName isEqualToString:@"ServiceShare_SinaWeibo"]) {
        
        XYsharedymicContent *content = (XYsharedymicContent*)model.content;
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = content.Newid?:@"";
        vc.ownUid = content.userId?:@"";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([model.objectName isEqualToString:@"share_tools_loader"]) {
        XYshareuserinfoContent *content = (XYshareuserinfoContent*)model.content;
        LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
        avc.userID = content.Newid;
        [self.navigationController pushViewController:avc animated:YES];
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

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isKindOfClass:[XYredMessageContent class]]) {

    }
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model{

    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {

        RCRichContentMessage *message = (RCRichContentMessage *)model.content;

        NSArray *array = [message.extra componentsSeparatedByString:@","];

        NSString *gidStr = [array[0] componentsSeparatedByString:@":"][1] ;

        NSString *gid = [gidStr substringWithRange:NSMakeRange(1, gidStr.length - 2)];

        NSString *state = [[array[1] componentsSeparatedByString:@":"][1] substringToIndex:1];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];

        NSDictionary *parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                if ([responseObj[@"data"][@"userpower"] intValue] < 1) {
                    
                    if ([responseObj[@"data"][@"userpower"] intValue] == 0) {
                        
                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                        
                        ivc.gid = gid;
                        
                        [self.navigationController pushViewController:ivc animated:YES];
                        
                    }else if([responseObj[@"data"][@"userpower"] intValue] == -1){
                        
                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                        
                        ivc.state = state;
                        
                        ivc.gid = gid;
                        
                        [self.navigationController pushViewController:ivc animated:YES];
                        
                    }
                    
                }else{
                    
                    LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                    fvc.gid = gid;
                    [self.navigationController pushViewController:fvc animated:YES];
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }else{
        [super didTapUrlInMessageCell:url model:model];
    }
}

- (void)showChooseUserViewController:(void (^)(RCUserInfo *selectedUserInfo))selectedBlock
                              cancel:(void (^)(void))cancelBlock{
    if (self.iscanPush) {
        LDGroupAtPersonViewController *atPerson = [[LDGroupAtPersonViewController alloc] init];
        atPerson.groupId = self.groupId;
        atPerson.block = ^(RCUserInfo *user) {
            selectedBlock(user);
        };
        self.iscanPush = NO;
        [self.navigationController pushViewController:atPerson animated:YES];
    }
}

-(void)getgroupinfo
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
    NSDictionary *parameters = @{@"gid":self.groupId,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        self.infoModel = [[groupinfoModel alloc] init];
        self.infoModel = [groupinfoModel yy_modelWithJSON:responseObj];
        
        RCGroup *group = [[RCGroup alloc] initWithGroupId:_groupId groupName:responseObj[@"data"][@"groupname"] portraitUri:responseObj[@"data"][@"group_pic"]];
        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:self.groupId];
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer==2000) {
            
            //2 管理员 1  群主
            if ([responseObj[@"data"][@"userpower"] intValue] ==2||[responseObj[@"data"][@"userpower"] intValue] ==3)
            {
                self.isadmin = YES;
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createButton{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"群组图标"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
    }else{
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)leftButtonOnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backButtonOnClick:(UIButton *)button{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
    NSDictionary *parameters = @{@"gid":self.groupId,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        if (!([[responseObj objectForKey:@"retcode"] intValue]==2000)) {
            NSString *msg = [responseObj objectForKey:@"msg"];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:msg];
        }
        else
        {
            NSString *userpower = [[responseObj objectForKey:@"data"] objectForKey:@"userpower"];
            if ([userpower intValue]<1) {
                LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                ivc.gid = self.groupId;
                [self.navigationController pushViewController:ivc animated:YES];
            }
            else
            {
                LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                self.isadmin = YES;
                fvc.gid = self.groupId;
                fvc.chatStsate = @"yes";
                [self.navigationController pushViewController:fvc animated:YES];
            }
        }
       
    } failed:^(NSString *errorMsg) {
        
    }];
}

//点击聊天头像查看个人信息
- (void)didTapCellPortrait:(NSString *)userId{
    [self createData:userId];
}

-(void)createRefreshUserData:(NSString *)groupId{
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":groupId,@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:longitude]};
        
    }else{
        
        parameters = @{@"gid":groupId,@"lat":@"",@"lng":@""};
    }

    [NetManager afPostRequest:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getGroupinfo"] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            //此处为了演示写了一个用户信息
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = groupId;
            group.groupName = responseObj[@"data"][@"groupname"];
            group.portraitUri = responseObj[@"data"][@"group_pic"];
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


-(void)createData:(NSString *)userId{
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    avc.userID = userId;
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - 发送及时消息

-(void)sendoneimage:(NSString *)urls
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1) {
        NSString *img = urls;
        NSDictionary *para = @{@"imageUrl":img,@"isopen":@"0"};
        XYreadoneContent *content = [XYreadoneContent messageWithDict:para];
        content.imageUrl = urls;
        
        [self sendMessage:content pushContent:@"闪图"];
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
                    //                    [MBProgressHUD showMessage:[responseObject objectForKey:@"msg"]];
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

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didLongPressCellPortrait:(NSString *)userId {
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        return;
    }
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getGroupUserInfoCache:userId withGroupId:self.targetId];
    [self.chatSessionInputBarControl addMentionedUser:userInfo];
    [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
