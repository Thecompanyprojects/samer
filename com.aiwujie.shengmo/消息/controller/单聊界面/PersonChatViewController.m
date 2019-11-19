//
//  PersonChatViewController.m
//  yupaopao
//
//  Created by a on 16/8/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PersonChatViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "GifView.h"
#import "XYRichMessageCell.h"
#import "XYRichMessageContent.h"
#import "LDMyWalletPageViewController.h"
#import "XYreadoneCell.h"
#import "XYreadoneContent.h"
#import "NTImageBrowser.h"
#import "LDMemberViewController.h"
#import "XYredMessageCell.h"
#import "XYredMessageContent.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"
#import "SendredsmeViewController.h"
#import "SendNav.h"
#import "ToreceiveViewController.h"
#import "toreceiveModel.h"
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
#import "imagebrowserVC.h"
#import "XYshareDymicCell.h"
#import "XYsharedymicContent.h"
#import "XYsharedymicContent.h"
#import "LDDynamicDetailViewController.h"
#import "XYshareuserinfoCell.h"
#import "XYshareuserinfoContent.h"

@interface PersonChatViewController ()<RCPluginBoardViewDelegate,TZImagePickerControllerDelegate,RCIMReceiveMessageDelegate>
{
    CGRect viewRect;
}
@property (strong, nonatomic) UIView *upView;
//礼物界面
@property (nonatomic,strong) GifView *gif;
@property (nonatomic,copy) NSString *sendimgUrl;
@property (nonatomic,strong) NSMutableArray *sendimageUrl;

@end

@implementation PersonChatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)notifyUpdateUnreadMessageCount
{
    [super notifyUpdateUnreadMessageCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createButton];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sendimageUrl = [NSMutableArray array];
    //注册自定义消息Cell
    [self registerClass:[XYRichMessageCell class] forMessageClass:[XYRichMessageContent class]];
    [self registerClass:[XYreadoneCell classForKeyedArchiver] forMessageClass:[XYreadoneContent class]];
    [self registerClass:[XYredMessageCell class] forMessageClass:[XYredMessageContent class]];
    [self registerClass:[XYshareDymicCell class] forMessageClass:[XYsharedymicContent class]];
    [self registerClass:[XYshareuserinfoCell class] forMessageClass:[XYshareuserinfoContent class]];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    if (_type != personIsNormal) {
        
        //更改导航栏的标题文字
        [self changeNavigationTitle];
    }
    
    if ([self.state intValue] == 2) {
        
        if (ISIPHONEX) {
            self.conversationMessageCollectionView.frame = CGRectMake(0, 144, WIDTH, HEIGHT - 144);
            _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, WIDTH, 56)];
            
        }else{
            
            self.conversationMessageCollectionView.frame = CGRectMake(0, 120, WIDTH, HEIGHT - 120);
            _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 56)];
        }
        _upView.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:0.5];
        [self.view addSubview:_upView];
        
        UILabel *showLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 209, 20)];
        showLabel1.text = @"对方已关注你，是否关注对方?";
        showLabel1.textColor = [UIColor whiteColor];
        showLabel1.font = [UIFont systemFontOfSize:15];
        [_upView addSubview:showLabel1];
        
        UILabel *showLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 29, 209, 20)];
        showLabel2.text = @"互相关注即为好友";
        showLabel2.textColor = [UIColor whiteColor];
        showLabel2.font = [UIFont systemFontOfSize:11];
        [_upView addSubview:showLabel2];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 35, 21, 1, 17)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_upView addSubview:lineView];
        
        
        UIButton *attentButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 17, 43, 23)];
        [attentButton setTitle:@"关注" forState:UIControlStateNormal];
        [attentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [attentButton addTarget:self action:@selector(attentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        attentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        attentButton.layer.borderWidth = 1;
        attentButton.layer.borderColor = [UIColor whiteColor].CGColor;
        attentButton.layer.cornerRadius = 2;
        attentButton.clipsToBounds = YES;
        [_upView addSubview:attentButton];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30, 16, 25, 25)];
        [deleteButton setTitle:@"×" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_upView addSubview:deleteButton];
        
    }
    [self createButton];
    [self addredEnvelope];
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

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isKindOfClass:[XYreadoneContent class]]) {
        
        
    }
    if ([message.objectName isEqualToString:@"ec:phoneinfo"]) {

        if ([self.targetId isEqualToString:message.senderUserId]) {
            RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"Ta打赏了您礼物" extra:nil];
            BOOL saveToDB = YES; //是否保存到数据库中
            RCMessage *savedMsg;
            if (saveToDB) {
                savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];
            } else {
                savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_RECEIVE messageId:-1 content:warningMsg];
            }
            [self appendAndDisplayMessage:savedMsg];
        }
    }
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view
{
    [super didLongTouchMessageCell:model inView:view];
}

