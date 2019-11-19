//
//  LDGroupInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupInformationViewController.h"
#import "LDAlertHeadAndNameViewController.h"
#import "LDAlertNameViewController.h"
#import "LDGroupMemberListViewController.h"
#import "LDGroupUpViewController.h"
#import "LDGroupChatViewController.h"
#import "LDReportViewController.h"
#import "RCDGroupAnnouncementViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDShareView.h"
#import "LDInvitationMemberViewController.h"

@interface LDGroupInformationViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupMemberButton;
@property (weak, nonatomic) IBOutlet UILabel *groupAddressLabel;
@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteInformationButton;
@property (weak, nonatomic) IBOutlet UILabel *groupManagerLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupManagerButton;
@property (weak, nonatomic) IBOutlet UILabel *groupUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupUpButton;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *introduceButton;
@property (weak, nonatomic) IBOutlet UIView *introduceView;
@property (weak, nonatomic) IBOutlet UIButton *dissmissButton;
@property (weak, nonatomic) IBOutlet UIImageView *managerView1;
@property (weak, nonatomic) IBOutlet UIImageView *managerView2;
@property (weak, nonatomic) IBOutlet UIImageView *managerView3;
@property (weak, nonatomic) IBOutlet UIImageView *managerView4;
@property (weak, nonatomic) IBOutlet UIImageView *managerView5;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupVipView;

@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *userpower;
@property (nonatomic,copy) NSString *ownpic;
@property (nonatomic,assign) BOOL status;
@property (nonatomic,copy) NSString *reportId;
@property (nonatomic,strong) NSMutableArray *groupMemberArrary;

@property (weak, nonatomic) IBOutlet UIView *atView;
@property (weak, nonatomic) IBOutlet UIView *closeVoiceView;
@property (weak, nonatomic) IBOutlet UIView *deleteChatView;
@property (weak, nonatomic) IBOutlet UIView *setManagerView;
@property (weak, nonatomic) IBOutlet UIView *groupUpView;
@property (weak, nonatomic) IBOutlet UIView *clearpersonView;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;

@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *picStr;
@property (nonatomic,copy) NSString *shareId;

//群名片
@property (nonatomic,strong) UIView *groupcardView;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *cardLab;

@property (weak, nonatomic) IBOutlet UIImageView *headrightImg;
@property (weak, nonatomic) IBOutlet UIImageView *introducerightImg;
@end

@implementation LDGroupInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"群组信息";
    if ([self.chatStsate isEqualToString:@"yes"]) {
        self.beginButton.hidden = YES;
    }
    _groupMemberArrary = [NSMutableArray array];
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.gid success:^(RCConversationNotificationStatus nStatus) {
        NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)nStatus];
        if ([str isEqualToString:@"0"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageSwitch.on = NO;
            });
            
            
            _status = NO;
            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
                
                
            } error:^(RCErrorCode status) {
                
                
            }];
            
        }
        else
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageSwitch.on = YES;
            });
            
            _status = YES;
            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
                
            } error:^(RCErrorCode status) {
                
                
            }];
            
        }
    } error:^(RCErrorCode status) {
        
        
    }];
    
    [self createButton];
    
    self.headView.layer.cornerRadius = 30;
    
    self.headView.clipsToBounds = YES;
    
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (ISIPHONEX) {
        self.beginButton.frame = CGRectMake(0, self.beginButton.frame.origin.y - 30, self.beginButton.frame.size.width, self.beginButton.frame.size.height);
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 30);
    }
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.managerView1.hidden = YES;
    self.managerView2.hidden = YES;
    self.managerView3.hidden = YES;
    self.managerView4.hidden = YES;
    self.managerView5.hidden = YES;
    [self createGroupMemberData];
    [self createGroupData];
}

