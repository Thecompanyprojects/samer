//
//  LDReportViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDReportViewController.h"
#import "LDReportResonViewController.h"

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


@interface LDReportViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, copy) NSString *path;


@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *extraString;

@property (nonatomic,strong) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *extraLabel;
@property (weak, nonatomic) IBOutlet UILabel *picNumber;

@end

@implementation LDReportViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"举报非法内容";
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _array = [NSMutableArray array];
    
    _pictureArray = [NSMutableArray array];
    
    _selectedPhotos = [NSMutableArray array];
    
    _selectedAssets = [NSMutableArray array];
    
    NSArray *array = @[@"广告骚扰",@"政治敏感",@"散布色情内容",@"涉毒",@"其他原因(请附加说明)"];
    
    [_array addObjectsFromArray:array];
    
    _state = _array[0];
    
    for (int i = 10; i < 15; i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self configCollectionView];
}

-(void)buttonClick:(UIButton *)button{

    for (int i = 10; i < 15; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        if (btn.tag == button.tag) {
            
            UIImageView *img = (UIImageView *)[self.view viewWithTag:btn.tag + 10];
            
            img.image = [UIImage imageNamed:@"举报已选"];
            
            _state = _array[btn.tag - 10];
            
        }else{
        
            UIImageView *img = (UIImageView *)[self.view viewWithTag:i + 10];
            
            img.image = [UIImage imageNamed:@"举报未选"];
            
        }
    }
    
    if (button.tag == 14) {
        
        LDReportResonViewController *rvc = [[LDReportResonViewController alloc] init];
        
        rvc.reason = _extraString;
        
        __weak typeof(self) weakself = self;
        
        rvc.block = ^(NSString *reason){
            
            if (reason.length == 0) {
                
                weakself.extraLabel.text = @"未填写";
                
            }else{
            
                weakself.extraLabel.text = reason;
                
                weakself.extraString = reason;

            }
        
        };
        
        [self.navigationController pushViewController:rvc animated:YES];
    }

}
- (IBAction)exraButtonClick:(id)sender {
    
    LDReportResonViewController *rvc = [[LDReportResonViewController alloc] init];
    
    rvc.reason = _extraString;
    
    __weak typeof(self) weakself = self;
    
    rvc.block = ^(NSString *reason){
        
        if (reason.length == 0) {
            
            weakself.extraLabel.text = @"未填写";
            
        }else{
            
            weakself.extraLabel.text = reason;
            
            weakself.extraString = reason;
        }
        
    };
    
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)picButtonClick:(id)sender {
    
    [self pushImagePickerController];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    //    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (WIDTH - 2 * _margin - 24) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 410, WIDTH - 20, _itemWH + 8) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(6, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.scrollView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    
    self.scrollView.contentSize = CGSizeMake(WIDTH, 468 + _itemWH);
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_selectedPhotos.count == 6) {
        
        return _selectedPhotos.count;
    }
    
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    cell.videoImageView.hidden = YES;
    
    if (indexPath.row == _selectedPhotos.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"添加图片"];
        
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        
        cell.deleteBtn.hidden = YES;
        
    } else {
        
        cell.imageView.image = _selectedPhotos[indexPath.row];
        
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        
        cell.asset = _selectedAssets[indexPath.row];
        
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _selectedPhotos.count) {
        
        BOOL showSheet = YES;
        
        if (showSheet) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
            
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //拍照  调用相机
                [self takePhoto];
                
            }];
            UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
                [self pushImagePickerController];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                
            }];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
            
                [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
                
                [photoAction setValue:MainColor forKey:@"_titleTextColor"];
                
                [cameraAction setValue:MainColor forKey:@"_titleTextColor"];
            }
            
            [alertController addAction:cameraAction];
            [alertController addAction:photoAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.barItemTextColor = TextCOLOR;
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (_selectedAssets.count > 0) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    imagePickerVc.maxImagesCount = 6;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    #pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            return [self takePhoto];
            
        });
    } else { // 调用相机
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.delegate = self;
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.barItemTextColor = TextCOLOR;
        tzImagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        image = [UIImage fixOrientation:image];
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
                        if (/* DISABLES CODE */ (NO)) { // 不允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = NO;
//                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                            
                        } else {
                            
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if(@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [self thumbnaiWithImage:photos andAssets:assets];
}
////上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    
    _selectedPhotos = [NSMutableArray arrayWithArray:imageArray];
    
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    _isSelectOriginalPhoto = YES;
    
    self.picNumber.text = [NSString stringWithFormat:@"%ld/6",(unsigned long)imageArray.count];
    
    [self changeFrame:imageArray];
    
    [_collectionView reloadData];
    
}


-(void)changeFrame:(NSArray *)imageArray{
    
    if (imageArray.count <= 2) {
        
        _collectionView.frame = CGRectMake(10, 410, WIDTH - 20, _itemWH + 6);
        
    }else if(imageArray.count <= 6){
        
        _collectionView.frame = CGRectMake(10, 410, WIDTH - 20, 2 * _itemWH + 6 + _margin);
        
    }
//    self.backView.frame = CGRectMake(0, 187 + _collectionView.frame.size.height, WIDTH, 200);
    
    
    self.scrollView.contentSize = CGSizeMake(WIDTH, 460 + _collectionView.frame.size.height);
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    self.picNumber.text = [NSString stringWithFormat:@"%ld/6",(unsigned long)_selectedPhotos.count];
    
    [self changeFrame:_selectedPhotos];
    
    [_collectionView reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



- (IBAction)submitButtonClick:(id)sender {
    
    [self.pictureArray removeAllObjects];
    
    if (_selectedPhotos.count ==0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请上传截图~"];
        
    }else{
        
        if (_extraString.length == 0) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请添加相关说明~"];
            
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            for (int i = 0; i < _selectedPhotos.count; i++){
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSData *imageData = UIImageJPEGRepresentation(_selectedPhotos[i], 1);
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
                    
                    //NSLog(@"%@",responseObject);
                    
                    [_pictureArray addObject:responseObject[@"data"]];
                    
                    if (_selectedPhotos.count == _pictureArray.count) {
                        
                        for (int i = 0; i < _pictureArray.count; i++) {
                            
                            if (i == 0) {
                                
                                self.path = _pictureArray[0];
                                
                            }else{
                                
                                self.path = [NSString stringWithFormat:@"%@,%@",self.path,_pictureArray[i]];
                                
                            }
                        }
                        
                        
                        [self createData:self.path];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //            NSLog(@"error --- %@",error.description);
                }];

         }
        
      }
        
    }

}


-(void)createData:(NSString *)path{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/report"];
    NSDictionary *parameters;
    
    if ([_state isEqualToString:_array[4]]) {
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":self.reportId,@"state":_state,@"report":_extraString,@"images":path,@"type":@"1"};
        
    }else{
    
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":self.reportId,@"state":_state,@"report":_extraString,@"images":path,@"type":@"0"};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"举报成功"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求失败,请稍后重试~"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
