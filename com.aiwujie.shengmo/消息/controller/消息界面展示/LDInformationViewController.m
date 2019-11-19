//
//  LDInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDInformationViewController.h"
#import "LDStampViewController.h"
#import "PersonChatViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDApplyAddGroupViewController.h"
#import "LDGroupChatViewController.h"
#import "LDKFViewController.h"
#import "LDSystemViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDMemberViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDStampChatView.h"
#import "LDStampViewController.h"
#import "UITabBar+badge.h"
#import "ChatroomVC.h"
#import "SuspensionAssistiveTouch.h"

@interface LDInformationViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,StampChatDelete,SDCycleScrollViewDelegate,RCIMGroupUserInfoDataSource>
{
    SuspensionAssistiveTouch * _assistiveTouch;
}
@property (nonatomic,strong) UIView *groupDogView;
@property (nonatomic,strong) RCConversationModel* model;
@property (nonatomic,strong) LDStampChatView *stampView;
//聊吧信息
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) UIImageView *headIcon;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UIView *bgView;
//广告
@property (nonatomic,strong) NSMutableArray *slideArray;
//是否展示广告
@property (nonatomic,assign) BOOL isshowAD;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,assign) BOOL isshowLiaoba;

//聊天室人数
@property (nonatomic,copy) NSString *total;
@end

@implementation LDInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.slideArray = [NSMutableArray array];
    
    self.bgView = [UIView new];
    self.bgView.frame = CGRectMake(0, 0, WIDTH, 70);
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_SYSTEM),@(ConversationType_PUSHSERVICE),@(ConversationType_CUSTOMERSERVICE)]];
//    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_GROUP)]];
    
//    [RCIM sharedRCIM].portraitImageViewCornerRadius = 23;
    
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    [[RCIM sharedRCIM] setGroupUserInfoDataSource:self];
    [RCIM sharedRCIM].groupUserInfoDataSource = self;
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.emptyConversationView = [[UIView alloc]  initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    imageView.image = [UIImage imageNamed:@""];
    [self.emptyConversationView addSubview:imageView];
    
    self.navigationItem.title = @"消息";
    self.navigationItem.hidesBackButton = YES;
    self.showConnectingStatusOnNavigatorBar = YES;
    [self createButton];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(doAction:) name:@"pssbaba" object:@"1"];
    
    //监听是否清空了聊天记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChatCache) name:@"清空聊天记录" object:nil];
    [self createHeadView];
    [self performSelector:@selector(setAssistiveTouch) withObject:nil afterDelay:1];
    
    self.conversationListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getnumber];
    }];
}

-(void)getnumber
{
    NSString *url = [PICHEADURL stringByAppendingString:chatroomUserlistUrl];
    [NetManager afPostRequest:url parms:@{@"type":@"1",@"roomid":roomidStr?:@""} finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            self.total = [dic objectForKey:@"total"];
            self.nameLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"0",@")"];
            [self.conversationListTableView.mj_header endRefreshing];
            [self.conversationListTableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)doAction:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *name = [dic objectForKey:@"name"];
    NSString *uid = [dic objectForKey:@"uid"];
    RCUserInfo *user = [[RCUserInfo alloc] init];;
    user.userId = uid;
    user.name = name;
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:uid];
    [self refreshConversationTableViewIfNeeded];
    [self.conversationListTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [[LDFromwebManager defaultTool] createDataLat];
    [self getnumber];
    [self vhl_setNavBarShadowImageHidden:YES];
    //获取消息列表未读消息数
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
    NSInteger badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (badge <= 0) {
            item.badgeValue = 0;
        }else{
            item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
        }
    });
    //判断是不是有新建的群
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"groupBadge"] length] == 0) {
        self.groupDogView.hidden = YES;
    }else{
        self.groupDogView.hidden = NO;
    }
}

-(void)createHeadView
{
    NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
    [waitQueue addOperationWithBlock:^{
        NSString *url = [PICHEADURL stringByAppendingString:chatroomOpenOrCloseUrl];
        [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
            NSDictionary *dict = [responseObj objectForKey:@"data"];
            NSString *state = [NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]];

            if ([state intValue]==1) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self createHead];
                }];
            }
            if ([state intValue]==0) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self createHeadData];
                }];
            }
            [self getnumber];
        } failed:^(NSString *errorMsg) {
           
        }];
    }];
}

