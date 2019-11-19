//
//  LDRevisePasswordViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/10.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDRevisePasswordViewController.h"
#import "LDswitchManager.h"

@interface LDRevisePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UIView *oldView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation LDRevisePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    
    self.oldView.layer.cornerRadius = 2;
    self.oldView.clipsToBounds = YES;
    
    self.passwordView.layer.cornerRadius = 2;
    self.passwordView.clipsToBounds = YES;
    
    self.doneButton.layer.cornerRadius = 2;
    self.doneButton.clipsToBounds = YES;
    
    [_passwordField addTarget:self action:@selector(passwordClick:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)passwordClick:(UITextField *)textField{
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if (self.passwordField.text.length >= 16) {
            
            self.passwordField.text = [self.passwordField.text substringToIndex:16];
        }
        
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

- (IBAction)doneButtonClick:(id)sender {

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,editPwdUrl];
    
    if (self.oldPasswordField.text.length == 0) {
        
        self.oldPasswordField.text = @"";
        
    }
    
    if (self.passwordField.text.length == 0) {
        
        self.passwordField.text = @"";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"oldpwd":self.oldPasswordField.text,@"newpwd":self.passwordField.text};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObj objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [[LDswitchManager sharedClient] updateDataWithuserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] andpassword:self.passwordField.text];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failed:^(NSString *errorMsg) {
        
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
