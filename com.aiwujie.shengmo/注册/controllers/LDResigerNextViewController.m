//
//  LDResigerNextViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDResigerNextViewController.h"
#import "RegisterNextCell.h"
#import "LDIAmViewController.h"

@interface LDResigerNextViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RegisterNextCellDelegate,UITextFieldDelegate>

//上方透视图
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *pickView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

//tableView
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

//存储按钮选择状态
@property (nonatomic,strong) NSMutableArray *selectionArray;
@property (nonatomic,strong) NSMutableArray *sexualArray;

//下一步按钮
@property (nonatomic,strong) UIButton *nextButton;

//身高,体重数据数组
@property (nonatomic,strong) NSMutableArray *heightArray;
@property (nonatomic,strong) NSMutableArray *weightArray;

//存储cell
@property (nonatomic,strong) RegisterNextCell *birthdayCell;
@property (nonatomic,strong) RegisterNextCell *cell;

//上传至接口的数据
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *weight;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *sexual;
@property (nonatomic,copy) NSString *role;

//生日选择器
@property(nonatomic,strong) UIDatePicker *datePickerView;
@property(nonatomic,strong) UIView *dateView;
@property(nonatomic,strong) UIView *dateShadowView;

//身高体重选择器
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *LVShadowView;
@property(nonatomic,strong) UIView *LVView;

@end

@implementation LDResigerNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    
    _heightArray = [NSMutableArray array];
    
    _weightArray = [NSMutableArray array];
    
    _selectionArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",nil];
    
    _sexualArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    self.headButton.layer.cornerRadius = 41;
    self.headButton.clipsToBounds = YES;
    
    self.nameView.layer.cornerRadius = 2;
    self.nameView.clipsToBounds = YES;
    
    _dataArray = @[@"性别",@"出生日期",@"身高体重",@"角色",@"性取向"];
    
    for (int i = 120; i <= 220; i++) {

        [_heightArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    for (int j = 30; j <= 200; j++) {
       
        [_weightArray addObject:[NSString stringWithFormat:@"%d",j]];
    
    }
    
    if ([self.loginState isEqualToString:@"wx"]) {
        
        _headUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"responseObject"][@"headimgurl"];
        
        [_headButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_headUrl]] forState:UIControlStateNormal];
        
        self.pickView.hidden = YES;
        
        _nameField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"responseObject"][@"nickname"];
        
        if(_nameField.text.length > 10){
            
            _nameField.text = [_nameField.text substringToIndex:10];
            
        }

    }else if ([self.loginState isEqualToString:@"qq"]){
    
        _headUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"response"][@"figureurl_qq_2"];
        
        [_headButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_headUrl]] forState:UIControlStateNormal];
        
        self.pickView.hidden = YES;
        
        _nameField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"response"][@"nickname"];
        
        if(_nameField.text.length > 10){
            
            _nameField.text = [_nameField.text substringToIndex:10];
            
        }

    }else if ([self.loginState isEqualToString:@"wb"]){
    
        _headUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"wbheadUrl"];
        
        [_headButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_headUrl]] forState:UIControlStateNormal];
        
        self.pickView.hidden = YES;
        
        _nameField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"wbname"];
        
        if(_nameField.text.length > 10){
            
            _nameField.text = [_nameField.text substringToIndex:10];
            
        }

    }
    
    [self createButton];
    
    [self createTableView];
    
    [self createFooterView];
    
    [_nameField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    self.nameView.layer.masksToBounds = YES;
    self.nameView.layer.cornerRadius = 24;
    self.nameView.backgroundColor = [UIColor whiteColor];
    self.nameView.layer.borderWidth = 1;
    self.nameView.layer.borderColor = [UIColor colorWithHexString:@"B7B7B7" alpha:1].CGColor;
    
    
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self status];
}

-(void)textfieldDidChange:(UITextField *)textField{
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
       
        if(_nameField.text.length > 10){
            
            _nameField.text = [_nameField.text substringToIndex:10];

        }
    }
    
}