-(void)createHead
{
    NSString *roomid = roomidStr.copy;
    NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
    [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dit = [responseObj objectForKey:@"data"];
            self.infoDic = [NSDictionary dictionary];
            self.infoDic = dit.copy;
            self.isshowLiaoba = YES;
        }
        [self createheadUI];
        [self createHeadData];
    } failed:^(NSString *errorMsg) {
        [self createHeadData];
    }];
}

-(void)createheadUI
{
    self.headView = [UIImageView new];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"background"]]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.headView.clipsToBounds = YES;
    [self.bgView addSubview:self.headView];
    
    self.headIcon = [UIImageView new];
    [self.bgView addSubview:self.headIcon];
    self.headIcon.backgroundColor = [UIColor whiteColor];
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"zm-聊天室"]];
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = 47/2;
    
    self.nameLab = [UILabel new];
    self.nameLab.font = [UIFont systemFontOfSize:16];
    [self.bgView addSubview:self.nameLab];
    self.nameLab.textColor = [UIColor blackColor];
    self.nameLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"0",@")"];
    
    self.contentLab = [UILabel new];
    [self.bgView addSubview:self.contentLab];
    self.contentLab.font = [UIFont systemFontOfSize:14];
    self.contentLab.textColor = [UIColor colorWithHexString:@"9D9E9D" alpha:1];
    self.contentLab.text = [self.infoDic objectForKey:@"count"]?:@"";
    
    self.headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.headView addGestureRecognizer:tapGesturRecognizer];
    self.conversationListTableView.tableHeaderView = self.bgView;
    [self changeheadFrame];
}

-(void)changeheadFrame
{
    if (self.isshowAD&&self.isshowLiaoba) {
        self.headView.frame = CGRectMake(0, ADVERTISEMENT, WIDTH, 70);
        self.headIcon.frame = CGRectMake(11, 6+5+ADVERTISEMENT, 47, 47);
        self.nameLab.frame = CGRectMake(64, 8+5+ADVERTISEMENT, 200, 16);
        self.contentLab.frame = CGRectMake(64, 35+5+ADVERTISEMENT, WIDTH-64-20, 15);
    }
    if (self.isshowLiaoba&&!self.isshowAD) {
        self.headView.frame = CGRectMake(0, 0, WIDTH, 70);
        self.headIcon.frame = CGRectMake(11, 6+5, 47, 47);
        self.nameLab.frame = CGRectMake(64, 8+5, 200, 16);
        self.contentLab.frame = CGRectMake(64, 35+5, WIDTH-64-20, 15);
    }
    if (!self.isshowLiaoba&&self.isshowAD) {
        self.bgView.frame = CGRectMake(0, 0, WIDTH, ADVERTISEMENT);
    }
    if (!self.isshowLiaoba&&!self.isshowAD) {
        self.bgView.frame = CGRectMake(0, 0, 0, 0);
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    NSString *topString;
    if (model.isTop) {
        topString = @"取消置顶";
    }else{
        topString = @"置顶";
    }
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:topString handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([[RCIMClient sharedRCIMClient] setConversationToTop:model.conversationType targetId:model.targetId isTop:!model.isTop]) {
            [self refreshConversationTableViewIfNeeded];
        } ;
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId]) {
            [self refreshConversationTableViewIfNeeded];
        }
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,topAction];
}

