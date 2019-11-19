//
//  LDReportResonViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDReportResonViewController.h"

@interface LDReportResonViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation LDReportResonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if ([self.type isEqualToString:@"dynamic"]) {
        
         self.navigationItem.title = @"举报原因";
        
        self.textView.text = @"";
        
        _showLabel.text = @"请输入举报理由（可选）";
        
    }else if ([self.type isEqualToString:@"recommendDynamic"]){
        
         self.navigationItem.title = @"推荐理由";
    
        self.textView.text = @"";
        
        _showLabel.text = @"请输入推荐理由（可选）";
        
    }else{
        
         self.navigationItem.title = @"举报原因";
        
        _showLabel.text = @"请输入举报理由";
    
        if (self.reason.length == 0) {
            
            self.textView.text = @"";
            
            _showLabel.hidden = NO;
            
        }else{
            
            self.textView.text = self.reason;
            
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/256",(unsigned long)self.textView.text.length];
            
            _showLabel.hidden = YES;
        }
        
    }
    
    
    [self.textView becomeFirstResponder];
    
    [self createButton];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        _showLabel.hidden = NO;
        
    }else{
    
        _showLabel.hidden = YES;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if (textView.text.length >= 256) {
            
            textView.text = [textView.text substringToIndex:256];
            
            self.numberLabel.text = @"256/256";
            
        }else{
            
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/256",(unsigned long)self.textView.text.length];
            
        }
        
    }

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if ([self.type isEqualToString:@"dynamic"]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/reportDynamic"];
        
        NSDictionary *parameters;

        NSString *reason;
        
        if (self.textView.text.length == 0) {
            
            reason = @"";
            
        }else{
        
            reason = self.textView.text;
        }
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":self.did,@"reason":reason};
    
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                self.block(@"0");
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"举报失败~"];
                
                
            }else if(integer == 2000){
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                self.block(@"1");
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"举报成功，请等待审核~"    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        } failed:^(NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.block(@"0");
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络请求失败,请稍后重试~"];
        }];

        
    }else if ([self.type isEqualToString:@"recommendDynamic"]){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *url;
        
        NSString *reason;
        
        if (self.textView.text.length == 0) {
            
            reason = @"";
            
        }else{
            
            reason = self.textView.text;
        }
        
        NSDictionary *parameters;
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"reason":reason};
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/recommendDynamic"];
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer == 3001) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您已经推荐过了~"];
            }else if(integer == 2000){
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"推荐成功，请等待审核~"    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请重试~"];
                
            }
        } failed:^(NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络请求失败,请稍后重试~"];
        }];
        
    }else{
        self.block(self.textView.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
