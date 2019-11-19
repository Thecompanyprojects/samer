//
//  LDCertificateBeforeViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDCertificateBeforeViewController.h"
#import "LDCertificateViewController.h"
#import "IdcardViewController.h"

@interface LDCertificateBeforeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UILabel *lab0;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

@property (nonatomic,copy) NSString *idcardstatus;

@end

@implementation LDCertificateBeforeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"认证权限";
    
    if (ISIPHONEX) {
        
        self.openButton.frame = CGRectMake(0, self.openButton.frame.origin.y - 34, self.openButton.frame.size.width, self.openButton.frame.size.height);
    }
   
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:longitude]};
    
    [NetManager afPostRequest:[NSString stringWithFormat:@"%@%@",PICHEADURL,getHeadAndNicknameUrl] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            self.headView.contentMode = UIViewContentModeScaleAspectFill;
        }
    } failed:^(NSString *errorMsg) {
        
    }];

    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    self.headView.layer.cornerRadius = 40;
    self.headView.clipsToBounds = YES;
    self.oneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.oneLabel sizeToFit];
    
    
    if (WIDTH == 320) {
        
        self.oneLabel.font = [UIFont systemFontOfSize:11];
        self.twoLabel.font = [UIFont systemFontOfSize:11];
        self.threeLabel.font = [UIFont systemFontOfSize:11];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        self.vipView.image = [UIImage imageNamed:@"高级灰"];
        
    }else{
    
        self.vipView.image = [UIImage imageNamed:@"高级紫"];
    }
    if ([self.content intValue]==1) {
        [self.openButton setTitle:@"开启身份认证" forState:normal];
    }
    else
    {
        [self.openButton setTitle:@"开启自拍认证" forState:normal];
    }
    [self createData];
    [self getidcardstatus];
}

-(void)createData
{
    [self.img3 setHidden:YES];
    [self.img4 setHidden:YES];
    [self.img5 setHidden:YES];
    [self.lab3 setHidden:YES];
    [self.lab4 setHidden:YES];
    [self.lab5 setHidden:YES];
    if ([self.content intValue]==0) {
        [self.lab2 setHidden:NO];
        [self.img2 setHidden:NO];
        self.lab0.text = @"个人主页可出现在身边-推荐";
        self.lab1.text = @"群成员列表排名靠前";
        self.lab2.text = @"黑名单人数上限增加至200人";
        [self.oneLabel setHidden:NO];
        
    }
    else
    {
        [self.lab1 setHidden:YES];
        [self.img1 setHidden:YES];
        
        [self.img2 setHidden:NO];
        self.lab0.text = @"昵称右侧点亮身份认证蓝色图标";
        self.lab2.text = @"更多特权敬请期待";
        [self.oneLabel setHidden:YES];
        self.twoLabel.text = @"1.身份认证仅用于个人认证，其他用户不可查看，提交后48小时内进行审核。";
        self.threeLabel.text = @"2.请确保上传身份证信息清晰并于本人一致，否则将不予通过，已通过者发现后将会被取消认证标识。";
    }
}

- (IBAction)openButtonClick:(id)sender {
    if ([self.content intValue]==0) {
        if ([self.type isEqualToString:@"正在审核"]) {
             [MBProgressHUD showMessage:@"正在审核"];
        }
        else
        {
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            cvc.where = self.where;
            cvc.type = self.type;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }
    else
    {
        if ([self.idcardstatus intValue]==1) {
            [MBProgressHUD showMessage:@"正在审核"];
        }
        else
        {
            IdcardViewController *vc = [[IdcardViewController alloc] init];
            vc.state = self.idcardstatus;
            if (self.idcardstatus.length==0) {
                vc.state = @"0";
            }
            if ([self.idcardstatus isEqualToString:@"2"]) {
                vc.state = @"0";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//身份证认证状态查询
-(void)getidcardstatus
{
    if ([self.content intValue]==1) {
        NSString *url = [PICHEADURL stringByAppendingString:@"Api/Other/getrealidcard"];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        [NetManager afPostRequest:url parms:@{@"uid":uid} finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                NSDictionary *data = [responseObj objectForKey:@"data"];
                self.idcardstatus = [NSString stringWithFormat:@"%@",data[@"code"]]; //   1：正在认证(审核中)  2：重新提交 ‘’：没有认证过或者全未通过
                
                if (self.idcardstatus.length==0) {
                     [self.openButton setTitle:@"开启自拍认证" forState:normal];
                }
                if ([self.idcardstatus isEqualToString:@"2"]) {
                     [self.openButton setTitle:@"重新认证" forState:normal];
                }
                if ([self.idcardstatus isEqualToString:@"1"]) {
                    [self.openButton setTitle:@"审核中" forState:normal];
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