-(void)didTapCellPortrait:(RCConversationModel *)model{

    if(model.conversationType == ConversationType_PRIVATE){
        
        LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
        avc.userID = model.targetId;
        [self.navigationController pushViewController:avc animated:YES];
        
    }else if (model.conversationType == ConversationType_GROUP){
        
        LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
        fvc.gid = model.targetId;
        [self.navigationController pushViewController:fvc animated:YES];
        
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)deleteChatCache{
    
    NSArray *listArray = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6]];
    [[RCIMClient sharedRCIMClient] clearConversations:listArray];
    [self.conversationListTableView reloadData];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{

    RCConversationCell *messageCell = (RCConversationCell *)cell;
    messageCell.lastSendMessageStatusView.image = [UIImage imageNamed:@"已读"];
    UIImageView *headerView = (UIImageView *)messageCell.headerImageView;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    if (model.conversationType == ConversationType_SYSTEM) {
        if ([model.targetId isEqualToString:@"4"] || [model.targetId isEqualToString:@"9"]) {
            LDApplyAddGroupViewController *gvc = [[LDApplyAddGroupViewController alloc] init];
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:model.targetId];
            if ([model.targetId isEqualToString:@"4"]) {
                gvc.chatSystemType = chatSystemTypeApply;
            }else if ([model.targetId isEqualToString:@"9"]){
                gvc.chatSystemType = chatSystemTypeFollowMessage;
            }
            [self.navigationController pushViewController:gvc animated:YES];

        }else if ([model.targetId isEqualToString:@"1"]){
            LDSystemViewController *svc = [[LDSystemViewController alloc] init];
            svc.conversationType = model.conversationType;
            svc.targetId = model.targetId;
            svc.title = @"系统消息";
            [self.navigationController pushViewController:svc animated:YES];
        }else if([model.targetId isEqualToString:@"2"]){
            LDSystemViewController *svc = [[LDSystemViewController alloc] init];
            svc.conversationType = model.conversationType;
            svc.targetId = model.targetId;
            svc.title = @"活动消息";
            [self.navigationController pushViewController:svc animated:YES];
        }
    }else if(model.conversationType == ConversationType_PRIVATE){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系!"];
        }else{
            //存储聊天对象的数据
            _model = model;
            [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getOpenChatRestrictAndInfoUrl];
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":model.targetId};
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                
                if (integer == 2000 || integer == 2001) {
                    
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                    
                    PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
                    conversationVC.conversationType = model.conversationType;
                    conversationVC.targetId = model.targetId;
                    conversationVC.mobile = model.targetId;
                    
                    if (integer == 2000) {
                        
                        conversationVC.state = [NSString stringWithFormat:@"%d",[responseObj[@"data"][@"filiation"] intValue]];
                    }
                    
                    if ([responseObj[@"data"][@"info"][@"is_admin"] integerValue] == 1) {
                        
                        conversationVC.type = personIsADMIN;
                        
                    }
                    else if ([responseObj[@"data"][@"info"][@"blvip"] integerValue] == 1)
                    {
                        conversationVC.type = personIsVIPBlue;
                    }
                    else if ([responseObj[@"data"][@"info"][@"bkvip"] integerValue] == 1)
                    {
                        conversationVC.type = personIsVIPBlack;
                    }
                    else if ([responseObj[@"data"][@"info"][@"is_volunteer"] integerValue] == 1){
                        
                        conversationVC.type = personIsVOLUNTEER;
                        
                    }else if ([responseObj[@"data"][@"info"][@"svipannual"] integerValue] == 1){
                        
                        conversationVC.type = personIsSVIPANNUAL;
                        
                    }else if ([responseObj[@"data"][@"info"][@"svip"] integerValue] == 1) {
                        
                        conversationVC.type = personIsSVIP;
                        
                    }else if ([responseObj[@"data"][@"info"][@"vipannual"] integerValue] == 1) {
                        
                        conversationVC.type = personIsVIPANNUAL;
                        
                    }else if ([responseObj[@"data"][@"info"][@"vip"] integerValue] == 1){
                        
                        conversationVC.type = personIsVIP;
                        
                    }
                    else{
                        
                        conversationVC.type = personIsNormal;
                    }
                    
                    conversationVC.title = model.conversationTitle;
      
                    conversationVC.enableUnreadMessageIcon = YES;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                    
                }else if(integer == 3001){
                    
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                    
                    _stampView = [[LDStampChatView alloc] initWithFrame:CGRectMake(0, 0 , WIDTH, HEIGHT)];
                    _stampView.viewController = self;
                    _stampView.data = responseObj[@"data"];
                    _stampView.delegate = self;
                    [self.tabBarController.view addSubview:_stampView];
                    
                }else if (integer==4005)
                {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:responseObj[@"msg"]];
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                    
                }
            } failed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络请求超时,请重试~"];
            }];
        }
    }else if (model.conversationType == ConversationType_GROUP){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系!"];
        }else{
            LDGroupChatViewController *cvc = [[LDGroupChatViewController alloc] init];
            cvc.conversationType = model.conversationType;
            cvc.targetId = model.targetId;
            cvc.title = model.conversationTitle;
            cvc.groupId = model.targetId;
            cvc.enableUnreadMessageIcon = YES;
            //chatView.enableNewComingMessageIcon=YES;//开启消息提醒
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }else if(model.conversationType == ConversationType_CUSTOMERSERVICE){
        LDKFViewController *chatService = [[LDKFViewController alloc] init];
        //    chatService.userName = @"客服";
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = SERVICE_ID;
        chatService.title = @"圣魔官方客服";
        RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
        csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
        csInfo.nickName = [RCIMClient sharedRCIMClient].currentUserInfo.name;
        csInfo.portraitUrl =
        [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
        [self.navigationController pushViewController :chatService animated:YES];
    }
}

