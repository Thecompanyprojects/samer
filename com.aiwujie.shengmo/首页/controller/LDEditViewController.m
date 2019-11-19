//
//  LDEditViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDEditViewController.h"
#import "MBProgressHUD.h"
#import "RegisterNextCell.h"
#import "LDIamCell.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZAssetModel.h"
#import "LDPrivacyPhotoViewController.h"
#import "LDAlertNameandIntroduceViewController.h"
#import "EditinfoModel.h"
#import "LDMemberViewController.h"
#import "LDswitchManager.h"

@interface LDEditViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,RegisterNextCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,LDIamCellDelegate,UIImagePickerControllerDelegate>{
    
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

@property (nonatomic, copy) NSString *selectPicType;

//展示图片的view
@property (strong, nonatomic)  UIView *picBackView;
@property (strong, nonatomic)  UIView *backGroundView;
@property (strong, nonatomic)  UIImageView *headImageView;

//tableveiw
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

//存储按钮选择状态
@property (nonatomic,strong) NSMutableArray *selectionArray;
@property (nonatomic,strong) NSMutableArray *sexualArray;

//存储按钮选择状态
@property (nonatomic,strong) NSMutableArray *levelSelectionArray;
@property (nonatomic,strong) NSMutableArray *wantSelectionArray;

//存储选择的多选按钮的值
@property (nonatomic,strong) NSMutableArray *levelArray;
@property (nonatomic,strong) NSMutableArray *wantArray;

//数据源
@property (nonatomic,strong) EditinfoModel *infoModel;

//传给cell的存储信息的数组
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSMutableArray *otherArray;

//身高体重数据数组
@property (nonatomic,strong) NSMutableArray *heightArray;
@property (nonatomic,strong) NSMutableArray *weightArray;

//存储cell
@property (nonatomic,strong) RegisterNextCell *birthdayCell;
@property (nonatomic,strong) RegisterNextCell *cell;

//头像路径、身高、体重、生日、性别、取向、角色、相册
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *weight;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *sexual;
@property (nonatomic,copy) NSString *role;

//存储未修改过的资料
@property (nonatomic,copy) NSString *oldSign;
@property (nonatomic,copy) NSString *oldPhoto;
@property (nonatomic,copy) NSString *oldHeadUrl;
@property (nonatomic,copy) NSString *oldbirthday;
@property (nonatomic,copy) NSString *oldName;

//未更换头像时用户信息提供者头像
@property (nonatomic,copy) NSString *oldUrl;

//生日选择器
@property(nonatomic,strong) UIDatePicker *datePickerView;
@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UIView *dateShadowView;

//身高体重选择器
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *LVShadowView;
@property(nonatomic,strong) UIView *LVView;

//接触时间、经验、程度、想找、学历、月薪
@property (nonatomic,copy) NSString *along;
@property (nonatomic,copy) NSString *experience;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *want;
@property (nonatomic,copy) NSString *culture;
@property (nonatomic,copy) NSString *monthly;

@property (nonatomic,copy) NSString *vipString;
@property (nonatomic,strong) UIButton *picButton;
@property (nonatomic,strong) UIButton * rightButton;

//是否显示图片
@property (nonatomic,assign) BOOL isshowPhoto;
@property (nonatomic,assign) BOOL oldisshowPhoto;

//图片是否改变
@property (nonatomic,assign) BOOL photoisChange;
//头像是否改变
@property (nonatomic,assign) BOOL headImgisChange;

@property (nonatomic,assign) BOOL isBacks;
@end

@implementation LDEditViewController

#define EditChangepost @"EditChangepost" //修改过信息的通知

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
    
    self.navigationItem.title = @"修改资料";
    
    _selectedPhotos = [NSMutableArray array];
    
    _selectedAssets = [NSMutableArray array];
    
    _heightArray = [NSMutableArray array];
    
    _weightArray = [NSMutableArray array];
    
    //性取向
    _selectionArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",nil];
    _sexualArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    //程度
    _levelSelectionArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no", nil];
    _levelArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    //想找
    _wantSelectionArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no", nil];
    _wantArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    _dataArray = @[@[@"昵称"],@[@"我的签名"],@[@"出生日期"],@[@"身高体重"],@[@"性别"],@[@"角色"],@[@"性取向"],@[@"1年以下",@"2-3年",@"4-6年",@"7-10年",@"10-20年",@"20年以上"],@[@"有",@"无"],@[@"轻度",@"中度",@"重度"],@[@"聊天",@"现实",@"结婚"],@[@"高中及以下",@"大专",@"本科",@"双学士",@"硕士",@"博士",@"博士后"],@[@"2千以下",@"2千-5千",@"5千-1万",@"1万-2万",@"2万-5万",@"5万以上"]];
    
    [self getphototIscanlookInfo];
    
    for (int i = 120; i <= 220; i++) {
        
        [_heightArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    for (int j = 30; j <= 200; j++) {
        
        [_weightArray addObject:[NSString stringWithFormat:@"%d",j]];
        
    }
    
    [self judgeVipData];
    
    [self createButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:EditChangepost object:nil];
    
}

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    self.isBacks = YES;
    [self.rightButton setTitle:@"提交" forState:UIControlStateNormal];
}


-(void)judgeVipData{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        _vipString = @"非会员";
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1){
        
        _vipString = @"会员";
    }
    
    [self createEditData];
}

