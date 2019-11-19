
//
//  IdcardViewController.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/9.
//  Copyright © 2019 a. All rights reserved.
//

#import "IdcardViewController.h"
#import "IDCardCaptureViewController.h"
#import "TIDCardCaptureViewController.h"
#import "idcardImg.h"
//照片选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "imagebrowserVC.h"
#import "idcardCell.h"

static NSString *cardidentfity = @"cardidentfity";

@interface IdcardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@property (nonatomic,strong) UIImageView *img2;
@property (nonatomic,copy) NSString *headUrl;

@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UITextField *text0;
@property (nonatomic,strong) UITextField *text1;
@property (nonatomic,strong) idcardImg *idimg0;
@property (nonatomic,strong) idcardImg *idimg1;
@property (nonatomic,strong) idcardImg *idimg2;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *footView;

@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,copy) NSString *str0;
@property (nonatomic,copy) NSString *str1;
@property (nonatomic,copy) NSString *str2;
@property (nonatomic,copy) NSString *typeStr;

@property (nonatomic,copy) NSString *card_z;
@property (nonatomic,copy) NSString *card_f;
@property (nonatomic,copy) NSString *card_hand;

@end

static NSString *idcardidentfity = @"idcardidentfity";

@implementation IdcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份证认证";

    [self createTableView];
    [self getdatafromweb];
    
    if ([self.state isEqualToString:@"3"]) {
        [self.submitBtn setTitle:@"重新认证" forState:normal];
    }
    else
    {
        [self.submitBtn setTitle:@"认证" forState:normal];
    }
}

-(void)getdatafromweb
{
    NSString *url = [PICHEADURL stringByAppendingString:getrealidstateUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    [NetManager afPostRequest:url parms:@{@"uid":uid} finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            self.str0 = [PICHEADURL stringByAppendingString:[data objectForKey:@"card_z"]];
            self.str1 = [PICHEADURL stringByAppendingString:[data objectForKey:@"card_f"]];
            self.str2 = [PICHEADURL stringByAppendingString:[data objectForKey:@"card_hand"]];
            self.text0.text = [data objectForKey:@"real_name"];
            self.text1.text = [data objectForKey:@"ids"];
            
            UIImageView *img0 = [self.tableView viewWithTag:201];
            UIImageView *img1 = [self.tableView viewWithTag:202];
            UIImageView *img2 = [self.tableView viewWithTag:203];
            [img0 sd_setImageWithURL:[NSURL URLWithString:self.str0]];
            [img1 sd_setImageWithURL:[NSURL URLWithString:self.str1]];
            [img2 sd_setImageWithURL:[NSURL URLWithString:self.str2]];
            
            [self.tableView reloadData];
            
        }
        if ([[responseObj objectForKey:@"retcode"] intValue]==2001) {
            
        }
        
        [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.footView;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 0, WIDTH, 110);
        [_headView addSubview:self.lab0];
        [_headView addSubview:self.lab1];
        [_headView addSubview:self.text0];
        [_headView addSubview:self.text1];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, 0, WIDTH, 60);
        [_footView addSubview:self.submitBtn];
    }
    return _footView;
}


-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.textColor = TextCOLOR;
        _lab0.font = [UIFont systemFontOfSize:14];
        _lab0.text = @"真实姓名*";
        _lab0.frame = CGRectMake(20, 20, 68, 30);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_lab0.text];
        [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(4,1)];
        _lab0.attributedText = str;
    }
    return _lab0;
}

-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textColor = TextCOLOR;
        _lab1.font = [UIFont systemFontOfSize:14];
        _lab1.text = @"身份证号*";
        _lab1.frame  = CGRectMake(20, 65, 68, 30);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_lab1.text];
        [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(4,1)];
        _lab1.attributedText = str;
    }
    return _lab1;
}

-(UITextField *)text0
{
    if(!_text0)
    {
        _text0 = [[UITextField alloc] init];
        _text0.delegate = self;
        _text0.placeholder = @"请输入真实姓名";
        _text0.layer.masksToBounds = YES;
        _text0.layer.cornerRadius = 4;
        _text0.layer.borderWidth = 1;
        _text0.layer.borderColor =  [UIColor colorWithHexString:@"F5F5F5" alpha:1].CGColor;
        _text0.frame = CGRectMake(88, 20, WIDTH-100, 30);
    }
    return _text0;
}