//stampChat的代理方法
-(void)didSelectStamp:(NSString *)stamptype{
    
    [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,useStampToChatNewUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":_model.targetId,@"stamptype":stamptype};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
            if (integer == 4001 || integer == 3000) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后再试~"];
            }
        }else if(integer == 2000){
            [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
            PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
            [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
            [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = _model.targetId;
            conversationVC.mobile = _model.targetId;
            conversationVC.state = [NSString stringWithFormat:@"%d",[responseObj[@"data"][@"filiation"] intValue]];
            if ([responseObj[@"data"][@"info"][@"is_admin"] integerValue] == 1) {

                conversationVC.type = personIsADMIN;
                
            }
            else if ([responseObj[@"data"][@"info"][@"blvip"] integerValue] == 1)
            {
                conversationVC.type = personIsVIPBlue;
            }
            else if ([responseObj[@"data"][@"info"][@"bkvip"] integerValue] == 1)
            {
                conversationVC.type = personIsVIPBlack;
            }
            else if ([responseObj[@"data"][@"info"][@"is_volunteer"] integerValue] == 1){
                
                conversationVC.type = personIsVOLUNTEER;
                
            }else if ([responseObj[@"data"][@"info"][@"svipannual"] integerValue] == 1){
                
                conversationVC.type = personIsSVIPANNUAL;
                
            }else if ([responseObj[@"data"][@"info"][@"svip"] integerValue] == 1) {
                
                conversationVC.type = personIsSVIP;
                
            }else if ([responseObj[@"data"][@"info"][@"vipannual"] integerValue] == 1) {
                
                conversationVC.type = personIsVIPANNUAL;
                
            }else if ([responseObj[@"data"][@"info"][@"vip"] integerValue] == 1){
                
                conversationVC.type = personIsVIP;
                
            }
            else{
                
                conversationVC.type = personIsNormal;
            }
            conversationVC.title = _model.conversationTitle;
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
    }];
}

#pragma 选择邮票聊天页面代理
-(void)didSelectOtherButton{
    LDStampViewController *wvc = [[LDStampViewController alloc] init];
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)didSelectAttentButton:(UIView *)backView andButton:(UIButton *)button{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":_model.targetId};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:setfollowOne] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES];
            button.userInteractionEnabled = NO;
            if (integer == 4787 || integer == 4002) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已关注对方,请不要重复操作~"];
            }
            else if (integer==5000)
            {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:responseObj[@"msg"]];
            }
            else if (integer==8881||integer==8882)
            {
                NSString *msg = [responseObj objectForKey:@"msg"];
                UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    cvc.where = @"2";
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
            else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            if ([responseObj[@"data"] intValue] == 1) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
            }else{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
            }
            [button setTitle:@"已关注" forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
    } failed:^(NSString *errorMsg) {
        button.userInteractionEnabled = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }];
}

//点击去开通按钮跳转到会员页面
-(void)stampOpenSvipButtonClick{
    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 **/
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmineinfoUrl];
    NSDictionary *parameters = @{@"uid":userId,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            //此处为了演示写了一个用户信息
            NSString *markname = responseObj[@"data"][@"markname"];
            RCUserInfo *user = [[RCUserInfo alloc] init];;
            user.userId = userId;
            if (markname.length==0) {
                user.name = responseObj[@"data"][@"nickname"];
            }
            else
            {
                user.name = markname;
            }
            user.portraitUri = responseObj[@"data"][@"head_pic"];
            return completion(user);
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}



