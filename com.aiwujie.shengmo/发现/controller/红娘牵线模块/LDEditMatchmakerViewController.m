//
//  LDEditMatchmakerViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/12/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDEditMatchmakerViewController.h"
#import "ApplyMatchmakerCell.h"
#import "ApplyMatchMakerModel.h"

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

@interface LDEditMatchmakerViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

//创建选择照片
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

//创建整体的视图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

//存储cell的高度
@property (nonatomic, assign) CGFloat cellH;

//存储cell
@property (nonatomic, strong) ApplyMatchmakerCell *matchmakerCell;

//资料页的数据
@property (nonatomic,strong) NSMutableDictionary *infoDic;

//用于操作的数组
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

//用于进行操作的水印数组
@property (nonatomic, strong) NSMutableArray *selectedSyArray;

//存储缩略图数组及提交资料时上传的字符串
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, copy) NSString *path;

//存储水印图数组及提交资料时上传的字符串
@property (nonatomic, strong) NSMutableArray *shuiyinArray;
@property (nonatomic, copy) NSString *shuiyinPath;

//删除图片时的数组
@property (nonatomic, strong) NSMutableArray *deleteArray;

//删除新添加图片时的数组
@property (nonatomic, strong) NSMutableArray *addArray;

//原来的独白内容
@property (nonatomic, copy) NSString *oldContent;

//修改时是已有资料
@property (nonatomic, assign) BOOL isHaveInfo;

@end

@implementation LDEditMatchmakerViewController


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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectedPhotos = [NSMutableArray array];
    _pictureArray = [NSMutableArray array];
    
    _addArray = [NSMutableArray array];
    _deleteArray = [NSMutableArray array];
    
    _infoDic = [NSMutableDictionary dictionary];
    
    _dataArray = [NSMutableArray arrayWithArray:@[@"个人相册",@"内心独白"]];
    
    [self createTableView];
    
    //获取相册及内心独白信息
    [self getinfoData];
    
    //创建返回按钮
    [self createButton];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect tableFrame = self.tableView.frame;
    
    tableFrame.origin.y = - keyBoardFrame.size.height;
    
    self.tableView.frame = tableFrame;
    
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = 0;
    self.tableView.frame = tableFrame;
}

/**
 * 移除监听
 */
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 获取相册及内心独白信息
 */
