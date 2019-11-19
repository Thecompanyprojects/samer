//
//  LDCertificateViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/10.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDCertificateViewController.h"
#import "LDDiscoverViewController.h"
#import "LDMineViewController.h"
#import "LDInformationViewController.h"
#import "LDGroupUpViewController.h"
#import "LDSetViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDAttentionListViewController.h"
#import "PersonChatViewController.h"
#import "LDDynamicDetailViewController.h"

@interface LDCertificateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic,copy) NSString *headUrl;

//公开认证照片的状态
@property (nonatomic,copy) NSString *status;
@property (weak, nonatomic) IBOutlet UIButton *noPublicButton;
@property (weak, nonatomic) IBOutlet UIButton *vipLookButton;

@end

@implementation LDCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自拍认证";
    
    self.submitButton.layer.cornerRadius = 2;
    self.submitButton.clipsToBounds = YES;
    
    if ([self.type isEqualToString:@"已认证"]) {
        self.status = @"1";
        [self.submitButton setTitle:@"重新认证" forState:UIControlStateNormal];
        [self createData];
    }
    else
    {
        self.status = @"0";
    }
    
}
- (IBAction)noPublicButtonClick:(id)sender {
    
    if ([_status intValue] != 0) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setRealnameState/status/nobody"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer == 2000) {
                
                [self.noPublicButton setImage:[UIImage imageNamed:@"照片认证实圈"] forState:UIControlStateNormal];
                
                [self.vipLookButton setImage:[UIImage imageNamed:@"照片认证空圈"] forState:UIControlStateNormal];
                
                _status = @"0";
                
            }else if (integer == 3000 || integer == 3001){
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,操作失败~"];
                
            }
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}
- (IBAction)vipLookButtonClick:(id)sender {
    
    if (![self.type isEqualToString:@"正在审核"]) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setRealnameState/status/vip"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer == 2000) {
                
                [self.noPublicButton setImage:[UIImage imageNamed:@"照片认证空圈"] forState:UIControlStateNormal];
                
                [self.vipLookButton setImage:[UIImage imageNamed:@"照片认证实圈"] forState:UIControlStateNormal];
                
                _status = @"1";
                
            }else if (integer == 3000 || integer == 3001){
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,操作失败~"];
                
            }
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"card_face"]]]];
            
            _status = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"status"]];
            
            if ([_status intValue] == 0) {
                
                [self.noPublicButton setImage:[UIImage imageNamed:@"照片认证实圈"] forState:UIControlStateNormal];
                
                [self.vipLookButton setImage:[UIImage imageNamed:@"照片认证空圈"] forState:UIControlStateNormal];
                
            }else{
                
                [self.noPublicButton setImage:[UIImage imageNamed:@"照片认证空圈"] forState:UIControlStateNormal];
                
                [self.vipLookButton setImage:[UIImage imageNamed:@"照片认证实圈"] forState:UIControlStateNormal];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (IBAction)tapPic:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //拍照  调用相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark  imagePicker的代理方法

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[@"UIImagePickerControllerEditedImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    _uploadImageView.image = img;
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.1);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _headUrl = responseObject[@"data"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)submitButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.type isEqualToString:@"已认证"]) {
        
        if (_headUrl.length == 0) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请更换认证照后在提交~"];
            
        }else{
            
           
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/replaceidcard"];
            
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"card_replace":_headUrl};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (integer != 2000) {
                    
                    if (integer == 3000) {
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                        
                    }else{
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后重试~"];
                        
                    }
                    
                }else{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            } failed:^(NSString *errorMsg) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }

    }else{
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/setidcard"];
        
        if (_headUrl.length == 0) {
            
            _headUrl = @"";
        }
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"card_face":_headUrl};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                if ([self.where intValue] == 1) {
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDGroupUpViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                            
                        }
                    }
                    
                }else if ([self.where intValue] == 2){
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDOwnInformationViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }else if ([self.where intValue] == 3){
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDInformationViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }else if([self.where intValue] == 4){
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if ([self.where intValue] == 5){
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDDiscoverViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }else if ([self.where intValue] == 6){
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDAttentionListViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }else if ([self.where intValue]==7)
                {
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDAttentionpageVC class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }
                else if ([self.where intValue]==8)
                {
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[PersonChatViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }
                else if ([self.where intValue]==9)
                {
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDDynamicDetailViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                }
                else{
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDMineViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                }
            }
        } failed:^(NSString *errorMsg) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
