//
//  LDSetGenstureViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/3/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSetGenstureViewController.h"
#import "WUGesturesUnlockViewController.h"

@interface LDSetGenstureViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation LDSetGenstureViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([WUGesturesUnlockViewController gesturesPassword] == nil) {
        
        self.switchButton.on = NO;
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"手势"] isEqualToString:@"yes"]) {
            
            self.switchButton.on = YES;
            
        }else {
            
            self.switchButton.on = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"手势密码设置";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSuccess) name:@"绘制成功" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFail) name:@"绘制失败" object:nil];
}

-(void)setFail{

    self.switchButton.on = NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"手势"];
}

-(void)setSuccess{

    self.switchButton.on = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"手势"];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"绘制成功" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"绘制失败" object:nil];
    
}

- (IBAction)switchButtonClick:(id)sender {
    
    if ([WUGesturesUnlockViewController gesturesPassword] == nil) {
        
        WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"手势"] isEqualToString:@"yes"]) {
            
            self.switchButton.on = NO;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"手势"];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"手势"];
            
            self.switchButton.on = YES;
        }
    }
}
- (IBAction)repeatButtonClick:(id)sender {
    
    WUGesturesUnlockViewController *vc = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
    
    vc.state = @"重置密码";
    
    [self.navigationController pushViewController:vc animated:YES];
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
