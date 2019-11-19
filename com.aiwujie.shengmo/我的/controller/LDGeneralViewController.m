//
//  LDGeneralViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGeneralViewController.h"
#import "MBProgressHUD.h"

@interface LDGeneralViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation LDGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通用";
    self.view.backgroundColor = [UIColor whiteColor];
    float folderSize;
    folderSize = [[SDImageCache sharedImageCache] getSize] /1024 / 1024;
    if (folderSize == 0) {
        self.cacheLabel.text = @"";
    }else{
        self.cacheLabel.text = folderSize >= 1 ? [NSString stringWithFormat:@"%.2fM",folderSize] : [NSString stringWithFormat:@"%.2fK",folderSize * 1024];
    }
    [self.view addSubview:self.lineView];
    [self setuplayout];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(51);
        make.left.equalTo(weakSelf.view).with.offset(20);
        make.right.equalTo(weakSelf.view);
        make.height.mas_offset(1);
    }];
}

-(UIView *)lineView
{
    if(!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    }
    return _lineView;
}


- (IBAction)deleteCacheButtonClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空缓存"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"清理缓存成功";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        
        self.cacheLabel.text = @"";
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [action setValue:MainColor forKey:@"_titleTextColor"];
        
        [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    
    [alert addAction:action];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (IBAction)deleteChatCacheButtonClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空聊天记录"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *array =  [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
        
        if (array.count > 0) {
            
            for (int i = 0; i < array.count; i++) {
                
                RCConversation *conversation = array[i];
                
                [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:conversation.conversationType targetId:conversation.targetId recordTime:[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000] longLongValue] success:^{
                    
                    [[RCIMClient sharedRCIMClient] clearMessages:conversation.conversationType targetId:conversation.targetId];
                    
                } error:^(RCErrorCode status) {
                    
                    
                    
                }];
            }
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"清空聊天记录成功";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"清空聊天记录" object:nil];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action setValue:MainColor forKey:@"_titleTextColor"];
        [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:action];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