- (IBAction)headButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
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
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];//显示出来
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
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

    [_headButton setImage:img forState:UIControlStateNormal];

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

        _headUrl = [NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"]];
        
        self.pickView.hidden = YES;
        
        [self status];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {


    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
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
    self.tableView.tableHeaderView = self.backView;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count?:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RegisterNextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterNext"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RegisterNextCell" owner:self options:nil][0];
    }
    cell.delegate = self;
    [cell addoptionWithArray:_dataArray andIndexpath:indexPath andSelectionArray:_selectionArray];
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    if (indexPath.row == 0) {
        cell.warnLabel.text = @"(不可修改)";
        cell.warnLabel.hidden = NO;
        cell.warnLabel.textColor =  [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }else if (indexPath.row == 4) {
        cell.warnLabel.text = @"(可多选)";
        cell.warnLabel.hidden = NO;
        cell.warnLabel.textColor =  [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }else{
        cell.warnLabel.hidden = YES;
    }
    return cell;
}

//cell上的单选按钮点击事件
-(void)buttonClickOnCell:(UIButton *)button{
    
    RegisterNextCell *cell = (RegisterNextCell *)button.superview.superview;
    
    [self.view endEditing:YES];
    
    if (button.tag/100 - 1 == 3) {
    
        for (int i = 0; i < 4;  i++) {
            
            UIButton *btn = (UIButton *)[cell.contentView viewWithTag:button.tag/100 * 100 + i];
            

            if (button.tag == btn.tag) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               
                if (button.tag%100 == 0) {
                    
                    _role = @"M";
                    
                }else if (button.tag%100 == 1){
                    
                    _role = @"SM";
                    
                }else if (button.tag%100 == 2){
                    
                    _role = @"~";
                    
                }else if (button.tag%100 == 3){
                
                    _role = @"S";
                }

                button.layer.borderWidth = 0;
                
                [self status];
                
            }else{
                
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                btn.layer.borderWidth = 1;
            }
        }

    }else if(button.tag/100 - 1 == 0){
    
        
        for (int i = 0; i < 3;  i++) {
            
            UIButton *btn = (UIButton *)[cell.contentView viewWithTag:button.tag/100 * 100 + i];

            if (button.tag == btn.tag) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if (button.tag/100 - 1 == 0) {
                    
                    if (button.tag%100 == 0) {
                        
                        _sex = @"1";
                        
                    }else if (button.tag%100 == 1){
                        
                        _sex = @"2";
                        
                    }else if (button.tag%100 == 2){
                        
                        _sex = @"3";
                    }
                }
                
                button.layer.borderWidth = 0;
                
                [self status];
                
            }else{
                
                [btn setBackgroundColor:[UIColor whiteColor]];
                
                [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                btn.layer.borderWidth = 1;
            }
        }

    }

}

//cell上的多选按钮点击事件
-(void)buttonClickOnCell:(UIButton *)button changeSelection:(NSMutableArray *)selectionArray{
    
    [self.view endEditing:YES];
    
    _selectionArray = selectionArray;
    
    if ([_selectionArray[button.tag%100] isEqualToString:@"yes"]) {
        
        [button setBackgroundColor:TextCOLOR];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_sexualArray replaceObjectAtIndex:button.tag%100 withObject:button.titleLabel.text];
        
        button.layer.borderWidth = 0;
        
    }else{
        
        [_sexualArray replaceObjectAtIndex:button.tag%100 withObject:@""];
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
        
        button.layer.borderWidth = 1;
    }
    
}

-(void)createFooterView{
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH,150)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, WIDTH - 60, 20)];
    warnLabel.text = @"系统会智能展示符合您性取向的人和动态";
    warnLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    warnLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:warnLabel];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, WIDTH - 60, 51)];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:normal];
    _nextButton.userInteractionEnabled = NO;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = 25;
    [_nextButton setBackgroundColor:TextCOLOR];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nextButton addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.clipsToBounds = YES;
    [view addSubview:_nextButton];
    self.tableView.tableFooterView = view;
}

