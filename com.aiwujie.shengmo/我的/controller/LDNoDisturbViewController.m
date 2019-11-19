//
//  LDNoDisturbViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDNoDisturbViewController.h"

@interface LDNoDisturbViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *allSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vipSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *certificationSwitch;

@end

@implementation LDNoDisturbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"消息设置";
    
    [self getState];
}

-(void)getState{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getRestrictState"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            if ([responseObj[@"data"] intValue] == 1) {
                
                _allSwitch.on = YES;
                
                _vipSwitch.on = NO;
                
                _certificationSwitch.on = NO;
                
            }else if ([responseObj[@"data"] intValue] == 2){
                
                _allSwitch.on = NO;
                
                _vipSwitch.on = NO;
                
                _certificationSwitch.on = YES;
                
            }else if ([responseObj[@"data"] intValue] == 3){
                
                _allSwitch.on = NO;
                
                _vipSwitch.on = YES;
                
                _certificationSwitch.on = NO;
            }
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}
- (IBAction)allSwitchClick:(id)sender {
    
    [self changeState:@"1"];
}
- (IBAction)vipSwitchClick:(id)sender {
    
    [self changeState:@"3"];
}
- (IBAction)certificationSwitchClick:(id)sender {
    
    [self changeState:@"2"];
}

-(void)changeState:(NSString *)state{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/setRestrictState"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"state":state};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([state intValue] == 1) {
                
                _allSwitch.on = YES;
                
                _vipSwitch.on = NO;
                
                _certificationSwitch.on = NO;
                
            }else if ([state intValue] == 2){
                
                _allSwitch.on = NO;
                
                _vipSwitch.on = NO;
                
                _certificationSwitch.on = YES;
                
            }else if ([state intValue] == 3){
                
                _allSwitch.on = NO;
                
                _vipSwitch.on = YES;
                
                _certificationSwitch.on = NO;
            }
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self getState];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([state intValue] == 1) {
            
            _allSwitch.on = YES;
            
            _vipSwitch.on = NO;
            
            _certificationSwitch.on = NO;
            
        }else if ([state intValue] == 2){
            
            _allSwitch.on = NO;
            
            _vipSwitch.on = NO;
            
            _certificationSwitch.on = YES;
            
        }else if ([state intValue] == 3){
            
            _allSwitch.on = NO;
            
            _vipSwitch.on = YES;
            
            _certificationSwitch.on = NO;
        }
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络请求超时,请重试~"];

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
