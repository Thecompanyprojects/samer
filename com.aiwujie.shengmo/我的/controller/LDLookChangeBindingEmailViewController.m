//
//  LDLookChangeBindingEmailViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDLookChangeBindingEmailViewController.h"
#import "LDGetChangeBindingEmailCodeViewController.h"

@interface LDLookChangeBindingEmailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldEmailField;
@property (weak, nonatomic) IBOutlet UIView *oldEmailView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation LDLookChangeBindingEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"更改邮箱";
    
    _oldEmailView.layer.cornerRadius = 2;
    _oldEmailView.clipsToBounds = YES;
    
    _nextButton.layer.cornerRadius = 2;
    _nextButton.clipsToBounds = YES;
}
- (IBAction)nextButtonClick:(id)sender {
    
    if (_oldEmailField.text.length != 0) {
        
        if ([_oldEmailField.text isEqualToString:_emailNum]) {
            
            LDGetChangeBindingEmailCodeViewController *cvc = [[LDGetChangeBindingEmailCodeViewController alloc] init];
            
            cvc.emailNum = _emailNum;
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"原绑定邮箱地址不正确,请重新输入~"];
        }
        
    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入原绑定邮箱~"];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