-(UITextField *)text1
{
    if(!_text1)
    {
        _text1 = [[UITextField alloc] init];
        _text1.delegate = self;
        _text1.placeholder = @"请输入身份证号";
        _text1.layer.masksToBounds = YES;
        _text1.layer.cornerRadius = 4;
        _text1.layer.borderWidth = 1;
        _text1.layer.borderColor =  [UIColor colorWithHexString:@"f5f5f5" alpha:1].CGColor;
        _text1.frame = CGRectMake(88, 65, WIDTH-100, 30);
    }
    return _text1;
}


-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(15, 15, WIDTH-30, 40);
        _submitBtn.layer.cornerRadius = 9;
        _submitBtn.backgroundColor = MainColor;
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_submitBtn setTitle:@"认证" forState:normal];
        [_submitBtn addTarget:self action:@selector(submitbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    idcardCell *cell = [tableView dequeueReusableCellWithIdentifier:cardidentfity];
    if (!cell) {
        cell = [[idcardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardidentfity];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.titleLab.text = @"上传身份证(人像面)*";
        cell.idimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress1)];
        [cell.idimg addGestureRecognizer:singleTap1];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.titleLab.text];
        [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(10,1)];
        cell.titleLab.attributedText = str;
        cell.leftImg.image = [UIImage imageNamed:@"身份证正面"];
        cell.idimg.tag = 201;
        cell.leftImg.clipsToBounds = YES;
        cell.leftImg.contentMode = UIViewContentModeScaleAspectFill;
        cell.idimg.clipsToBounds = YES;
        cell.idimg.contentMode = UIViewContentModeScaleAspectFill;
        if (self.str0.length==0) {
            [cell.idimg.addImg setHidden:NO];
        }
        else
        {
            [cell.idimg.addImg setHidden:YES];
        }
    }
    if (indexPath.row==1) {
        cell.titleLab.text = @"上传身份证(国徽面)*";
        cell.idimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress2)];
        [cell.idimg addGestureRecognizer:singleTap1];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.titleLab.text];
        [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(10,1)];
        cell.titleLab.attributedText = str;
        cell.leftImg.image = [UIImage imageNamed:@"身份证背面"];
        cell.idimg.tag = 202;
        cell.leftImg.clipsToBounds = YES;
        cell.leftImg.contentMode = UIViewContentModeScaleAspectFill;
        cell.idimg.clipsToBounds = YES;
        cell.idimg.contentMode = UIViewContentModeScaleAspectFill;
        if (self.str1.length==0) {
            [cell.idimg.addImg setHidden:NO];
        }
        else
        {
            [cell.idimg.addImg setHidden:YES];
        }
    }
    if (indexPath.row==2) {
        cell.titleLab.text = @"上传手持身份证照*";
        cell.idimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress3)];
        [cell.idimg addGestureRecognizer:singleTap1];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.titleLab.text];
        [str addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(8,1)];
        cell.titleLab.attributedText = str;
        cell.leftImg.image = [UIImage imageNamed:@"身份证示例"];
        cell.idimg.tag = 203;
        cell.leftImg.clipsToBounds = YES;
        cell.leftImg.contentMode = UIViewContentModeScaleAspectFill;
        cell.idimg.clipsToBounds = YES;
        cell.idimg.contentMode = UIViewContentModeScaleAspectFill;
        if (self.str2.length==0) {
            [cell.idimg.addImg setHidden:NO];
        }
        else
        {
            [cell.idimg.addImg setHidden:YES];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - click

-(void)submitbtnClick
{
    NSString *url = [PICHEADURL stringByAppendingString:setrealidcardUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];

    NSString *real_name = self.text0.text?:@"";
    NSString *ids = self.text1.text?:@"";
    
    if (real_name.length==0) {
        [MBProgressHUD showMessage:@"请输入身份证号"];
        return;
    }
    if (ids.length==0) {
        [MBProgressHUD showMessage:@"请输入真实姓名"];
        return;
    }
    if (self.card_z.length==0) {
        [MBProgressHUD showMessage:@"请上传身份证正面照片"];
        return;
    }
    if (self.card_f.length==0) {
        [MBProgressHUD showMessage:@"请上传身份证反面照片"];
        return;
    }
    if (self.card_hand.length==0) {
        [MBProgressHUD showMessage:@"请上传手持身份证照片"];
        return;
    }
    NSDictionary *para = @{@"uid":uid,@"card_z":self.card_z?:@"",@"card_f":self.card_f?:@"",@"card_hand":self.card_hand?:@"",@"real_name":real_name,@"ids":ids,@"state":self.state};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)buttonpress1
{
    self.typeStr = @"0";
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        IDCardCaptureViewController *idcvc = [[IDCardCaptureViewController alloc]init];
        idcvc.sureclick = ^(IDInfo *info, UIImage *idimg) {
            
            [self uploadimgfrom:idimg andtype:@"0"];
        };
        [self.navigationController pushViewController:idcvc animated:YES];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        imagePC.barItemTextColor = TextCOLOR;
        imagePC.barItemTextFont = [UIFont systemFontOfSize:15];
        imagePC.allowCrop = YES;
        [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            
            
            
        }];
        [self presentViewController:imagePC animated:YES completion:^{
            
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:^{
        
    }];
}

-(void)buttonpress2
{
    self.typeStr = @"1";
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TIDCardCaptureViewController *idcvc = [[TIDCardCaptureViewController alloc]init];
        idcvc.sureclick = ^(IDInfo *info, UIImage *idimg) {

//            UIImageView *img1 = [self.tableView viewWithTag:202];
//            img1.image = idimg;
//            [self.tableView reloadData];
            [self uploadimgfrom:idimg andtype:@"1"];
        };
        [self.navigationController pushViewController:idcvc animated:YES];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        imagePC.barItemTextColor = TextCOLOR;
        imagePC.barItemTextFont = [UIFont systemFontOfSize:15];
        imagePC.allowCrop = YES;
        [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            
            
            
        }];
        [self presentViewController:imagePC animated:YES completion:^{
            
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:^{
        
    }];

}

-(void)buttonpress3
{
    self.typeStr = @"2";
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        imagePC.barItemTextColor = TextCOLOR;
        imagePC.barItemTextFont = [UIFont systemFontOfSize:15];
        imagePC.allowCrop = YES;
        [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            
    
                UIImageView *img2 = [self.tableView viewWithTag:203];
                img2.image = coverImage;
                [self.tableView reloadData];
          
            
            
        }];
        [self presentViewController:imagePC animated:YES completion:^{
            
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:^{
        
    }];
    
}

#pragma mark  imagePicker的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[@"UIImagePickerControllerEditedImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);

        [self uploadimgfrom:img andtype:@"2"];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
 
    if (picker.sourceType ==UIImagePickerControllerSourceTypePhotoLibrary) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (/* DISABLES CODE */ (YES)) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                               // [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            
                       
                            
                            imagePicker.allowCrop = YES;
                            imagePicker.needCircleCrop = NO;

                            
                            [self presentViewController:imagePicker animated:YES completion:nil];
                            
                        } else {

                        }
                    }];
                }];
            }
        }];
    }
}


