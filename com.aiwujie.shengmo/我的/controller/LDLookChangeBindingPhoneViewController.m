//
//  LDLookChangeBindingPhoneViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDLookChangeBindingPhoneViewController.h"
#import "LDGetChangeBindingPhoneNumCodeViewController.h"

@interface LDLookChangeBindingPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation LDLookChangeBindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"更换手机号";
    
    _phoneView.layer.borderWidth = 0.5;
    _phoneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _phoneView.layer.cornerRadius = 2;
    _phoneView.clipsToBounds = YES;
    
    _nextButton.layer.cornerRadius = 2;
    _nextButton.clipsToBounds = YES;
    
    NSString *str = [_phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    _phoneLabel.text = str;
    
}
- (IBAction)nextButtonClick:(id)sender {
    
    LDGetChangeBindingPhoneNumCodeViewController *cvc = [[LDGetChangeBindingPhoneNumCodeViewController alloc] init];
    
    cvc.phoneNum = _phoneNum;
    
    [self.navigationController pushViewController:cvc animated:YES];
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