-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    
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
           
            return completion(group);
        }
    } failed:^(NSString *errorMsg) {

    }];
    
}



- (void)getUserInfoWithUserId:(NSString *)userId
                      inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSString *url = [PICHEADURL stringByAppendingString:@"/Api/friend/getGroupCardName"];
    NSString *uid = userId;
    NSString *gid = groupId;
    __block NSString *name = [NSString new];
    NSDictionary *params = @{@"uid":uid,@"gid":gid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            NSString *nickanme = [dic objectForKey:@"nickanme"]?:@"";
            NSString *cardname = [dic objectForKey:@"cardname"]?:@"";

            if (cardname.length==0) {
                name = nickanme.copy;
            }
            else
            {
                name = cardname.copy;
            }
        }
        RCUserInfo *user = [[RCUserInfo alloc] init];;
        user.userId = userId;
        user.name = name;

        return completion(user);
    } failed:^(NSString *errorMsg) {

    }];
}


-(void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/other/getGroupMember"];
    NSDictionary *parameters = @{@"gid":groupId,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 2000) {
            NSArray *members = responseObj[@"data"];
            NSMutableArray *tempArr = [NSMutableArray new];
            for (int i = 0; i < members.count ; i++) {
                RCUserInfo *member = [[RCUserInfo alloc] init];
                member.userId = members[i];
                [tempArr addObject:member.userId];
            }
            resultBlock(tempArr);
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createButton{
    
    //群广场按钮
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [areaButton setTitle:@"群广场" forState:UIControlStateNormal];
    [areaButton setTitleColor:TextCOLOR forState:UIControlStateNormal];
    areaButton.titleLabel.font = [UIFont systemFontOfSize:14];
    areaButton.tag = 10;
    [areaButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //群广场右上方红点
    _groupDogView = [[UIView alloc] initWithFrame:CGRectMake(63, 30, 10, 10)];
    _groupDogView.backgroundColor = [UIColor redColor];
    _groupDogView.layer.cornerRadius = 5;
    _groupDogView.clipsToBounds = YES;
    _groupDogView.hidden = YES;
    [self.navigationController.view addSubview:_groupDogView];
    
    //清空聊天列表和忽略未读信息按钮
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        
        LDGroupSpuareViewController *svc = [[LDGroupSpuareViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
        
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"忽略未读消息" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            for (int i = 0; i < [self.conversationListDataSource count] ; i++) {
                
                RCConversationModel * model = self.conversationListDataSource[i];
                if (model.conversationType == ConversationType_GROUP) {
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_GROUP
                        targetId:model.targetId] != 0) {
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_GROUP targetId:model.targetId];
                        model.unreadMessageCount = 0;
                        [self.conversationListDataSource replaceObjectAtIndex:i withObject:model];
                    };
                }else if (model.conversationType == ConversationType_SYSTEM){
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_SYSTEM
                        targetId:model.targetId] != 0) {
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:model.targetId];
                        model.unreadMessageCount = 0;
                        [self.conversationListDataSource replaceObjectAtIndex:i withObject:model];
                    };
                }else if (model.conversationType == ConversationType_PRIVATE){
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE
                        targetId:model.targetId] != 0) {
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
                        model.unreadMessageCount = 0;
                        [self.conversationListDataSource replaceObjectAtIndex:i withObject:model];
                    };
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationListTableView reloadData];
            });
            UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
            item.badgeValue = 0;
        }];
        
        UIAlertAction * report = [UIAlertAction actionWithTitle:@"清空聊天列表" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            __weak LDInformationViewController *weakSelf = self;
            [weakSelf.conversationListDataSource removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *listArray = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6]];
                [[RCIMClient sharedRCIMClient] clearConversations:listArray];
                [weakSelf.conversationListTableView reloadData];
            });

        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:MainColor forKey:@"_titleTextColor"];
            [report setValue:MainColor forKey:@"_titleTextColor"];
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        [alert addAction:report];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _groupDogView.hidden = YES;
    if (_stampView) {
         [_stampView removeView];
    }
}