-(void)createEditData{
    
    NSDictionary *parameters = @{@"uid":self.userID};
    
    [NetManager afPostRequest:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/users/getmineinfodetailnew"] parms:parameters finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]!=2000) {
            _rightButton.userInteractionEnabled = NO;
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }
        else
        {
            _rightButton.userInteractionEnabled = YES;
            NSDictionary *dic = responseObj[@"data"];
            self.infoModel = [EditinfoModel new];
            self.infoModel = [EditinfoModel yy_modelWithDictionary:dic];
            
            _array = [NSMutableArray array];
            
            NSArray *array = @[self.infoModel.along,self.infoModel.experience,self.infoModel.level,self.infoModel.level,self.infoModel.culture,self.infoModel.monthly];
            
            _along = self.infoModel.along;
            
            _experience = self.infoModel.experience;
            
            _culture = self.infoModel.culture;
            
            _monthly = self.infoModel.monthly;
            
            [_array addObjectsFromArray:array];
            
            NSArray *levelArray = [self.infoModel.level componentsSeparatedByString:@","];
            
            for (int i = 0; i < levelArray.count; i++) {
                
                if ([levelArray[i] isEqualToString:@"1"]) {
                    
                    [_levelSelectionArray replaceObjectAtIndex:0 withObject:@"yes"];
                    
                    [_levelArray replaceObjectAtIndex:0 withObject:@"1"];
                    
                }else if ([levelArray[i] isEqualToString:@"2"]){
                    
                    [_levelSelectionArray replaceObjectAtIndex:1 withObject:@"yes"];
                    
                    [_levelArray replaceObjectAtIndex:1 withObject:@"2"];
                    
                }else if ([levelArray[i] isEqualToString:@"3"]){
                    
                    [_levelSelectionArray replaceObjectAtIndex:2 withObject:@"yes"];
                    
                    [_levelArray replaceObjectAtIndex:2 withObject:@"3"];
                }
            }
            
            NSArray *wantArray = [self.infoModel.want componentsSeparatedByString:@","];
            
            for (int i = 0; i < wantArray.count; i++) {
                
                if ([wantArray[i] isEqualToString:@"1"]) {
                    
                    [_wantSelectionArray replaceObjectAtIndex:0 withObject:@"yes"];
                    
                    [_wantArray replaceObjectAtIndex:0 withObject:@"1"];
                    
                }else if ([wantArray[i] isEqualToString:@"2"]){
                    
                    [_wantSelectionArray replaceObjectAtIndex:1 withObject:@"yes"];
                    
                    [_wantArray replaceObjectAtIndex:1 withObject:@"2"];
                    
                }else if ([wantArray[i] isEqualToString:@"3"]){
                    
                    [_wantSelectionArray replaceObjectAtIndex:2 withObject:@"yes"];
                    
                    [_wantArray replaceObjectAtIndex:2 withObject:@"3"];
                }
            }
            
            _otherArray = [NSMutableArray array];
            
            if ([self.infoModel.introduce length] == 0) {
                
                self.infoModel.introduce = @"";
                
            }
            
            NSArray *otherArray = @[self.infoModel.nickname,self.infoModel.introduce,self.infoModel.birthday,[NSString stringWithFormat:@"%@cm-%@kg",self.infoModel.tall,self.infoModel.weight],self.infoModel.sex,self.infoModel.role,self.infoModel.sexual];
            
            _oldName = self.infoModel.nickname;
            
            _name = self.infoModel.nickname;
            
            _sign = self.infoModel.introduce;
            
            _oldSign = self.infoModel.introduce;
            
            _oldbirthday = self.infoModel.birthday;
            
            _birthday = self.infoModel.birthday;
            
            _height = self.infoModel.tall;
            
            _weight = self.infoModel.weight;
            
            _sex = self.infoModel.sex;
            
            _role = self.infoModel.role;
            
            NSArray *sexualArray = [self.infoModel.sexual componentsSeparatedByString:@","];
            
            for (int i = 0; i < sexualArray.count; i++) {
                
                if ([sexualArray[i] isEqualToString:@"1"]) {
                    
                    [_selectionArray replaceObjectAtIndex:0 withObject:@"yes"];
                    
                    [_sexualArray replaceObjectAtIndex:0 withObject:@"1"];
                    
                }else if ([sexualArray[i] isEqualToString:@"2"]){
                    
                    [_selectionArray replaceObjectAtIndex:1 withObject:@"yes"];
                    
                    [_sexualArray replaceObjectAtIndex:1 withObject:@"2"];
                    
                }else if ([sexualArray[i] isEqualToString:@"3"]){
                    
                    [_selectionArray replaceObjectAtIndex:2 withObject:@"yes"];
                    
                    [_sexualArray replaceObjectAtIndex:2 withObject:@"3"];
                }
            }
            
            [_otherArray addObjectsFromArray:otherArray];
            
            [_selectedPhotos addObjectsFromArray:responseObj[@"data"][@"photo"]];
            
            if ([responseObj[@"data"][@"photo"] count] == 0) {
                
                _photo = @"";
                
            }else if([responseObj[@"data"][@"photo"] count] == 1){
                
                _photo = responseObj[@"data"][@"photo"][0];
                
            }else{
                
                _photo = responseObj[@"data"][@"photo"][0];
                
                for (int i = 1; i < [responseObj[@"data"][@"photo"] count]; i++) {
                    
                    _photo = [NSString stringWithFormat:@"%@,%@",_photo,responseObj[@"data"][@"photo"][i]];
                }
            }
            _oldPhoto = _photo;
   
            [self createHeadView];
            [self createTableView];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createHeadView{
    
    _margin = 8;
    
    _itemWH = (WIDTH - 4 * _margin) / 3;
    
    if ([_vipString isEqualToString:@"非会员"]) {
        
        if (_selectedPhotos.count == 6) {
            
            self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40+149 + (_selectedPhotos.count/3) * _itemWH + (_selectedPhotos.count/3) * _margin)];
            
        }else{
            
            self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40+149 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin)];
        }
        
    }else{
        
        if (_selectedPhotos.count == 15) {
            
            self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40+149 + (_selectedPhotos.count/3) * _itemWH + (_selectedPhotos.count/3) * _margin)];
            
        }else{
            
            self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40+149 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin)];
        }
    }
    
    self.backGroundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    //创建编辑头像view
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, WIDTH, 100)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    [self.backGroundView addSubview:headView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 86, 17, 60, 60)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.infoModel.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _headImageView.layer.cornerRadius = 30;
    _headImageView.clipsToBounds = YES;
    [headView addSubview:_headImageView];
    
    _oldHeadUrl = self.infoModel.head_pic;
    _oldUrl = self.infoModel.head_pic;
    
    UIImageView *headArrow = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 18, 42, 10, 15)];
    headArrow.image = [UIImage imageNamed:@"youjiantou"];
    [headView addSubview:headArrow];
    
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 133, 40)];
    headLabel.text = @"编辑头像";
    headLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:headLabel];
    
    UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, WIDTH, 100)];
    [headButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headButton];
    
    //创建密码相册view
    
    if ([_vipString isEqualToString:@"非会员"]) {
        
        if (_selectedPhotos.count == 6) {
            
             _picBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3) * _itemWH + (_selectedPhotos.count/3) * _margin)];
            
        }else{
            
             _picBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin)];
        }
        
    }else{
        
        if (_selectedPhotos.count == 15) {
            
             _picBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3) * _itemWH + (_selectedPhotos.count/3) * _margin)];
            
        }else{
            
             _picBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin)];
        }
    }
    
    _picBackView.backgroundColor = [UIColor whiteColor];
    
    [self.backGroundView addSubview:_picBackView];
    
    [self configCollectionView];
    
    UILabel *picLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 40, 40)];
    picLabel.text = @"相册";
    picLabel.font = [UIFont systemFontOfSize:15];
    [_picBackView addSubview:picLabel];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 1, 200, 40)];
    warnLabel.text = @"（请勿上传大尺度图片及调教照）";
    warnLabel.font = [UIFont systemFontOfSize:11];
    warnLabel.textColor = [UIColor lightGrayColor];
    [_picBackView addSubview:warnLabel];
    
    UIImageView *picArrow = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 18, 12, 10, 15)];
    picArrow.image = [UIImage imageNamed:@"youjiantou"];
    [_picBackView addSubview:picArrow];
    
    _picButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 138, 5, 112, 30)];
    _picButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    if ([self.infoModel.photo_lock intValue] == 2) {
        
        [_picButton setTitle:@"未开放" forState:UIControlStateNormal];
        [_picButton setTitle:@"加密" forState:UIControlStateNormal];
        
    }else{
    
        [_picButton setTitle:@"已开放" forState:UIControlStateNormal];
        [_picButton setTitle:@"不加密" forState:UIControlStateNormal];
    }
    
    [_picButton addTarget:self action:@selector(picButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_picButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _picButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_picBackView addSubview:_picButton];
    
    
    UIButton *leftBtn = [UIButton new];
    UIButton *rightBtn = [UIButton new];
    
    [_backGroundView addSubview:leftBtn];
    [_backGroundView addSubview:rightBtn];
    
    //是否展示图片

    leftBtn.frame = CGRectMake(0, self.collectionView.frame.size.height+157, WIDTH/2, 20);
    rightBtn.frame = CGRectMake(WIDTH/2, self.collectionView.frame.size.height+157, WIDTH/2, 20);
    
    if (self.isshowPhoto) {
        [leftBtn setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
        [rightBtn setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    }
    else
    {
        [rightBtn setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
        [leftBtn setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    }
    
    [leftBtn setTitle:@"所有人可见" forState:normal];
    [rightBtn setTitle:@"好友/会员可见" forState:normal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:normal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:normal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [leftBtn addTarget:self action:@selector(chooseshowphotoLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(chooseshowphotoRightClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [rightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    leftBtn.tag = 101;
    rightBtn.tag = 102;
}

#pragma mark - 图片是否显示

-(void)chooseshowphotoLeftClick
{
    if (self.isshowPhoto) {
        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    self.isshowPhoto = NO;

    UIButton *btn0 = [self.tableView viewWithTag:101];
    UIButton *btn1 = [self.tableView viewWithTag:102];
    [btn0 setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    [btn1 setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
    
    [self.tableView reloadData];
}

-(void)chooseshowphotoRightClick
{
    if (!self.isshowPhoto) {
        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    self.isshowPhoto = YES;
    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    UIButton *btn0 = [self.tableView viewWithTag:101];
    UIButton *btn1 = [self.tableView viewWithTag:102];
    [btn1 setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
    [btn0 setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
    [self.tableView reloadData];
}

-(void)picButtonClick{

    if ([_vipString isEqualToString:@"非会员"]) {
        
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您现在还不是会员,不能设置相册密码~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [control addAction:action1];
        [control addAction:action0];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }else{
        
        LDPrivacyPhotoViewController *ppvc = [[LDPrivacyPhotoViewController alloc] init];
        
        ppvc.privacyString = self.infoModel.photo_lock;
        
        ppvc.type = @"1";
        
        ppvc.block = ^(NSString *string){
        
            if ([string intValue] == 1) {

                [_picButton setTitle:@"已开放" forState:UIControlStateNormal];
                [_picButton setTitle:@"不加密" forState:UIControlStateNormal];
                self.infoModel.photo_lock = @"1";
            }else{
                [_picButton setTitle:@"未开放" forState:UIControlStateNormal];
                [_picButton setTitle:@"加密" forState:UIControlStateNormal];
                self.infoModel.photo_lock = @"2";
            }
        
        };

        [self.navigationController pushViewController:ppvc animated:YES];
        
    }
}

-(void)headButtonClick{
    
    _selectPicType = @"1";

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //拍照  调用相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
//        picker.delegate=self;
//        picker.allowsEditing = YES;
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController:picker animated:YES completion:nil];//显示出来
        [self pushImagePickerController];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark  imagePicker的代理方法

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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.backGroundView;
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section <= 6) {
        
        RegisterNextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterNext"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"RegisterNextCell" owner:self options:nil][0];
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        cell.delegate = self;
        
        [cell editAddoptionWithArray:_dataArray andIndexpath:indexPath andOtherArray:_otherArray andSelectionArray:_selectionArray];
        
        if (indexPath.section == 4) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
                
                cell.contentView.userInteractionEnabled = YES;
                
            }else{
            
                cell.contentView.userInteractionEnabled = NO;
            }

            if (WIDTH == 320) {
                
                cell.warnLabel.font = [UIFont systemFontOfSize:8];
                
            }else{
            
                cell.warnLabel.font = [UIFont systemFontOfSize:11];
            }
            
            cell.warnLabel.text = @"(如需修改请认证后联系客服)";

            cell.warnLabel.hidden = NO;
            
        }else if (indexPath.section == 6) {
            
            if (WIDTH == 320) {
                
                cell.warnLabel.font = [UIFont systemFontOfSize:8];
                
            }else{
                
                cell.warnLabel.font = [UIFont systemFontOfSize:11];
            }
            
            cell.warnLabel.text = @"(可多选)";
            
            cell.warnLabel.hidden = NO;
            
        }else{
            
            cell.warnLabel.hidden = YES;
        }
        
        return cell;

    }
    
    LDIamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDIam"];
    
    if ([_dataArray[indexPath.section] count] >= 5) {
            
        if (!cell) {
                
            cell = [[NSBundle mainBundle] loadNibNamed:@"LDIamCell" owner:self options:nil][1];
        }
            
        [cell editOptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_array andSelectionArray:nil];
            
    }else{
            
        if (!cell) {
                
            cell = [[NSBundle mainBundle] loadNibNamed:@"LDIamCell" owner:self options:nil][0];
        }
            
        if (indexPath.section - 7 == 2) {
            
            [cell editOptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_levelArray andSelectionArray:_levelSelectionArray];
            
        }else if(indexPath.section - 7 == 3){
            
            [cell editOptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_wantArray andSelectionArray:_wantSelectionArray];
            
        }else{
            
            [cell editOptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_array andSelectionArray:nil];
        }

        
    }
    
    cell.delegate = self;
    
    return cell;
    
}

//cell上的多选按钮点击事件
-(void)buttonClickOnCell:(UIButton *)button changeSelection:(NSMutableArray *)selectionArray{
    
    [self.view endEditing:YES];

    
    if (button.tag < 1000){
        //性取向  多选
        _selectionArray = selectionArray;
        
        if ([_selectionArray[button.tag%100] isEqualToString:@"yes"]) {
            
            [button setBackgroundColor:TextCOLOR];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_sexualArray replaceObjectAtIndex:button.tag%100 withObject:[NSString stringWithFormat:@"%ld",button.tag%100 + 1]];
            
            
            button.layer.borderWidth = 0;
            
        }else{
            
            [_sexualArray replaceObjectAtIndex:button.tag%100 withObject:@""];
            
            [button setBackgroundColor:[UIColor whiteColor]];
            
            [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
            
            button.layer.borderWidth = 1;
        }
        
        NSString *newsexual = [self.sexualArray componentsJoinedByString:@","];
        if (![newsexual isEqualToString:self.infoModel.sexual]) {
            NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
    }else{
    
        if (button.tag/1000 - 7 == 2) {
            //程度  轻度-中度-重度
            _levelSelectionArray = selectionArray;
            
        }else if (button.tag/1000 - 7 == 3){
            //我想找 聊天-现实-结婚
            _wantSelectionArray = selectionArray;
        }
        
        if ([selectionArray[button.tag%1000] isEqualToString:@"yes"]) {
            
            [button setBackgroundColor:TextCOLOR];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if (button.tag/1000 - 7 == 2){
                
                [_levelArray replaceObjectAtIndex:button.tag%1000 withObject:_dataArray[button.tag/1000][button.tag%1000]];
                
            }else if (button.tag/1000 - 7 == 3){
                
                [_wantArray replaceObjectAtIndex:button.tag%1000  withObject:_dataArray[button.tag/1000][button.tag%1000]];
                
            }
            
            button.layer.borderWidth = 0;
            
        }else{
            
            if (button.tag/1000 - 7 == 2) {
                
                [_levelArray replaceObjectAtIndex:button.tag%1000 withObject:@""];
                
            }else if (button.tag/1000 - 7 == 3){
                
                [_wantArray replaceObjectAtIndex:button.tag%1000 withObject:@""];
            }
            
            [button setBackgroundColor:[UIColor whiteColor]];
            
            [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
            
            button.layer.borderWidth = 1;
        }
        
        NSString *newwant = [self.wantArray componentsJoinedByString:@","];
        if (![newwant isEqualToString:self.infoModel.want]) {
            NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        NSString *newlevel = [self.levelArray componentsJoinedByString:@","];
        if (![newlevel isEqualToString:self.infoModel.level]) {
            NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
    }
    
    
}


//cell上的按钮点击事件
-(void)buttonClickOnCell:(UIButton *)button{
    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if (button.tag < 1000) {
        
        RegisterNextCell *cell = (RegisterNextCell *)button.superview.superview;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 && button.tag/100 - 1 == 4) {
            
            for (int i = 0; i < 3;  i++) {
                
                UIButton *btn = (UIButton *)[cell.contentView viewWithTag:button.tag/100 * 100 + i];
                
                if (button.tag == btn.tag) {
                    
                    [button setBackgroundColor:TextCOLOR];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             
                 
                    if (button.tag%100 == 0) {
                        
                        _sex = @"1";
                        
                    }else if (button.tag%100 == 1){
                        
                        _sex = @"2";
                        
                    }else if (button.tag%100 == 2){
                        
                        _sex = @"3";
                    }

                
                    [_otherArray replaceObjectAtIndex:4 withObject:_sex];
                    
                    if (![self.sex isEqualToString:self.infoModel.sex]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    
                    button.layer.borderWidth = 0;
                    
                }else{
                    
                    [btn setBackgroundColor:[UIColor whiteColor]];
                    
                    [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    btn.layer.borderWidth = 1;
                }
            }
            
        }else{
        
            for (int i = 0; i < 4;  i++) {
                
                UIButton *btn = (UIButton *)[cell.contentView viewWithTag:button.tag/100 * 100 + i];
                
                if (button.tag == btn.tag) {
                    
                    [button setBackgroundColor:TextCOLOR];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    if (button.tag/100 - 1 == 5) {
                        
                        if (button.tag%100 == 0) {
                            
                            _role = @"S";
                            
                        }else if (button.tag%100 == 1){
                            
                            _role = @"M";
                            
                        }else if (button.tag%100 == 2){
                            
                            _role = @"SM";
                            
                        }else if (button.tag%100 == 3){
                            
                            _role = @"~";
                        }
                    }
                    
                    [_otherArray replaceObjectAtIndex:5 withObject:_role];
                    
                    if (![self.role isEqualToString:self.infoModel.role]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    
                    button.layer.borderWidth = 0;
                    
                }else{
                    
                    [btn setBackgroundColor:[UIColor whiteColor]];
                    
                    [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    btn.layer.borderWidth = 1;
                }
            }

        }
    }else{
    
        LDIamCell *cell = (LDIamCell *)button.superview.superview;
        
        for (UIButton *btn in cell.contentView.subviews) {
            
            if (button.tag == btn.tag) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if (button.tag/1000 == 7) {
                    
                    _along = [NSString stringWithFormat:@"%ld",button.tag%1000 + 1];
                    
                    [_array replaceObjectAtIndex:button.tag/1000 - 7 withObject:_dataArray[button.tag/1000][button.tag%1000]];
                    
                    if (![self.along isEqualToString:self.infoModel.along]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    
                    
                }else if (button.tag/1000 == 8){
                    
                    _experience = [NSString stringWithFormat:@"%ld",button.tag%1000 + 1];
                    
                    [_array replaceObjectAtIndex:button.tag/1000 - 7 withObject:_dataArray[button.tag/1000][button.tag%1000]];
                    
                    if (![self.experience isEqualToString:self.infoModel.experience]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    
                }else if (button.tag/1000 == 11){
                    
                    _culture = [NSString stringWithFormat:@"%ld",button.tag%1000 + 1];
                    
                    [_array replaceObjectAtIndex:button.tag/1000 - 7 withObject:_dataArray[button.tag/1000][button.tag%1000]];
                    
                    if (![self.culture isEqualToString:self.infoModel.culture]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    
                }else if (button.tag/1000 == 12){
                    
                    _monthly = [NSString stringWithFormat:@"%ld",button.tag%1000 + 1];
                    
                    [_array replaceObjectAtIndex:button.tag/1000 - 7 withObject:_dataArray[button.tag/1000][button.tag%1000]];
                    
                    if (![self.monthly isEqualToString:self.infoModel.monthly]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    
                }
                
                button.layer.borderWidth = 0;
                
            }else{
                
                
                [btn setBackgroundColor:[UIColor whiteColor]];
                
                [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                btn.layer.borderWidth = 1;
                
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] integerValue] == 1) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            LDAlertNameandIntroduceViewController *nvc = [[LDAlertNameandIntroduceViewController alloc] init];
            
            nvc.content = _otherArray[0];
            
            nvc.type = @"1";
            
            nvc.block = ^(NSString *content){
                
                if (content.length == 0) {
                    
                    _name = @"";
                    
                }else{
                    
                    _name = content;
                    if (![content isEqualToString:self.infoModel.nickname]) {
                        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                 
                }
                
                [_otherArray replaceObjectAtIndex:0 withObject:_name];
                
                [self.tableView reloadData];
            };
            
            [self.navigationController pushViewController:nvc animated:YES];

        }else{
        
            if ([self.infoModel.changeState intValue] == 1) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您的本月修改昵称次数已达上限（修改昵称次数/月：普通用户1次,会员2次"];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                LDAlertNameandIntroduceViewController *nvc = [[LDAlertNameandIntroduceViewController alloc] init];
                
                nvc.content = _otherArray[0];
                
                nvc.type = @"1";
                
                nvc.block = ^(NSString *content){
                    
                    if (content.length == 0) {
                        
                        _name = @"";
                        
                    }else{
                        
                        _name = content;
                        
                        if (![content isEqualToString:self.infoModel.nickname]) {
                            NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                        
                    }
                    
                    [_otherArray replaceObjectAtIndex:0 withObject:_name];
                    
                    [self.tableView reloadData];
                };
                
                [self.navigationController pushViewController:nvc animated:YES];
                
            }

        }
        
    }else if (indexPath.section == 1){
    
        LDAlertNameandIntroduceViewController *nvc = [[LDAlertNameandIntroduceViewController alloc] init];
        
        nvc.content = _otherArray[1];
        
        nvc.type = @"2";
        
        nvc.block = ^(NSString *content){
            
            if (content.length == 0) {
                
                _sign = @"";
                
            }else{
                
                 _sign = content;
                if (![content isEqualToString:self.infoModel.introduce]) {
                    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }
            
            [_otherArray replaceObjectAtIndex:1 withObject:_sign];
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:nvc animated:YES];
    
    }else if (indexPath.section == 2) {
        
        self.dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        self.dateView.backgroundColor = [UIColor clearColor];
        
        [self.navigationController.view addSubview:self.dateView];
        
#pragma mark - 时间datePicker
        self.datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, HEIGHT - 216, WIDTH, 216)];
        self.datePickerView.backgroundColor = [UIColor whiteColor];
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        self.datePickerView.minuteInterval = 10;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        // 设置时区，中国在东八区
        self.datePickerView.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
        self.datePickerView.locale = locale;
        NSDate * date1 = [NSDate dateWithTimeIntervalSinceNow: -18 * 365 * 24 * 60 * 60 - 5 * 24 * 60 * 60];
        
        [self.datePickerView setDate:[NSDate dateWithTimeIntervalSinceNow:-27 * 365 * 24 * 60 * 60] animated:YES];
        
        self.datePickerView.maximumDate = date1;
        
        [self.dateView addSubview:self.datePickerView];
        
        UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, HEIGHT - 216 - 40, WIDTH, 40)];
        toolBar1.barStyle = UIBarButtonItemStylePlain;
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
        item1.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonOnClick1)];
        item2.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"请选择" style:UIBarButtonItemStylePlain target:self action:nil];
        item3.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *flexible1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [toolBar1 setItems:@[item1, flexible1, item3, flexible2 ,item2]];
        
        
        toolBar1.barTintColor = TextCOLOR;
        
        [self.dateView addSubview:toolBar1];
        
        self.dateShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 256)];
        self.dateShadowView.backgroundColor = [UIColor lightGrayColor];
        self.dateShadowView.alpha = 0.5;
        [self.dateView addSubview:self.dateShadowView];
        
        UITapGestureRecognizer *singletap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonClick)];
        [singletap1 setNumberOfTapsRequired:1];
        [self.dateShadowView addGestureRecognizer:singletap1];
        
        _birthdayCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
    }else if(indexPath.section == 3){
        
        self.LVView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        //self.LVView.alpha = 0;
        self.LVView.backgroundColor = [UIColor clearColor];
        [self.navigationController.view addSubview:self.LVView];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT - 216, WIDTH, 216)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0;i < _heightArray.count; i++) {
            
            if ([_heightArray[i] intValue] == [_height intValue]) {
                
                [self.pickerView selectRow:i inComponent:0 animated:YES];
            }
        }
        
        for (int i = 0;i < _weightArray.count; i++) {
            
            if ([_weightArray[i] intValue] == [_weight intValue]) {
                
                [self.pickerView selectRow:i inComponent:2 animated:YES];
            }
        }
        
        [self.LVView addSubview:self.pickerView];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, HEIGHT - 216 - 40, WIDTH, 40)];
        toolBar.barStyle = UIBarButtonItemStylePlain;
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
        item1.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonOnClick)];
        item2.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"请选择" style:UIBarButtonItemStylePlain target:self action:nil];
        item3.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *flexible1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [toolBar setItems:@[item1, flexible1, item3, flexible2 ,item2]];
        
        toolBar.barTintColor = TextCOLOR;
        
        [self.LVView addSubview:toolBar];
        
        self.LVShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 256)];
        self.LVShadowView.backgroundColor = [UIColor lightGrayColor];
        self.LVShadowView.alpha = 0.5;
        [self.LVView addSubview:self.LVShadowView];
        
        UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonClick)];
        [singletap setNumberOfTapsRequired:1];
        [self.LVShadowView addGestureRecognizer:singletap];
        
        _cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
    }
    
}

