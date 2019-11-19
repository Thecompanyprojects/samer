//
//  LDSetgroupVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/2.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDSetgroupVC.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "LDAttentiongroupModel.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

@interface LDSetgroupVC ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *tagArr;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,assign) BOOL isadd;
@property (nonatomic,strong) NSDictionary *params;
@end

@implementation LDSetgroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置分组";
    [self rightbtns];
    self.params = [NSDictionary dictionary];
    self.dataSource = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    [self creategroupinfo];
}

-(void)creategroupinfo
{
    self.dataSource = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    NSString *url = [PICHEADURL stringByAppendingString:getfriendgrouplistUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *params = @{@"uid":uid,@"fuid":self.fuid?:@""};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSArray *data = [NSArray yy_modelArrayWithClass:[LDAttentiongroupModel class] json:responseObj[@"data"]];
            [self.dataSource addObjectsFromArray:data];
            [self createUI];
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)createUI
{
    self.tagArr = [NSMutableArray array];
    NSMutableArray *is_selectArray = [NSMutableArray array];
    for (int i = 0; i<self.dataSource.count; i++) {
        LDAttentiongroupModel *model = [self.dataSource objectAtIndex:i];
        [self.tagArr addObject:model.fgname];
        [is_selectArray addObject:model.is_select];
    }

    CGFloat tagBtnX = 16;
    CGFloat tagBtnY = 10;
    for (int i= 0; i<self.tagArr.count; i++) {
        
        CGSize tagTextSize = [self.tagArr[i] sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(Width-32-32, 30)];
        if (tagBtnX+tagTextSize.width+30 > Width-32) {
            
            tagBtnX = 16;
            tagBtnY += 30+15;
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = 100+i;

        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+30, 30);
        [tagBtn setTitle:self.tagArr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.titleLabel.font = GlobalFont(14);
        tagBtn.layer.cornerRadius = 15;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = MainColor.CGColor;
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *isselect = [is_selectArray objectAtIndex:i];
        if ([isselect intValue]==1) {
            tagBtn.selected = YES;
            [tagBtn setBackgroundColor:MainColor];
            LDAttentiongroupModel *model = [self.dataSource objectAtIndex:i];
            [self.selectArray addObject:model];
        }
        else
        {
            tagBtn.selected = NO;
            [tagBtn setBackgroundColor:[UIColor clearColor]];
        }
        [self.view addSubview:tagBtn];
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
    }
}

- (void)tagBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSInteger index = btn.tag-100;
    if (btn.selected)
    {
        [btn setBackgroundColor:MainColor];
        LDAttentiongroupModel *model = [self.dataSource objectAtIndex:index];
        [self.selectArray addObject:model];
        self.isadd = YES;
    }
    if (!btn.selected)
    {
        [btn setBackgroundColor:[UIColor clearColor]];
        
        LDAttentiongroupModel *model = [self.dataSource objectAtIndex:index];
        
        for (int i = 0; i<self.selectArray.count; i++) {
            LDAttentiongroupModel *selModel = [self.selectArray objectAtIndex:i];
            if ([selModel.fgname isEqualToString:model.fgname]) {
                [self.selectArray removeObjectAtIndex:i];
            }
        }

        NSString *fuid = self.fuid;
 
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *fgid = model.Newid;
        NSDictionary *params = @{@"uid":uid,@"fgid":fgid,@"fuid":fuid};
        NSString *url = [PICHEADURL stringByAppendingString:delfgusersUrl];

        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                self.isadd = YES;
            }
//            NSString *msg = [responseObj objectForKey:@"msg"];
//            [MBProgressHUD showMessage:msg];
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

-(void)rightbtns
{
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [right setTitle:@"增组" forState:UIControlStateNormal];
    [right setTitleColor:TextCOLOR forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(addbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backOnClick
{
    NSMutableArray *fgidArray = [NSMutableArray new];
    for (int i =0; i<self.selectArray.count; i++) {
        LDAttentiongroupModel *model = [self.selectArray objectAtIndex:i];
        [fgidArray addObject:model.Newid];
    }
    
    NSString *fgid = [fgidArray componentsJoinedByString:@","];
    if (fgidArray.count==0) {
        fgid = @"";
        [MBProgressHUD showMessage:@"请选择分组"];
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *params = @{@"uid":uid,@"fuid":self.fuid?:@"",@"fgid":fgid};
    self.params = params.copy;
    
}

-(void)addbuttonClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入分组名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入分组名称";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        
        NSString *url = [PICHEADURL stringByAppendingString:addfriendgroupUrl];
        NSString *fgname = envirnmentNameTextField.text?:@"";
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        if (fgname.length==0) {
            [AlertTool alertqute:self andTitle:@"提示" andMessage:@"请输入分组名称"];
            return ;
        }
        NSString *newFgname = [NSString new];
        if (fgname.length>4) {
            [AlertTool alertqute:self andTitle:@"提示" andMessage:@"限4字以内"];
            newFgname = [fgname substringToIndex:4];
            return;
        }
        else
        {
            newFgname = fgname.copy;
        }
        NSDictionary *params = @{@"uid":uid,@"fgname":newFgname?:@""};
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            
            NSString *msg = [responseObj objectForKey:@"msg"];
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                [self creategroupinfo];
            }
            [MBProgressHUD showMessage:msg toView:self.view];
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        if (self.Returnback) {
            if (self.isadd) {
                [self backOnClick];
                self.Returnback(self.params);
            }
        }
    }
}

@end