-(void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];//一定要写
        UIMenuController * menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:viewRect inView:self.view];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder{
    return true;
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    if ([model.objectName isEqualToString:@"ec:messagereadone"]) {
        
        XYreadoneContent *content = (XYreadoneContent*)model.content;
        imagebrowserVC *vc = [imagebrowserVC new];
        vc.imageUrl = content.imageUrl;
        vc.returnBlock = ^{
            
            //监测到截图之后的操作
            RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"您进行了截图" extra:nil];
            BOOL saveToDB = YES; //是否保存到数据库中
            RCMessage *savedMsg;

            if (saveToDB) {
                savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];

            } else {
                savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];
            }

            [self appendAndDisplayMessage:savedMsg];
            
        };
        [self presentViewController:vc animated:NO completion:^{
            
        }];


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
    if ([model.objectName isEqualToString:@"ec:groupenvelopeinfo"]) {
        //红包
        kPreventRepeatClickTime(5);
        XYredMessageContent *cons = (XYredMessageContent*)model.content;
        NSString *messge = cons.message;

        //本人不能领取红包
        if ([cons.senderUserInfo.userId intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            NSString *url = [PICHEADURL stringByAppendingString:takeRedbagUrl];
            NSString *orderid = cons.orderid;
            NSDictionary *para = @{@"orderid":orderid?:@"",@"show":@"1"};
            [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    
                    toreceiveModel *tmodel = [[toreceiveModel alloc] init];
                    NSDictionary *diuc = responseObj[@"data"];
                    tmodel = [toreceiveModel yy_modelWithDictionary:diuc];
                    
                    ToreceiveViewController *VC = [ToreceiveViewController new];
                    VC.model = tmodel;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
            return;
        }
       
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
        
        if (!iscan) {
            
            NSString *url = [PICHEADURL stringByAppendingString:takeRedbagUrl];
            NSString *orderid = cons.orderid;
            NSDictionary *para = @{@"orderid":orderid?:@"",@"show":@"1"};
            [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    
                    toreceiveModel *tmodel = [[toreceiveModel alloc] init];
                    NSDictionary *diuc = responseObj[@"data"];
                    tmodel = [toreceiveModel yy_modelWithDictionary:diuc];
                    
                    ToreceiveViewController *VC = [ToreceiveViewController new];
                    VC.model = tmodel;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        }
        else
        {
            
            NSString *url = [PICHEADURL stringByAppendingString:takeRedbagUrl];
            NSString *orderid = cons.orderid;
            NSDictionary *para = @{@"orderid":orderid?:@"",@"show":@"1"};
            
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                 if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                  
                     toreceiveModel *tmodel = [[toreceiveModel alloc] init];
                     NSDictionary *diuc = responseObj[@"data"];
                     tmodel = [toreceiveModel yy_modelWithDictionary:diuc];
                     
                     WSRewardConfig *info = ({
                         
                         WSRewardConfig *info = [[WSRewardConfig alloc] init];
                         info.money = [tmodel.beans intValue];
                         info.headImgurl = model.userInfo.portraitUri;
                         info.content = messge;
                         info.userName = model.userInfo.name;
                         info;
                     });
                     
                     [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
                         NSLog(@"取消领取");
                    
                         
                     } finishBlock:^(float money) {
                         
                         NSLog(@"领取金额：%f",money);
                         
                         NSString *Newurl = [PICHEADURL stringByAppendingString:takeRedbagUrl];
                         NSDictionary *newpara = @{@"orderid":cons.orderid};
                         [NetManager afPostRequest:Newurl parms:newpara finished:^(id responseObj) {
                             
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
                                 
                                 
                                 NSString *giftstr = @"您领取了一个红包";
                                 RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:giftstr extra:nil];
                                 BOOL saveToDB = YES; //是否保存到数据库中
                                 RCMessage *savedMsg;
                                 if (saveToDB) {
                                     savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];
                                     
                                 } else {
                                     savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];
                                 }
                                 [self appendAndDisplayMessage:savedMsg];
                                 
                                 
                                 ToreceiveViewController *VC = [ToreceiveViewController new];
                                 VC.model = tmodel;
                                 VC.islingqu = YES;
                                 [self.navigationController pushViewController:VC animated:YES];
                                 
                             }else
                             {
                                 [MBProgressHUD showMessage:responseObj[@"msg"]];
                             }
                             
                         } failed:^(NSString *errorMsg) {
                             
                         }];

                     }];

                 }
                
            } failed:^(NSString *errorMsg) {
                
            }];
        }
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
 聊天页面发礼物
 */
