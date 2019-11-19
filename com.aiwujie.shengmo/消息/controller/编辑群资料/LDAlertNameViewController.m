//
//  LDAlertNameViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlertNameViewController.h"

@interface LDAlertNameViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation LDAlertNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.text = self.groupName;
    if (self.isliaotians) {
        if ([self.type intValue] == 1) {
            self.navigationItem.title = @"聊吧介绍";
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)self.textView.text.length];
        }else{
            self.navigationItem.title = @"聊吧名称";
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)self.textView.text.length];
        }
    }
    else
    {
        if ([self.type intValue] == 1) {
            self.navigationItem.title = @"群介绍";
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)self.textView.text.length];
        }else{
            self.navigationItem.title = @"群名称";
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)self.textView.text.length];
        }
    }
    [self.textView becomeFirstResponder];
    [self createButton];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([self.type intValue] == 1) {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            
            if (textView.text.length >= 500) {
                
                textView.text = [textView.text substringToIndex:500];
                
                self.numberLabel.text = @"500/500";
                
            }else{
                
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)self.textView.text.length];
                
            }
            
        }
    
        
    }else{
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (textView.text.length >= 10) {
                
                textView.text = [textView.text substringToIndex:10];
                
                self.numberLabel.text = @"10/10";
                
            }else{
                
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)self.textView.text.length];
                
            }
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if (self.isliaotians) {
        
        if (self.textView.text.length == 0) {
            if ([self.type intValue] == 1) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"聊吧介绍不能为空~"];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"聊吧名称不能为空~"];
            }
        }else{
            
            if ([self.type intValue] == 1)
            {
                NSString *url = [PICHEADURL stringByAppendingString:@"api/power/editChatinfo"];
                NSDictionary *params = @{@"roomid":self.roomId?:@"",@"count":self.textView.text?:@""};
                [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                    
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    [MBProgressHUD showMessage:msg];
                    if (self.block) {
                        [self.navigationController popViewControllerAnimated:YES];
                        self.block(self.textView.text?:@"");
                    }
                    
                } failed:^(NSString *errorMsg) {
                    
                }];
            }
            else
            {
                NSString *url = [PICHEADURL stringByAppendingString:@"api/power/editChatName"];
                NSDictionary *params = @{@"roomid":self.roomId?:@"",@"name":self.textView.text?:@""};
                [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
                    
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    [MBProgressHUD showMessage:msg];
                    if (self.block) {
                        [self.navigationController popViewControllerAnimated:YES];
                        self.block(self.textView.text?:@"");
                    }
                    
                } failed:^(NSString *errorMsg) {
                    
                }];
            }
        }
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if (self.textView.text.length == 0) {
            
            if ([self.type intValue] == 1) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"群介绍不能为空~"];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"群名称不能为空~"];
                
            }
            
        }else{
            
            if ([self.groupName isEqualToString:self.textView.text]) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请修改后保存~"];
                
            }else{
                
                if([self.textView.text containsString:@"奴"] || [self.textView.text containsString:@"虐"] || [self.textView.text containsString:@"性"] || [self.textView.text containsString:@"狗"] || [self.textView.text containsString:@"畜"] || [self.textView.text containsString:@"贱"] || [self.textView.text containsString:@"骚"] || [self.textView.text containsString:@"淫"] || [self.textView.text containsString:@"阴"] || [self.textView.text containsString:@"肛"] || [self.textView.text containsString:@"SM"] || [self.textView.text containsString:@"sm"] || [self.textView.text containsString:@"Sm"] || [self.textView.text containsString:@"sM"]){
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"很抱歉，您的昵称包含有禁止使用的字：奴、虐、性、狗、畜、贱、骚、淫、阴、肛、SM、sm、Sm、sM，请修改后重试~"];
                    
                }else{
                    
                    if ([self.type intValue] != 1) {
                        
                        if ([self isEmpty:self.textView.text]) {
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"群昵称不能包含空格~"];
                            
                        }else{
                            
                            [self alertGroupNameOrGroupIntroduce];
                        }
                        
                    }else{
                        
                        [self alertGroupNameOrGroupIntroduce];
                    }
                }
            }
        }
    }
}

/**
 * 修改群名称或修改群介绍
 */

-(void)alertGroupNameOrGroupIntroduce{

    NSDictionary *parameters;
    
    if ([self.type intValue] == 1) {
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"gid":self.gid,@"introduce":self.textView.text};
        
    }else{
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"gid":self.gid,@"groupname":self.textView.text};
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/editGroupInfo"];
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            if ([self.type intValue] != 1) {
                
                self.block(self.textView.text);
                
                //此处为了演示写了一个用户信息
                RCGroup *group = [[RCGroup alloc]init];
                group.groupId = self.gid;
                group.groupName = self.textView.text;
                //NSLog(@"%@",responseObject[@"data"][@"head_pic"]);
                [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:self.gid];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//判定昵称中是否包含空格
-(BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
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