-(void)uploadimgfrom:(UIImage *)img andtype:(NSString *)type
{
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
        if ([[responseObject objectForKey:@"retcode"] intValue]==2000) {
            NSString *str = [responseObject objectForKey:@"data"];
            
            if ([self.typeStr intValue]==0) {
                self.str0 = [PICHEADURL stringByAppendingString:str];
                UIImageView *img = [self.tableView viewWithTag:201];
                [img sd_setImageWithURL:[NSURL URLWithString:self.str0]];
                self.card_z = str.copy;
                
            }
            if ([self.typeStr intValue]==1) {
                self.str1 = [PICHEADURL stringByAppendingString:str];
                UIImageView *img = [self.tableView viewWithTag:202];
                [img sd_setImageWithURL:[NSURL URLWithString:self.str1]];
                self.card_f = str.copy;
            }
            if ([self.typeStr intValue]==2) {
                self.str2 = [PICHEADURL stringByAppendingString:str];
                UIImageView *img = [self.tableView viewWithTag:203];
                [img sd_setImageWithURL:[NSURL URLWithString:self.str2]];
                self.card_hand = str.copy;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {


    }];
}

#pragma mark - TZImagePickerController

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self thumbnaiWithImage:photos andAssets:assets];
}

//上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(imageArray[0], 0.1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"retcode"] intValue]==2000) {
            NSString *str = [responseObject objectForKey:@"data"];

            if ([self.typeStr intValue]==0) {
                self.str0 = [PICHEADURL stringByAppendingString:str];
                UIImageView *img = [self.tableView viewWithTag:201];
                [img sd_setImageWithURL:[NSURL URLWithString:self.str0]];
                self.card_z = str.copy;
                
            }
            if ([self.typeStr intValue]==1) {
                self.str1 = [PICHEADURL stringByAppendingString:str];
                UIImageView *img = [self.tableView viewWithTag:202];
                [img sd_setImageWithURL:[NSURL URLWithString:self.str1]];
                self.card_f = str.copy;
            }
            if ([self.typeStr intValue]==2) {
                self.str2 = [PICHEADURL stringByAppendingString:str];
                UIImageView *img = [self.tableView viewWithTag:203];
                [img sd_setImageWithURL:[NSURL URLWithString:self.str2]];
                self.card_hand = str.copy;
            }
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showMessage:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