#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 50.0;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (component == 0) {
        
        return _heightArray.count;
        
    }else if (component == 1){
        
        NSArray * array = @[@"cm"];
        
        return array.count;
        
    }else if (component == 2){
        
        return _weightArray.count;
        
    }
    
    NSArray * array = @[@"kg"];
    
    return array.count;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, WIDTH / 4 - 20 , 50)];
    
    titleLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 4, 50)];
    
    unitLabel.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        
        titleLabel.text = _heightArray[row];
        
        return titleLabel;
        
    }else if (component == 1){
        
        unitLabel.text = @"cm";
        
        return unitLabel;
        
    }else if(component == 2){
        

        titleLabel.text = _weightArray[row];
        
        return titleLabel;
        
    }
    
    unitLabel.text = @"kg";
    
    return unitLabel;
    
    
}
#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        _height = _heightArray[row];
        
    }else if (component == 2){
        
        _weight = _weightArray[row];
    }
    
}

- (void)cancleButtonClick {
    
    [self.dateView removeFromSuperview];
    
    [self.LVView removeFromSuperview];
}

-(void)sureButtonOnClick{
    
    _cell.showLabel.text = [NSString stringWithFormat:@"%@cm-%@kg",_height,_weight];
    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.LVView removeFromSuperview];
}