-(void)getinfoData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getStep2Info"];
    
    NSDictionary *parameters = @{@"uid":self.userId,@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            if ([responseObj[@"data"][@"match_photo"] count] != 0 && [responseObj[@"data"][@"match_introduce"] length] != 0) {
                
                _isHaveInfo = YES;
                
            }else{
                
                _isHaveInfo = NO;
            }
            
            [self.infoDic setDictionary:responseObj[@"data"]];
            
            //用于进行删除添加图片操作的数组
            [_selectedPhotos addObjectsFromArray:responseObj[@"data"][@"match_photo"]];
            
            //用于对比是否图片更改的原始数组
            [_pictureArray addObjectsFromArray:responseObj[@"data"][@"match_photo"]];
            
            _oldContent = responseObj[@"data"][@"match_introduce"];
            
            [self.tableView reloadData];
            
        }else if (integer == 4002){
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];
            
        }
    } failed:^(NSString *errorMsg) {
         [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接错误,请检查网络设置~"];
    }];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ApplyMatchmakerCell *cell = [[ApplyMatchmakerCell alloc] init];
    
    if (indexPath.section == 0){
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][2];
        
        //创建选择图的CollectionView
        [self configCollectionView:cell];
        
        cell.warnLabel.hidden = NO;
        
        if ([self.infoDic[@"match_photo_lock"] intValue] == 0) {
            
            UIButton *button = (UIButton *)[cell.contentView viewWithTag:20];
            
            button.userInteractionEnabled = NO;
            
            button.selected = YES;
            
        }else if ([self.infoDic[@"match_photo_lock"] intValue] == 1) {
            
            UIButton *button = (UIButton *)[cell.contentView viewWithTag:21];
            
            button.userInteractionEnabled = NO;
            
            button.selected = YES;
            
        }else{
            
            UIButton *button = (UIButton *)[cell.contentView viewWithTag:22];
            
            button.userInteractionEnabled = NO;
            
            button.selected = YES;
        }
        
        for (int i = 20; i < 23; i++) {
            
            UIButton *button = (UIButton *)[cell.contentView viewWithTag:i];
            
            [button addTarget:self action:@selector(showOrHiddenPic:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _cellH = cell.contentView.frame.size.height + cell.picBackView.frame.size.height - 25.5;
        
    }else if (indexPath.section == 1){
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyMatchmakerCell" owner:self options:nil][3];
        
        cell.introduceLabel.text = @"1、自我介绍、斯慕经历、喜恶项目等；2、择友要求：征友地区、年龄、身材、长相、长期短期、结婚意向等。3、请勿使用大尺度文字描述。";
        
        cell.editTextView.text = _oldContent;
        
        if (_oldContent.length == 0) {
            
            cell.introduceLabel.hidden = NO;
            
        }else{
            
            cell.introduceLabel.hidden = YES;
        }
        
        cell.recommendEditButton.hidden = YES;
        
        cell.editTextView.delegate = self;
        
        _matchmakerCell = cell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 * 控制相册的可见权限的开关变化
 */
-(void)showOrHiddenPic:(UIButton *)button{
    
    NSString *url;
    
    if (button.tag == 20) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/setPhotoLock/method/0"];
        
    }else if(button.tag == 21){
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/setPhotoLock/method/1"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/setPhotoLock/method/2"];
    }
    
    NSDictionary *parameters = @{@"uid":self.userId};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            button.selected = !button.selected;
            
            button.userInteractionEnabled = NO;
            
            for (int i = 20; i < 23; i++) {
                
                UIButton *btn = (UIButton *)[button.superview viewWithTag:i];
                
                if (i != button.tag) {
                    
                    btn.selected = NO;
                    
                    btn.userInteractionEnabled = YES;
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"红娘资料编辑成功" object:nil];
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"设置失败~"];
        }
    } failed:^(NSString *errorMsg) {
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接错误,请检查网络设置~"];
    }];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        _matchmakerCell.introduceLabel.hidden = NO;
        
    }else{
        
        _matchmakerCell.introduceLabel.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView) {
        
        [_matchmakerCell.editTextView endEditing:YES];
    }
}

- (void)configCollectionView:(ApplyMatchmakerCell *)cell{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 5;
    _itemWH = (WIDTH - 2 * _margin - 20) / 3;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 20, 2 * _itemWH + _margin) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    //    _collectionView.contentInset = UIEdgeInsetsMake(6, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [cell.picBackView addSubview:_collectionView];
    cell.picBackView.frame = CGRectMake(10, 10, WIDTH - 20, _collectionView.frame.size.height);
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    cell.videoImageView.hidden = YES;
    
    if (_selectedPhotos.count <= indexPath.row) {
        
        cell.imageView.image = [UIImage imageNamed:@"添加图片"];
        
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        
        cell.deleteBtn.hidden = YES;
        
    } else {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_selectedPhotos[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.imageView.clipsToBounds = YES;
        
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectedPhotos.count <= indexPath.row) {
        
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
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
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
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:indexPath.row imagesBlock:^NSArray *{
            
            return weakSelf.selectedPhotos;
        }];
        
    }
    
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
    imagePickerVc.barItemTextColor = TextCOLOR;
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    //    imagePickerVc.cropRect = CGRectMake(0, (HEIGHT - WIDTH)/2, WIDTH, WIDTH);
    
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
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            
                            imagePicker.allowCrop = YES;
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
    
    NSArray *photos = @[image];
    
    [self thumbnaiWithImage:photos andAssets:nil];
    
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

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [self thumbnaiWithImage:photos andAssets:assets];
}
////上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _isSelectOriginalPhoto = NO;
    
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
        
        [_selectedPhotos addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"]]];
        
        [_addArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"]]];
        
        [_collectionView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"error --- %@",error.description);
    }];
    
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_deleteArray addObject:_selectedPhotos[sender.tag]];
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_collectionView reloadData];
}