-(void)createGroupMemberData{


    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getGroupMemberUrl];
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":self.gid,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"pagetype":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }else{
        
        parameters = @{@"gid":self.gid,@"lat":@"",@"lng":@"",@"pagetype":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000 && integer != 2001) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
            
        }else{
            
            [_groupMemberArrary removeAllObjects];
            
            _ownpic = responseObj[@"data"][0][@"head_pic"];
            
            _reportId = responseObj[@"data"][0][@"uid"];
            
            [_groupMemberArrary addObjectsFromArray:responseObj[@"data"]];
            
            if ([responseObj[@"data"] count] >= 5) {
                
                for (int i = 0; i < 5; i++) {
                    
                    UIImageView *img = (UIImageView *)[self.view viewWithTag:10 + i];
                    
                    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][i][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                    img.contentMode = UIViewContentModeScaleAspectFill;
                    img.layer.cornerRadius = 22;
                    
                    img.clipsToBounds = YES;
                    
                    if (i == 1) {
                        
                        if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView1.hidden = NO;
                            
                        }else{
                            
                            self.managerView1.hidden = YES;
                        }
                        
                    }
                    
                    if (i == 2) {
                        
                        if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView2.hidden = NO;
                            
                        }else{
                            
                            self.managerView2.hidden = YES;
                        }
                        
                    }
                    
                    if (i == 3) {
                        
                        if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView3.hidden = NO;
                            
                        }else{
                            
                            self.managerView3.hidden = YES;
                        }
                        
                    }
                    
                    if (i == 4) {
                        
                        if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView4.hidden = NO;
                            
                        }else{
                            
                            self.managerView4.hidden = YES;
                        }
                        
                    }
                    
                    self.managerView5.hidden = YES;
                    UIImageView *addImag = (UIImageView *)[self.view viewWithTag:15];
                    addImag.image = [UIImage imageNamed:@"群拉人"];
                    addImag.layer.cornerRadius = 22;
                    addImag.clipsToBounds = YES;
                    
                }
                
            }else{
                
                for (int i = 0; i < 6; i++) {
                    
                    UIImageView *img = (UIImageView *)[self.view viewWithTag:10 + i];
                    
                    img.layer.cornerRadius = 22;
                    
                    img.clipsToBounds = YES;
                    
                    if ((i + 1) <= [responseObj[@"data"] count] + 1) {
                        
                        if (i + 1 == [responseObj[@"data"] count] + 1) {
                            
                            img.image = [UIImage imageNamed:@"群拉人"];
                            
                        }else{
                            
                            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][i][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                            img.contentMode = UIViewContentModeScaleAspectFill;
                            if (i == 1) {
                                
                                if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView1.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView1.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 2) {
                                
                                if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView2.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView2.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 3) {
                                
                                if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView3.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView3.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 4) {
                                
                                if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView4.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView4.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 5) {
                                
                                if ([responseObj[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView5.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView5.hidden = YES;
                                }
                            }
                        }
                        
                        
                    }else{
                        
                        img.hidden = YES;
                    }
                }
            }
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (IBAction)tapGroupMember:(UITapGestureRecognizer *)sender {
    
    if (_groupMemberArrary.count >= 5) {
        
        UIImageView *img = (UIImageView *)sender.view;
        
        if (img.tag == 15) {
            
            LDInvitationMemberViewController *mvc = [[LDInvitationMemberViewController alloc] init];
            
            mvc.gid = self.gid;
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else{
        
            LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
            
            fvc.userID = _groupMemberArrary[img.tag - 10][@"uid"];
            
            [self.navigationController pushViewController:fvc animated:YES];
        }
        
    }else if (_groupMemberArrary.count < 5){
    
        UIImageView *img = (UIImageView *)sender.view;
        
        if (img.tag - 10 == _groupMemberArrary.count) {
            
            LDInvitationMemberViewController *mvc = [[LDInvitationMemberViewController alloc] init];
            
            mvc.gid = self.gid;
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else{
        
            LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
            
            fvc.userID = _groupMemberArrary[img.tag - 10][@"uid"];
            
            [self.navigationController pushViewController:fvc animated:YES];
        }
    }
}


-(void)createGroupData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters;
    
    parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];

        }else{

            if ([responseObj[@"data"][@"group_pic"] isEqualToString:PICHEADURL]) {
                
                _headView.image = [UIImage imageNamed:@"群默认头像"];
                _headView.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                
                [_headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"group_pic"]]] placeholderImage:[UIImage imageNamed:@"群默认头像"]];
            }
            
            _headUrl = responseObj[@"data"][@"group_pic"];
            
            self.nickName = responseObj[@"data"][@"groupname"]?:@"";
            self.shareId = self.gid;
            self.picStr = self.headUrl?:@"";
            
            self.groupNameLabel.text = responseObj[@"data"][@"groupname"];
            
            self.groupNumberLabel.text = [NSString stringWithFormat:@"群号:%@",responseObj[@"data"][@"group_num"]];
            
            if ([responseObj[@"data"][@"group_num"] length] <= 5) {
                
                self.groupVipView.hidden = NO;
                
            }else{
                
                self.groupVipView.hidden = YES;
            }
            
            self.groupMemberLabel.text = [NSString stringWithFormat:@"%@/%@",responseObj[@"data"][@"member"],responseObj[@"data"][@"max_member"]];
            
            self.groupAddressLabel.text = [NSString stringWithFormat:@"%@  %@",responseObj[@"data"][@"province"],responseObj[@"data"][@"city"]];
            
            self.groupManagerLabel.text = [NSString stringWithFormat:@"%@%@",responseObj[@"data"][@"manager"],responseObj[@"data"][@"managerStr"]];
            
            
            //群介绍
            self.introduceLabel.text = responseObj[@"data"][@"introduce"];
            
            self.introduceLabel.numberOfLines = 0;
            
            self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            CGSize size = [self.introduceLabel sizeThatFits:CGSizeMake(WIDTH - 25, 0)];
            
            self.introduceLabel.frame = CGRectMake(self.introduceLabel.frame.origin.x, self.introduceLabel.frame.origin.y, size.width, size.height);
            
            self.introduceView.frame = CGRectMake(0, self.introduceView.frame.origin.y, WIDTH, 63 + self.introduceLabel.frame.size.height);
            
            self.groupcardView = [[UIView alloc] init];
            self.leftLab = [[UILabel alloc] init];
            self.cardLab = [[UILabel alloc] init];
            self.leftLab.frame = CGRectMake(14, 10, 100, 24);
            [self.groupcardView addSubview:self.leftLab];
            self.leftLab.text = @"我的群昵称";
            self.leftLab.font = [UIFont systemFontOfSize:14];
            self.leftLab.textColor = [UIColor blackColor];
            self.groupcardView.backgroundColor = [UIColor whiteColor];
            self.cardLab.frame = CGRectMake(WIDTH/2, 10, WIDTH/2-14, 24);
            self.cardLab.textColor = [UIColor blackColor];
            self.cardLab.textAlignment = NSTextAlignmentRight;
            self.cardLab.font = [UIFont systemFontOfSize:14];
            [self.groupcardView addSubview:self.cardLab];
            [self.scrollView addSubview:self.groupcardView];
            NSString *cardname = responseObj[@"data"][@"cardname"];
            self.cardLab.text = cardname?:@"";
            
            self.groupcardView.userInteractionEnabled=YES;
            UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside)];
            [self.groupcardView addGestureRecognizer:labelTapGestureRecognizer];
            
            _userpower = responseObj[@"data"][@"userpower"];
            
            CGFloat hei = 44;
            
            NSString *userpower = responseObj[@"data"][@"userpower"];
     
            if ([userpower intValue] == 3) {
                
                [self.dissmissButton setTitle:@"解散群组" forState:UIControlStateNormal];
                
                self.atView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1, WIDTH, self.atView.frame.size.height);
                
                self.groupcardView.frame = CGRectMake(0, self.atView.frame.origin.y+43, WIDTH, 43);
                
                self.closeVoiceView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 44+hei, WIDTH, self.closeVoiceView.frame.size.height);
                
                self.clearpersonView.frame =  CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87+hei, WIDTH, self.deleteChatView.frame.size.height);
                
                self.deleteChatView.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87+44+hei, WIDTH, self.deleteChatView.frame.size.height);
                
                self.setManagerView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 130+44+hei, WIDTH, self.setManagerView.frame.size.height);
                
                self.groupUpView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 173+44+hei, WIDTH, self.groupUpView.frame.size.height);
             
                self.clearpersonView.hidden = NO;
                
                self.dissmissButton.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 269+hei, WIDTH, self.dissmissButton.frame.size.height);
                
            }else if([userpower intValue] == 2){
                
                [self.dissmissButton setTitle:@"退出群组" forState:UIControlStateNormal];
                
                self.groupUpView.hidden = YES;
                
                self.setManagerView.hidden = YES;
                
                self.atView.hidden = NO;
                
                self.atView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1, WIDTH, self.atView.frame.size.height);
                
                self.groupcardView.frame = CGRectMake(0, self.atView.frame.origin.y+43, WIDTH, 43);
                
                self.closeVoiceView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 44+hei, WIDTH, self.closeVoiceView.frame.size.height);
                
                self.clearpersonView.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87+hei, WIDTH, self.deleteChatView.frame.size.height);
             
                self.deleteChatView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 130+hei, WIDTH, self.clearpersonView.frame.size.height);
      
                self.dissmissButton.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 130+50+hei, WIDTH, self.dissmissButton.frame.size.height);
 
                self.clearpersonView.hidden = NO;
                
            }else{
                
                self.introducerightImg.hidden = YES;
                self.headrightImg.hidden = YES;
                
                [self.dissmissButton setTitle:@"退出群组" forState:UIControlStateNormal];
                
                self.groupManagerButton.userInteractionEnabled = NO;
                
                self.headButton.userInteractionEnabled = NO;
                
                self.introduceButton.userInteractionEnabled = NO;
                
                self.setManagerView.hidden = YES;
                
                self.atView.hidden = YES;
                
                self.groupUpView.hidden = YES;
                
                self.groupcardView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height, WIDTH, 43);
                
                self.closeVoiceView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1+hei, WIDTH, self.closeVoiceView.frame.size.height);
                
                self.deleteChatView.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 44+hei, WIDTH, self.deleteChatView.frame.size.height);
                
                self.dissmissButton.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87+hei, WIDTH, self.dissmissButton.frame.size.height);

                self.clearpersonView.hidden = YES;
                
               
                
            }
            self.scrollView.contentSize = CGSizeMake(WIDTH, self.dissmissButton.frame.origin.y + self.dissmissButton.frame.size.height + 50+10);
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)labelTouchUpInside
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入群昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入群昵称";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *url = [PICHEADURL stringByAppendingString:editGroupCardNameUrl];
        NSString *gid = self.gid.copy?:@"";
        
        NSString *name = envirnmentNameTextField.text;
        NSString *cardname = [NSString new];
        if (name.length>4) {
            [AlertTool alertqute:self andTitle:@"提示" andMessage:@"限10字以内"];
            cardname = [name substringToIndex:4];
            return;
        }
        else
        {
            cardname = name.copy;
        }
        

        
        NSDictionary *params = @{@"uid":uid,@"gid":gid,@"cardname":cardname};
        
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                [self createGroupData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}