- (void)sureButtonOnClick1 {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _birthday = [dateFormatter stringFromDate:self.datePickerView.date];
    
    _birthdayCell.showLabel.text = _birthday;
    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.dateView removeFromSuperview];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section >= 7) {
        
        return 30;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= 7) {
        if ([_dataArray[indexPath.section] count] >= 5) {
            if (indexPath.section==7)
            {
                return 95;
            }
            else
            {
                return 130;
            }
        }
        else{
            return 50;
        }
    }
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section >= 7) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        
        view.backgroundColor = [UIColor clearColor];
        
        NSArray *titleArray = @[@"接触多久",@"是否实践过",@"程度",@"我想找",@"我的学历",@"我的月薪",@"自我介绍/择偶要求等"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, WIDTH/2, 25)];
        
        label.text = titleArray[section - 7];
        
        label.font = [UIFont systemFontOfSize:15];
        
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        
        [view addSubview:label];
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 , 5, WIDTH/2 - 30, 25)];
        
        if (section == 9 || section == 10) {
            
            hintLabel.text = @"可多选";
            
        }else{
        
            hintLabel.text = @"单选";
        }
        
        hintLabel.textAlignment = NSTextAlignmentRight;
        
        hintLabel.font = [UIFont systemFontOfSize:14];
        
        hintLabel.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
        
        [view addSubview:hintLabel];
        
        
        return view;

    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    
    layout.minimumInteritemSpacing = _margin;
    
    layout.minimumLineSpacing = _margin;
    
    if ([_vipString isEqualToString:@"非会员"]) {
        
        if (_selectedPhotos.count == 6) {
            
             _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3) * _itemWH + (_selectedPhotos.count/3) * _margin + 5) collectionViewLayout:layout];
            
        }else{
        
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin + 5) collectionViewLayout:layout];
        }
        
    }else{
    
        if (_selectedPhotos.count == 15) {
            
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3) * _itemWH + (_selectedPhotos.count/3) * _margin + 5) collectionViewLayout:layout];
            
        }else{
            
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin + 5) collectionViewLayout:layout];
        }
    }

    _collectionView.alwaysBounceVertical = YES;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.picBackView addSubview:_collectionView];
    
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if ([_vipString isEqualToString:@"非会员"]) {
        
        if (_selectedPhotos.count == 6) {
            
            return _selectedPhotos.count;
        }
        
        return _selectedPhotos.count + 1;
    }
    
    if (_selectedPhotos.count == 15) {
        
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
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,_selectedPhotos[indexPath.row]]]];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.imageView.clipsToBounds = YES;
        
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectPicType = @"2";
    
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

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [self thumbnaiWithImage:_selectedPhotos andAssets:_selectedAssets];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
    imagePickerVc.barItemTextColor = TextCOLOR;
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;

    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    
    imagePickerVc.cropRect = CGRectMake(0, (HEIGHT - WIDTH)/2, WIDTH, WIDTH);
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
    
    if ([_selectPicType intValue] == 1) {
        
        UIImage *img = info[@"UIImagePickerControllerEditedImage"];
        
        if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
        }
        
        _headImageView.image = img;

        NSData *imageData = UIImageJPEGRepresentation(img, 0.1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        self.headImgisChange = YES;
        [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            _headUrl = responseObject[@"data"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([type isEqualToString:@"public.image"]) {
            
            TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            tzImagePickerVc.barItemTextColor = TextCOLOR;
            tzImagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
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
 
         [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    NSArray *photos = @[image];
    [self thumbnaiWithImage:photos andAssets:nil];
    [_collectionView reloadData];
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

// User click cancel button
// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if ([self.selectPicType intValue]==1) {
        _headImageView.image = [photos firstObject];
        
        NSData *imageData = UIImageJPEGRepresentation([photos firstObject], 0.1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        self.headImgisChange = YES;
        [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _headUrl = responseObject[@"data"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self thumbnaiWithImage:photos andAssets:assets];
    }
    
}

//上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _isSelectOriginalPhoto = NO;
    self.photoisChange = YES;
    
    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
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

        [_selectedPhotos addObject:responseObject[@"data"]];
        
        if ([_vipString isEqualToString:@"非会员"]) {
            
            if (_selectedPhotos.count < 6) {
                
                self.backGroundView.frame = CGRectMake(0, 0, WIDTH, 149+40 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin);
                _picBackView.frame = CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin);
                _collectionView.frame = CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin + 5);
                [self.tableView setTableHeaderView:self.backGroundView];
            }
            
        }else{
            
            if (_selectedPhotos.count < 15) {
                self.backGroundView.frame = CGRectMake(0, 0, WIDTH, 149+40 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin);
                _picBackView.frame = CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin);
                _collectionView.frame = CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin + 5);
                [self.tableView setTableHeaderView:self.backGroundView];
            }
        }
        [_collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];
    
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    [_selectedAssets addObject:_selectedPhotos[sender.tag]];
    self.photoisChange = YES;
    NSNotification *notification = [NSNotification notificationWithName:EditChangepost object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    
    self.backGroundView.frame = CGRectMake(0, 0, WIDTH, 189 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin);
    _picBackView.frame = CGRectMake(0, 104, WIDTH, 45 + (_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin);
    _collectionView.frame = CGRectMake(0, 40, WIDTH,(_selectedPhotos.count/3 + 1) * _itemWH + (_selectedPhotos.count/3 + 1) * _margin + 5);
    [self.tableView setTableHeaderView:self.backGroundView];
    [_collectionView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma clang diagnostic pop

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [_rightButton setTitle:@"" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton addTarget:self action:@selector(commitButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

#pragma mark - 返回按钮方法

-(void)backButtonOnClick{

    if (!self.isBacks) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:@"修改的内容未提交哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:nil];
    }
    
}

-(void)finishingArrayClick
{
    NSMutableArray *sexualArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _sexualArray.count; i++) {
        if ([_sexualArray[i] intValue] == 1 || [_sexualArray[i] intValue] == 2 || [_sexualArray[i] intValue] == 3) {
            [sexualArray addObject:_sexualArray[i]];
        }
    }
    if (sexualArray.count == 1) {
        _sexual = sexualArray[0];
    }else if (sexualArray.count == 2){
        _sexual = [NSString stringWithFormat:@"%@,%@",sexualArray[0],sexualArray[1]];
        
    }else if(sexualArray.count == 3){
        _sexual = [NSString stringWithFormat:@"%@,%@,%@",sexualArray[0],sexualArray[1],sexualArray[2]];
    }else{
        _sexual = @"";
    }
    NSMutableArray *levelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _levelArray.count; i++) {
        if ([_levelArray[i] length] != 0) {
            [_levelArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", i + 1]];
        }
    }
    for (int i = 0; i < _levelArray.count; i++) {
        if ([_levelArray[i] intValue] == 1 || [_levelArray[i] intValue] == 2 || [_levelArray[i] intValue] == 3) {
            [levelArray addObject:_levelArray[i]];
        }
    }
    if (levelArray.count == 1) {
        _level = levelArray[0];
        
    }else if (levelArray.count == 2){
        
        _level = [NSString stringWithFormat:@"%@,%@",levelArray[0],levelArray[1]];
        
    }else if(levelArray.count == 3){
        
        _level = [NSString stringWithFormat:@"%@,%@,%@",levelArray[0],levelArray[1],levelArray[2]];
        
    }else{
        
        _level = @"";
    }
    NSMutableArray *wantArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _wantArray.count; i++) {
        
        if ([_wantArray[i] length] != 0) {
            
            [_wantArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", i + 1]];
        }
    }
    for (int i = 0; i < _wantArray.count; i++) {
        if ([_wantArray[i] intValue] == 1 || [_wantArray[i] intValue] == 2 || [_wantArray[i] intValue] == 3) {
            [wantArray addObject:_wantArray[i]];
        }
    }
    if (wantArray.count == 1) {
        
        _want = wantArray[0];
        
    }else if (wantArray.count == 2){
        
        _want = [NSString stringWithFormat:@"%@,%@",wantArray[0],wantArray[1]];
        
    }else if(wantArray.count == 3){
        
        _want = [NSString stringWithFormat:@"%@,%@,%@",wantArray[0],wantArray[1],wantArray[2]];
        
    }else{
        
        _want = @"";
    }

}

#pragma mark - 提交数据

-(void)commitButtonOnClick{
    
    NSString *photo_charge_time;

    [self finishingArrayClick];
    
    if (_want.length == 0 || _level.length == 0 || _sexual.length == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"性取向或想找或程度必须选择,请选择后提交~"];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([_selectedPhotos count] == 0) {
            
            _photo = @"";
            
        }else if([_selectedPhotos count] == 1){
            
            _photo = _selectedPhotos[0];
            
        }else{
            
            _photo = _selectedPhotos[0];
            
            for (int i = 1; i < [_selectedPhotos count]; i++) {
                
                _photo = [NSString stringWithFormat:@"%@,%@",_photo,_selectedPhotos[i]];
                
            }
        }
        
        if ([_birthday isEqualToString:_oldbirthday]) {
            
            _birthday = @"";
        }
        
        if ([_oldPhoto isEqualToString:_photo]) {
            
            photo_charge_time = @"";
            
        }else{
            
            photo_charge_time = @"1";
        }
        
        if ([_oldSign isEqualToString:_sign]) {
            
            _sign = @"";
            
        }
        
        if ([_oldName isEqualToString:_name]) {
            
            _name = @"";
            
        }
        
        NSString *deleStr;
        
        if ([_selectedAssets count] == 0) {
            
            deleStr = @"";
            
        }else if([_selectedAssets count] == 1){
            
            deleStr = _selectedAssets[0];
            
            [self deletePicUrl:deleStr];
            
        }else{
            
            deleStr = _selectedAssets[0];
            
            for (int i = 1; i < [_selectedAssets count]; i++) {
                
                deleStr = [NSString stringWithFormat:@"%@,%@",deleStr,_selectedAssets[i]];
                
            }
            
            [self deletePicUrl:deleStr];
        }
        
        if (_headUrl.length == 0) {
            
            _oldHeadUrl = @"";
            
        }else{
            
            [self deletePicUrl:_oldHeadUrl];
            
            _oldHeadUrl = _headUrl;
            
        }
        
        NSString *photo_rule = [NSString new];
        if (!self.isshowPhoto) {
            photo_rule = @"0";
        }
        else
        {
            photo_rule = @"1";
        }
        
        NSDictionary *parameters = @{@"uid":self.userID,@"head_pic":self.oldHeadUrl,@"nickname":self.name,@"introduce":self.sign,@"birthday":self.birthday,@"tall":self.height,@"weight":self.weight,@"sex":self.sex,@"role":self.role,@"sexual":self.sexual,@"along":self.along,@"experience":self.experience,@"level":self.level,@"want":self.want,@"culture":self.culture,@"monthly":self.monthly,@"photo":self.photo,@"photo_charge_time":photo_charge_time,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"photo_rule":photo_rule};

        if (self.name.length==0) {
             [[LDswitchManager sharedClient] updateDataWithuserId:self.userID andnickname:self.infoModel.nickname];
        }
        else
        {
             [[LDswitchManager sharedClient] updateDataWithuserId:self.userID andnickname:self.name];
        }
        if (self.oldHeadUrl.length==0) {
             [[LDswitchManager sharedClient] updateDataWithuserId:self.userID andimageUrl:self.infoModel.head_pic];
        }
        else
        {
             [[LDswitchManager sharedClient] updateDataWithuserId:self.userID andimageUrl:[NSString stringWithFormat:@"%@%@",PICHEADURL,self.oldHeadUrl]];
        }
       
        [NetManager afPostRequest:[PICHEADURL stringByAppendingString:editInfo] parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"修改了个人资料" object:nil];
                
                if (self.InActionType==ENUM_FROMUSER_ActionType) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_sex forKey:@"newestSex"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_sexual forKey:@"newestSexual"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] forKey:@"sexButton"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] forKey:@"sexualButton"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] forKey:@"dynamicSex"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] forKey:@"dynamicSexual"];
                    
                    if (_name.length == 0 && _oldHeadUrl.length == 0) {
                        
                        //设置当前用户信息
                        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] name:_oldName portrait:_oldUrl];
                        
                    }else if(_name.length == 0 && _oldHeadUrl.length != 0){
                        
                        //设置当前用户信息
                        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] name:_oldName portrait:[NSString stringWithFormat:@"%@%@",PICHEADURL,_headUrl]];
                        
                    }else if (_name.length != 0 && _oldHeadUrl.length == 0){
                        
                        //设置当前用户信息
                        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] name:_name portrait:_oldUrl];
                        
                    }else{
                        
                        //设置当前用户信息
                        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] name:_name portrait:[NSString stringWithFormat:@"%@%@",PICHEADURL,_headUrl]];
                    }
                    
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failed:^(NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改信息失败,请稍后重试"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }];

    }
}

-(void)deletePicUrl:(NSString *)filename{

    NSDictionary *parameters = @{@"filename":filename};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:delPicture] parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            NSLog(@"删除成功");
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}


#pragma mark - 照片是否被推荐

-(void)getphototIscanlookInfo
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSecretSitUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
      
       NSString *photo_rule = responseObj[@"data"][@"photo_rule"];
        if ([photo_rule isEqualToString:@"0"]) {
            self.isshowPhoto = NO;
            self.oldisshowPhoto = NO;
        }
        else
        {
            self.isshowPhoto = YES;
            self.oldisshowPhoto = YES;
        }
        
        UIButton *btn0 = [self.tableView viewWithTag:101];
        UIButton *btn1 = [self.tableView viewWithTag:102];
        
        if (self.isshowPhoto) {
            [btn0 setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
            [btn1 setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
        }
        else
        {
            [btn1 setImage:[UIImage imageNamed:@"照片认证空圈"] forState:normal];
            [btn0 setImage:[UIImage imageNamed:@"照片认证实圈"] forState:normal];
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditChangepost object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
