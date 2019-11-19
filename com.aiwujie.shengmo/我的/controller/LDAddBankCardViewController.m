//
//  LDAddBankCardViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAddBankCardViewController.h"

@interface LDAddBankCardViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *bankField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation LDAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加银行卡";
    
    self.addButton.layer.cornerRadius = 2;
    
    self.addButton.clipsToBounds = YES;
    
    if (_dict != nil) {
        
        self.nameField.text = _dict[@"realname"];
        
        self.bankField.text = _dict[@"bankname"];
        
        self.bankCardField.text = _dict[@"bankcard"];
    }
    
    [_bankCardField addTarget:self action:@selector(bankCardFieldClick) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)bankCardFieldClick{

    if (self.bankCardField.text.length >= 16) {
        
        [self createData];
        
    }else{
    
        self.bankField.text = nil;
    }
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getBanknameByBanknum"];

    NSDictionary *parameters = @{@"bankcard":self.bankCardField.text};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            self.bankField.text = responseObj[@"data"];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}
- (IBAction)addButtonClick:(id)sender {

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/addbankcard"];
    
    if (self.nameField.text.length == 0) {
        
        self.nameField.text = @"";
        
    }
    
    if (self.bankField.text.length == 0) {
        
        self.bankField.text = @"";
    }
    
    if (self.bankCardField.text.length == 0) {
        
        self.bankCardField.text = @"";
    }
    
    NSDictionary *parameters;
    
    if (_dict == nil) {
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"bankcard":self.bankCardField.text,@"bankname":self.bankField.text,@"realname":self.nameField.text};
        
    }else{
    
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"bankcard":self.bankCardField.text,@"bankname":self.bankField.text,@"realname":self.nameField.text,@"bid":_dict[@"bid"]};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
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

@end