- (IBAction)allPeopleButtonClick:(id)sender {
    
    if ([_userpower intValue] == 3 || [_userpower intValue] == 2) {
        
        RCDGroupAnnouncementViewController *avc = [[RCDGroupAnnouncementViewController alloc] init];
        avc.GroupId = self.gid;
        [self.navigationController pushViewController:avc animated:YES];
    }
}


- (IBAction)headButtonClick:(id)sender {
    
    LDAlertHeadAndNameViewController *nvc = [[LDAlertHeadAndNameViewController alloc] init];
    nvc.headUrl = _headUrl;
    nvc.groupName = self.groupNameLabel.text;
    nvc.gid = self.gid;
    [self.navigationController pushViewController:nvc animated:YES];
}

- (IBAction)messageSwitchClick:(id)sender {
    
    if (_status) {
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageSwitch.on = NO;
                _status = NO;
            });
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"miandarao"];
            
        } error:^(RCErrorCode status) {

            
        }];
        
    }else{
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageSwitch.on = YES;
                _status = YES;
            });
//            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"miandarao"];

        } error:^(RCErrorCode status) {
            
            
        }];
    
    }
}

- (IBAction)groupMemberButtonClick:(id)sender {
    
    LDGroupMemberListViewController *lvc = [[LDGroupMemberListViewController alloc] init];
    
    lvc.gid = self.gid;
    
    lvc.state = _userpower;
    
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)deleteButtonClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否清空聊天记录" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP targetId:self.gid recordTime:[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000] longLongValue] success:^{
            
             [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.gid];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
        } error:^(RCErrorCode status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"清空聊天记录失败"];
            
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
        
        [action setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:action];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (IBAction)groupManagerButtonClick:(id)sender {
    
    LDGroupMemberListViewController *lvc = [[LDGroupMemberListViewController alloc] init];
    
    lvc.gid = self.gid;
    
    lvc.type = @"1";
    
    [self.navigationController pushViewController:lvc animated:YES];

}
- (IBAction)groupUpButtonClick:(id)sender {
    
    if ([_userpower intValue] == 3) {
        
        LDGroupUpViewController *uvc = [[LDGroupUpViewController alloc] init];
        
        uvc.headpic = _headUrl;
        
        uvc.ownpic = _ownpic;
        
        [self.navigationController pushViewController:uvc animated:YES];
        
    }
}


