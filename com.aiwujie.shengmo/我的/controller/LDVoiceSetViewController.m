//
//  LDVoiceSetViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/3/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDVoiceSetViewController.h"

@interface LDVoiceSetViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shockSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;

@end

@implementation LDVoiceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"声音设置";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
        
        _voiceSwitch.on = YES;
        
    }else{
    
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
        
        _voiceSwitch.on = NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
        
        _notificationSwitch.on = YES;
        
    }else{
        
        [RCIM sharedRCIM].disableMessageNotificaiton = YES;
        
        _notificationSwitch.on = NO;
    }

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] isEqualToString:@"no"]) {
        
        _shockSwitch.on = NO;
        
    }else{
        
        _shockSwitch.on = YES;
    }
    
    [self.view addSubview:self.line0];
    [self.view addSubview:self.line1];
    
    [self setuplayout];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(51);
        make.left.equalTo(weakSelf.view).with.offset(18);
        make.right.equalTo(weakSelf.view);
        make.height.mas_offset(1);
    }];
    [weakSelf.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(102);
        make.left.equalTo(weakSelf.view).with.offset(18);
        make.right.equalTo(weakSelf.view);
        make.height.mas_offset(1);
    }];
}

#pragma mark - getters

-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    }
    return _line0;
}


-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    }
    return _line1;
}


- (IBAction)notificationSwitch:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageNotificaiton = YES;
        
        _notificationSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"notificationSwitch"];
        
    }else{
        
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
        
        _notificationSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"notificationSwitch"];
    }

}

- (IBAction)shockSwitch:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] isEqualToString:@"no"]) {
        
        _shockSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"shockSwitch"];
        
    }else{
        
        _shockSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"shockSwitch"];
    }
}

- (IBAction)voiceSwitch:(id)sender{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
        
        _voiceSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"voiceSwitch"];
        
    }else{
        
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
        
        _voiceSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"voiceSwitch"];
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