-(void)tapAction
{
    ChatroomVC *vc = [ChatroomVC new];
    vc.infoDic = self.infoDic.copy;
    vc.roomidStr = roomidStr;
    vc.myBlock = ^(NSDictionary * _Nonnull dic) {
        NSString *roomid = roomidStr.copy;
        NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
        [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                self.infoDic = [NSDictionary dictionary];
                self.infoDic = [responseObj objectForKey:@"data"];
                self.nameLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"0",@")"];
                [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"zm-聊天室"]];
                self.contentLab.text = [self.infoDic objectForKey:@"count"];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [[SuspensionAssistiveTouch defaultTool] backbtnClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AssistiveTouch

-(void)releseAssistiveTouch
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows.count > 1) {
        SuspensionAssistiveTouch *touchView = [windows lastObject];
        [touchView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        touchView = nil;
    }
}

#pragma mark - AssistiveTouch

-(void)setAssistiveTouch
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspenshowView) name:SUPVIEWNOTIFICATION object:nil];
}

-(void)suspenshowView
{
    int index =  (int)[self.tabBarController selectedIndex];
    if (index==2) {
        ChatroomVC *vc = [ChatroomVC new];
        vc.infoDic = self.infoDic.copy;
        vc.roomidStr = roomidStr;
        vc.myBlock = ^(NSDictionary * _Nonnull dic) {
            NSString *roomid = roomidStr.copy;
            NSString *url = [PICHEADURL stringByAppendingString:getChatInfoUrl];
            [NetManager afPostRequest:url parms:@{@"roomid":roomid} finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    self.infoDic = [NSDictionary dictionary];
                    self.infoDic = [responseObj objectForKey:@"data"];
                    self.nameLab.text = [NSString stringWithFormat:@"%@%@%@%@",[self.infoDic objectForKey:@"name"]?:@"",@"(",self.total?:@"0",@")"];
                    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"zm-聊天室"]];
                    self.contentLab.text = [self.infoDic objectForKey:@"count"];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 * 判断视图顶部是否有广告栏
 */
-(void)createHeadData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSlideMoreUrl];
    NSDictionary *parameters = @{@"type":@"11"};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            self.isshowAD = YES;
            [self.slideArray addObjectsFromArray:responseObj[@"data"]];
            NSMutableArray *pathArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObj[@"data"]) {
                [pathArray addObject:dic[@"path"]];
            }
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.cycleScrollView.imageURLStringsGroup = pathArray;
            self.cycleScrollView.autoScrollTimeInterval = 3.0;
            [self.bgView addSubview:self.cycleScrollView];
            self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
            [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
            [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            if (self.isshowLiaoba) {
                self.bgView.frame = CGRectMake(0, 0, WIDTH, ADVERTISEMENT+70);
            }
            else
            {
                self.bgView.frame = CGRectMake(0, 0, WIDTH, ADVERTISEMENT);
            }
           
            [self.bgView addSubview:self.deleteButton];
            
        }
        [self changeheadFrame];
        self.conversationListTableView.tableHeaderView = self.bgView;
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 删除广告
 */
-(void)deleteButtonClick{
    [self.cycleScrollView removeFromSuperview];
    [self.deleteButton removeFromSuperview];
    if (self.isshowLiaoba) {
         self.bgView.frame = CGRectMake(0, 0, WIDTH, 70);
    }
    else
    {
        self.bgView.frame = CGRectMake(0, 0, 0, 0);
    }
    self.isshowAD = NO;
    [self changeheadFrame];
    [self.conversationListTableView reloadData];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //link_type 0:url,1:话题,2:动态,3:主页,
    
    if ([_slideArray[index][@"link_type"] intValue] == 0) {
        
        NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.slideArray[index][@"url"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
        LDWebVC *webVC = [[LDWebVC alloc] initWithURLString:newURL];
        webVC.title = self.slideArray[index][@"title"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 1) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 2) {
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([_slideArray[index][@"link_type"] intValue] == 3) {
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:VC animated:YES];
    }
}



@end