- (IBAction)dissmissButtonClick:(id)sender {
    
    if ([_userpower intValue] == 3) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解散此群"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/delGroup"];
            
            NSDictionary *parameters;
            
            parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wancheng" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
     
            }];
   
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:MainColor forKey:@"_titleTextColor"];
            [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
        }

        [alert addAction:cancelAction];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else if ([_userpower intValue] == 2 || [_userpower intValue] == 1){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出此群"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/exitGroup"];
            
            NSDictionary *parameters;
            
            parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wancheng" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failed:^(NSString *errorMsg) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancelAction];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (IBAction)introduceButtonClick:(id)sender {
    
    LDAlertNameViewController *nvc = [[LDAlertNameViewController alloc] init];
    nvc.groupName = self.introduceLabel.text;
    nvc.gid = self.gid;
    nvc.type = @"1";
    [self.navigationController pushViewController:nvc animated:YES];
}

- (IBAction)startChatButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系!"];
    }else{
        
        NSDictionary *parameters = @{@"gid":self.gid};
        [NetManager afPostRequest:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getGroupinfo"] parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer == 2000) {
                LDGroupChatViewController *cvc = [[LDGroupChatViewController alloc] init];
                cvc.conversationType = ConversationType_GROUP;
                cvc.targetId = self.gid;
                cvc.title = responseObj[@"data"][@"groupname"];
                cvc.groupId = self.gid;
                [self.navigationController pushViewController:cvc animated:YES];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        LDReportViewController *rvc = [[LDReportViewController alloc] init];
        
        rvc.reportId = _reportId;
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }];
    
    UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        YSActionSheetView *ysSheet = [[YSActionSheetView alloc] initNYSView];
        ysSheet.name = self.nickName;
        ysSheet.pic = self.picStr;
        ysSheet.comeFrom = @"Group";
        ysSheet.shareId= self.shareId;
        [self.view addSubview:ysSheet];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [action setValue:MainColor forKey:@"_titleTextColor"];
        [shareAction setValue:MainColor forKey:@"_titleTextColor"];
        [cancel setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:cancel];
    [alert addAction:shareAction];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)tapGroupHeadClick:(id)sender {
    
    UIImage *images = self.headView.image;
    CGImageRef cgref = [images CGImage];
    CIImage *cim = [images CIImage];
    
    if (cim == nil && cgref == NULL)
    {
        NSLog(@"no image");
    } else {
        NSLog(@"imageView has a image");
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:0 imagesBlock:^NSArray *{
            NSArray *array = [NSArray arrayWithObject:self.headView.image];
            return array;
        }];
    }
}

- (IBAction)clearpersonbtnClick:(id)sender {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定清理7天未登录用户吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [PICHEADURL stringByAppendingString:shotOffmoreUrl];
        NSString *gid = self.gid;
        NSDictionary *params = @{@"gid":gid?:@""};
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                NSString *msg = [responseObj objectForKey:@"msg"];
                [MBProgressHUD showMessage:msg toView:self.view];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action0 setValue:MainColor forKey:@"_titleTextColor"];
        [action1 setValue:MainColor forKey:@"_titleTextColor"];
    }
    [self presentViewController:control animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