-(void)addredEnvelope
{
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-礼物"] title:@"礼物" atIndex:6 tag:2001];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-红包"] title:@"红包" atIndex:7 tag:2003];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"闪照"] title:@"闪照" atIndex:8 tag:2002];
}

-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    if (tag==1101||tag==1102) {
        if (![self.state isEqualToString:@"3"]) {
            
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您和对方还不是好友" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acion0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self attentButtonClick];
            }];
            [control addAction:acion0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:^{

            }];
        }
        else
        {
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        }
    }
    if (tag==1001||tag==1002||tag==1003) {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
    if (tag==2001) {
        //礼物功能
        
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:NO :^{
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            cvc.type = @"0";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        _gif.is_home = @"2";
        [_gif getPersonUid:self.mobile andSign:@"赠送给某人"andUIViewController:self];
        
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            NSString *imagename = [dic objectForKey:@"image"];
 
            NSDictionary *para = @{@"number":dic[@"num"],@"imageName":imagename};
            XYRichMessageContent *addcontent = [XYRichMessageContent messageWithDict:para];
            addcontent.number = dic[@"num"];
            addcontent.imageName = dic[@"image"];
            
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
//            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [weakSelf sendMessage:addcontent pushContent:@"礼物"];

            RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"你给Ta打赏了礼物" extra:nil];
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
        //阅后即焚
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
    if (tag==2003) {
        //单聊发红包
        SendredsmeViewController * allTicketVC = [[SendredsmeViewController alloc] init];// 包装一个导航栏控制器
        SendNav * nav = [[SendNav alloc]initWithRootViewController:allTicketVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        allTicketVC.myBlock = ^(NSDictionary * _Nonnull dic) {
            __weak typeof (self) weakSelf = self;
            
            NSString *message = [dic objectForKey:@"message"];
            if (message.length==0) {
                message = @"恭喜发财，大吉大利";
            }
            
            NSString *url = [PICHEADURL stringByAppendingString:giveRedbagUrl];
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *fuid = self.targetId;
            NSString *num = [dic objectForKey:@"money"];
            NSString *time = [[TimeManager defaultTool] getNowTimeTimestamp];
            
            NSString *orderid = [NSString stringWithFormat:@"%@%@%@",uid,fuid,time];
            
            NSDictionary *para = @{@"uid":uid,@"fuid":fuid,@"num":num,@"orderid":orderid};
            
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    
                    //NSDictionary *paras = @{@"message":message,@"isopen":@"0",@"orderid":orderid};
                    
                    XYredMessageContent *addcontent = [[XYredMessageContent alloc] init];
                    addcontent.message = message;
                    addcontent.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
                    addcontent.isopen = @"0";
                    addcontent.orderid = orderid;
                    
//                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paras options:0 error:0];
//                    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [weakSelf sendMessage:addcontent pushContent:message];
                    
                }
                else
                {
                    [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
                }
            } failed:^(NSString *errorMsg) {
                
            }];

        };
        [self presentViewController:nav animated:YES completion:nil];
        
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
        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
//        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self sendMessage:content pushContent:@"阅后即焚"];
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

/**
  * 更改导航栏的标题文字
 */
-(void)changeNavigationTitle{
    
    UIColor *navTitleColor = [[UIColor alloc] init];
    UIImage *navTitleImage = [[UIImage alloc] init];
    
    if (_type == personIsADMIN) {
        
        navTitleColor = [UIColor blackColor];
        navTitleImage = [UIImage imageNamed:@"官方认证"];
        
    }
    else if (_type==personIsVIPBlack)
    {
        navTitleColor = [UIColor blackColor];
        navTitleImage = [UIImage imageNamed:@"贵宾黑V"];
    }
    else if (_type==personIsVIPBlue)
    {
        navTitleColor = [UIColor colorWithHexString:@"0684CE" alpha:1];
        navTitleImage = [UIImage imageNamed:@"蓝V"];
    }
    else if(_type == personIsVOLUNTEER) {
        
        navTitleColor = [UIColor greenColor];
        navTitleImage = [UIImage imageNamed:@"志愿者标识"];
        
    }else if (_type == personIsSVIPANNUAL) {
        
        navTitleColor = [UIColor redColor];
        navTitleImage = [UIImage imageNamed:@"年svip标识"];
        
    }else if (_type == personIsSVIP) {
        
        navTitleColor = [UIColor redColor];
        navTitleImage = [UIImage imageNamed:@"svip标识"];
        
    }else if (_type == personIsVIPANNUAL) {
        
        navTitleColor = MainColor;
        navTitleImage = [UIImage imageNamed:@"年费会员"];
        
    }else if (_type == personIsVIP) {
        
        navTitleColor = MainColor;
        navTitleImage = [UIImage imageNamed:@"高级紫"];
    }
    
    UILabel *textLabel = [[UILabel alloc] init];
    // 创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.title]];
    // 修改富文本中的不同文字的样式
    [attri addAttribute:NSForegroundColorAttributeName value:navTitleColor range:NSMakeRange(0, attri.length)];
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = navTitleImage;
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 18, 18);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    // 用label的attributedText属性来使用富文本
    textLabel.attributedText = attri;
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(textLabel.frame), CGRectGetHeight(textLabel.frame));
    self.navigationItem.titleView = textLabel;
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model{
    
    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {
        
        RCRichContentMessage *message = (RCRichContentMessage *)model.content;
        NSArray *array = [message.extra componentsSeparatedByString:@","];
        NSString *gidStr = [array[0] componentsSeparatedByString:@":"][1] ;
        NSString *gid = [gidStr substringWithRange:NSMakeRange(1, gidStr.length - 2)];
        NSString *state = [[array[1] componentsSeparatedByString:@":"][1] substringToIndex:1];
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
        NSDictionary *parameters;
        parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
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

//关注成为好友
-(void)attentButtonClick{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.mobile};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:setfollowOne] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (integer==5000)
            {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:responseObj[@"msg"]];
            }
            else
            {
                NSString *msg = [responseObj objectForKey:@"msg"];
                UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    cvc.where = @"8";
                    [self.navigationController pushViewController:cvc animated:YES];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [control addAction:action1];
                [control addAction:action0];
                [control addAction:action2];
                [self presentViewController:control animated:YES completion:^{
                    
                }];
            }
         
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self deleteButtonClick];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//删除上方view
-(void)deleteButtonClick{
    if (ISIPHONEX) {
        self.conversationMessageCollectionView.frame = CGRectMake(0, 88, WIDTH, HEIGHT - 172);
    }else{
        self.conversationMessageCollectionView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 114);
    }
    [_upView removeFromSuperview];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    RCMessageCell *messageCell = (RCMessageCell *)cell;
    if ([messageCell respondsToSelector:@selector(messageHasReadStatusView)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已读"]];
            img.frame = CGRectMake(-2, 2, 17, 10);
            [messageCell.messageHasReadStatusView addSubview:img];
        });
    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"个人图标"] forState:UIControlStateNormal];
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
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    avc.userID = self.mobile;
    [self.navigationController pushViewController:avc animated:YES];
}

//点击聊天头像查看个人信息
- (void)didTapCellPortrait:(NSString *)userId{
    [self createData:userId];
}

-(void)createData:(NSString *)userId{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    avc.userID = userId;
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