-(void)ButtonClick{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self isEmpty:self.nameField.text] || self.nameField.text.length == 0) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"昵称中不能包含空格且昵称不能为空~"];
        
    }else if ([self.nameField.text containsString:@"奴"] || [self.nameField.text containsString:@"虐"] || [self.nameField.text containsString:@"性"] || [self.nameField.text containsString:@"狗"] || [self.nameField.text containsString:@"畜"] || [self.nameField.text containsString:@"贱"] || [self.nameField.text containsString:@"骚"] || [self.nameField.text containsString:@"淫"] || [self.nameField.text containsString:@"阴"] || [self.nameField.text containsString:@"肛"] || [self.nameField.text containsString:@"SM"] || [self.nameField.text containsString:@"sm"] || [self.nameField.text containsString:@"Sm"] || [self.nameField.text containsString:@"sM"]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"很抱歉，您的昵称包含有禁止使用的字：奴、虐、性、狗、畜、贱、骚、淫、阴、肛、SM、sm、Sm、sM，请修改后重试~"];
        
    }else{
    
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/users/chargeSecond"];
        
        NSDictionary *parameters = @{@"nickname":self.nameField.text};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSMutableArray *sexualArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < _sexualArray.count; i++) {
                    
                    if ([_sexualArray[i] length] != 0) {
                        
                        [_sexualArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", i + 1]];
                        
                    }
                }
                
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
                
                if (_sexual.length == 0) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"性取向不能为空~"];
                    
                    
                }else{
                    
                    LDIAmViewController *ivc = [[LDIAmViewController alloc] init];
                    
                    
                    NSDictionary* dic = @{
                                          @"nickname" :self.nameField.text,
                                          @"head_pic":_headUrl,
                                          @"sex":_sex,
                                          @"birthday":_birthday,
                                          @"tall":_height,
                                          @"weight":_weight,
                                          @"role":_role,
                                          @"sexual":_sexual
                                          };
                    
                    if ([self.loginState isEqualToString:@"wx"] || [self.loginState isEqualToString:@"qq"] || [self.loginState isEqualToString:@"wb"]) {
                        
                        ivc.loginState = self.loginState;
                        
                    }else{
                        
                        ivc.basicDic = self.basicDic;
                    }
                    
                    ivc.dict = dic;
                    
                    [self.navigationController pushViewController:ivc animated:YES];
                }
            }
        } failed:^(NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求超时,请稍后重试~"];
            
        }];

    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1) {
        
        [self.view endEditing:YES];
        
        self.dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        self.dateView.backgroundColor = [UIColor clearColor];
        
        [self.navigationController.view addSubview:self.dateView];
        
#pragma mark - 时间datePicker
        self.datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, HEIGHT - 216, WIDTH, 216)];
        self.datePickerView.backgroundColor = [UIColor whiteColor];
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        self.datePickerView.minuteInterval = 10;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
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
        singletap1.delegate = self;
        [self.dateShadowView addGestureRecognizer:singletap1];
        
        _birthdayCell = [self.tableView cellForRowAtIndexPath:indexPath];

    }else if(indexPath.row == 2){
        
        [self.view endEditing:YES];
    
        self.LVView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];

        self.LVView.backgroundColor = [UIColor clearColor];
        [self.navigationController.view addSubview:self.LVView];

        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT - 216, WIDTH, 216)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        
        [self.pickerView selectRow:55 inComponent:0 animated:YES];
        [self.pickerView selectRow:30 inComponent:2 animated:YES];
        
        _height = _heightArray[55];
        
        _weight = _weightArray[30];
        
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
        singletap.delegate = self;
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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH / 4 - 20 , 50)];
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
    
    _height = nil;
    
    _weight = nil;
   
    [self.dateView removeFromSuperview];
    
    [self.LVView removeFromSuperview];
}

-(void)sureButtonOnClick{

    _cell.showLabel.text = [NSString stringWithFormat:@"%@cm-%@kg",_height,_weight];
    
    [self status];
    
    [self.LVView removeFromSuperview];
}

- (void)sureButtonOnClick1 {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _birthday = [dateFormatter stringFromDate:self.datePickerView.date];
    
    [self status];
    
    _birthdayCell.showLabel.text = _birthday;
    
    [self.dateView removeFromSuperview];
    
}

-(void)status{
    
    if (self.nameField.text.length != 0 && self.headUrl.length != 0 && self.sex.length != 0 && self.birthday.length != 0 && self.height.length != 0 && self.weight.length != 0 && self.role.length != 0) {
        self.nextButton.userInteractionEnabled = YES;
    }else{
        self.nextButton.userInteractionEnabled = NO;
    }
}

- (void)createButton {
    
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
}


-(void)backButtonOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//textfield的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