//点击座机拨打电话
-(void)mobileButtonClick:(UIButton *)button{
    
    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

//点击手机拨打电话
-(void)phoneButtonClick:(UIButton *)button{
    
    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",button.titleLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0){
        
        return _cellH;
        
    }
        
    return 160;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 80;
    }
    
    return 0.00000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, 40)];
    backImageView.image = [UIImage imageNamed:@"红娘文字背景灰"];
    [view addSubview:backImageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, WIDTH - 20, 30)];
    label.text = _dataArray[section];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backImageView.frame) - 200, 10, 200, 30)];
    if (section == 0) {
        
        warnLabel.text = @"1张照片以上";
    }else{
        warnLabel.text = @"30字以上";
    }
    warnLabel.textColor = [UIColor whiteColor];
    warnLabel.textAlignment = NSTextAlignmentRight;
    warnLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:warnLabel];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0 ,0 , WIDTH, 80)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 100 * WIDTHRADIO)/2, 10, 100 * WIDTHRADIO, 43 * WIDTHRADIO)];
        [button setBackgroundImage:[UIImage imageNamed:@"红娘提交按钮"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        
        return view;
    }
    
    return [[UIView alloc] init];
}

-(void)submitButtonClick{
    
    if (_matchmakerCell.editTextView.text.length < 30 || _selectedPhotos.count == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请按提示补全信息后提交~"];
        
    }else{
        
        NSString *path;
        
        if ([[self getPicpathAndSypathWithArray:_pictureArray] isEqualToString:[self getPicpathAndSypathWithArray:_selectedPhotos]]) {
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            path = [self getPicpathAndSypathWithArray:_pictureArray];
            
            [self uploadpic:path];
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            if (_deleteArray.count != 0) {
                
                [self deletePicUrl:_deleteArray[0] andSign:0];
                
            }else{
                
                path = [self getPicpathAndSypathWithArray:_selectedPhotos];
                
                [self uploadpic:path];
            }
        }
    }
}

/**
 * 拼接编辑后的动态图片路径
 */

-(NSString *)getPicpathAndSypathWithArray:(NSMutableArray *)array{
    
    NSString *picPath = [NSString string];
    
    if (array.count == 0) {
        
        picPath = @"";
        
    }else{
        
        if (array.count == 1) {
            
            picPath = [array[0] componentsSeparatedByString:PICHEADURL][1];
            
        }else{
            
            for (int i = 0; i < array.count; i++) {
                
                if (i == 0) {
                    
                    picPath = [array[0] componentsSeparatedByString:PICHEADURL][1];
                    
                }else{
                    
                    picPath = [NSString stringWithFormat:@"%@,%@",picPath,[array[i] componentsSeparatedByString:PICHEADURL][1]];
                }
            }
        }
    }
    
    return picPath;
    
}

/**
 * 删除编辑后的动态图片
 */

-(void)deletePicUrl:(NSString *)filename andSign:(int)i{

    NSDictionary *parameters = @{@"filename":filename};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:delPicture] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            if (i + 1 == _deleteArray.count) {
                
                NSString *path = [self getPicpathAndSypathWithArray:_selectedPhotos];
                
                [self uploadpic:path];
                
            }else{
                
                [self deletePicUrl:_deleteArray[i + 1] andSign:i + 1];
            }
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑失败~"];
        }
    } failed:^(NSString *errorMsg) {
         [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

/**
 * 上传编辑后的动态
 */
-(void)uploadpic:(NSString *)path{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/editStep2Info"];
        
    }else{
        
        if (_isHaveInfo) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/updateStep2Info"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/editStep2Info"];
        }
    }

    NSDictionary *parameters;
    
    NSString *content;
    
    if ([_oldContent isEqualToString:_matchmakerCell.editTextView.text]) {
        
        content = _oldContent;
        
    }else{
        
        content = _matchmakerCell.editTextView.text;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userId,@"match_introduce":content,@"match_photo":path};
        
    }else{
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"match_introduce":content,@"match_photo":path};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑失败~"];
            
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"红娘资料编辑成功" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
}

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)buttonOnClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出编辑?"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if (_addArray.count == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            [self deleteAddPicWith:_addArray[0] andSign:0];
            
        }
        
    }];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [action setValue:MainColor forKey:@"_titleTextColor"];
        
        [setAction setValue:MainColor forKey:@"_titleTextColor"];
        
    }
    
    [alert addAction:action];
    
    [alert addAction:setAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 * 选择图片后不修改图片,删除新上传的图片
 */
-(void)deleteAddPicWith:(NSString *)filename andSign:(int)i{
    
    NSDictionary *parameters = @{@"filename":filename};
    
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:delPicture] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            if (i + 1 == _addArray.count) {
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self deleteAddPicWith:_addArray[i + 1] andSign:i + 1];
            }
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
