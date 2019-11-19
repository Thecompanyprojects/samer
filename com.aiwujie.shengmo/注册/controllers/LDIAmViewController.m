//
//  LDIAmViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDIAmViewController.h"
#import "LDIamCell.h"
#import "LDMainTabViewController.h"
#import "AppDelegate.h"

@interface LDIAmViewController ()<UITableViewDelegate,UITableViewDataSource,LDIamCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) UIButton *completeButton;

@property (nonatomic,copy) NSString *along;
@property (nonatomic,copy) NSString *experience;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *want;
@property (nonatomic,copy) NSString *culture;
@property (nonatomic,copy) NSString *monthly;
@property (nonatomic,copy) NSString *introduce;

@property (nonatomic,copy) NSString *bodyData;
@property (nonatomic,copy) NSString *locationData;

//存储按钮选择状态
@property (nonatomic,strong) NSMutableArray *levelSelectionArray;
@property (nonatomic,strong) NSMutableArray *wantSelectionArray;

//存储选择的多选按钮的值
@property (nonatomic,strong) NSMutableArray *levelArray;
@property (nonatomic,strong) NSMutableArray *wantArray;

@end

@implementation LDIAmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我是";
    
    _dataArray = @[@[@"1年以下",@"2-3年",@"4-6年",@"7-10年",@"10-20年",@"20年以上"],@[@"有",@"无"],@[@"轻度",@"中度",@"重度"],@[@"聊天",@"现实",@"结婚"],@[@"高中及以下",@"大专",@"本科",@"双学士",@"硕士",@"博士",@"博士后"],@[@"2千以下",@"2千-5千",@"5千-1万",@"1万-2万",@"2万-5万",@"5万以上"],@[@""]];
    
    _array = [NSMutableArray array];
    
    _levelSelectionArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no", nil];
    
    _wantSelectionArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no", nil];
    
    _levelArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    _wantArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    NSArray *array = @[@"",@"",@"",@"",@"",@"",@""];
    
    [_array addObjectsFromArray:array];
    
    [self createButton];
    
    [self createTableView];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWasShown:(NSNotification*)aNotification
{

}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
     [self status];

}

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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LDIamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDIam"];
    
    if (indexPath.section == _dataArray.count - 1) {
        
        if (!cell) {
            
           cell = [[NSBundle mainBundle] loadNibNamed:@"LDIamCell" owner:self options:nil][2];
        }
        
        [cell textViewText:_array];

    }else{
    
        if ([_dataArray[indexPath.section] count] >= 5) {
                
            if (!cell) {
                    
                cell = [[NSBundle mainBundle] loadNibNamed:@"LDIamCell" owner:self options:nil][1];
            }
                
            [cell addoptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_array andSelectionArray:nil];

        }else{
                
            if (!cell) {
                    
                cell = [[NSBundle mainBundle] loadNibNamed:@"LDIamCell" owner:self options:nil][0];
            }

            if (indexPath.section == 2) {
                
                [cell addoptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_levelArray andSelectionArray:_levelSelectionArray];
                
            }else if(indexPath.section == 3){
            
                [cell addoptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_wantArray andSelectionArray:_wantSelectionArray];
                
            }else{
            
                [cell addoptionWithArray:_dataArray[indexPath.section] andIndexpath:indexPath andOtherArray:_array andSelectionArray:nil];
            }  
        }
    }
    
    cell.delegate = self;
    
    return cell;

  
}

//cell上的多选按钮点击事件
-(void)buttonClickOnCell:(UIButton *)button changeSelection:(NSMutableArray *)selectionArray{
    
    [self.view endEditing:YES];
    
    if (button.tag/100 == 2) {
        
        _levelSelectionArray = selectionArray;
        
    }else if (button.tag/100 == 3){
    
        _wantSelectionArray = selectionArray;
    }
    
    if ([selectionArray[button.tag%100] isEqualToString:@"yes"]) {
        
        [button setBackgroundColor:TextCOLOR];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (button.tag/100 == 2){
            
            [_levelArray replaceObjectAtIndex:button.tag%100 withObject:_dataArray[button.tag/100][button.tag%100]];
            
        }else if (button.tag/100 == 3){
                    
            [_wantArray replaceObjectAtIndex:button.tag%100 withObject:_dataArray[button.tag/100][button.tag%100]];
            
        }
            
        button.layer.borderWidth = 0;
    
    }else{
        
        if (button.tag/100 == 2) {
            
             [_levelArray replaceObjectAtIndex:button.tag%100 withObject:@""];
            
        }else if (button.tag/100 == 3){
            
            [_wantArray replaceObjectAtIndex:button.tag%100 withObject:@""];
        }
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
        
        button.layer.borderWidth = 1;
    }

    [self status];

}

//cell上的按钮点击事件
-(void)buttonClickOnCell:(UIButton *)button{
    
    LDIamCell *cell = (LDIamCell *)button.superview.superview;
    
    [self.view endEditing:YES];
    
    for (UIButton *btn in cell.contentView.subviews) {
        
        if (button.tag == btn.tag) {
            
            [button setBackgroundColor:TextCOLOR];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if (button.tag/100 == 0) {
                
                _along = [NSString stringWithFormat:@"%d",button.tag%100 + 1];
                
                [_array replaceObjectAtIndex:button.tag/100 withObject:_dataArray[button.tag/100][button.tag%100]];
                
            }else if (button.tag/100 == 1){
            
                _experience = [NSString stringWithFormat:@"%d",button.tag%100 + 1];
                
                 [_array replaceObjectAtIndex:button.tag/100 withObject:_dataArray[button.tag/100][button.tag%100]];
                
            }else if (button.tag/100 == 4){
            
                _culture = [NSString stringWithFormat:@"%d",
                            button.tag%100 + 1];
                
                 [_array replaceObjectAtIndex:button.tag/100 withObject:_dataArray[button.tag/100][button.tag%100]];
                
            }else if (button.tag/100 == 5){
            
                _monthly = [NSString stringWithFormat:@"%d",button.tag%100 + 1];
                
                 [_array replaceObjectAtIndex:button.tag/100 withObject:_dataArray[button.tag/100][button.tag%100]];
                
            }
            
            button.layer.borderWidth = 0;
            
        }else{
            
            
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            [btn setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
            
            btn.layer.borderWidth = 1;
            
        }
    }
    [self status];
}

-(BOOL)buttonClickTextView:(UITextView *)textView andText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [_array replaceObjectAtIndex:_array.count - 1 withObject:textView.text];
        _introduce = textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)sendText:(UITextView *)textView{
    _introduce = textView.text;
}

-(void)status{

    if (self.along.length != 0 && self.experience.length != 0 && self.culture.length != 0 && self.monthly.length != 0 && self.introduce.length != 0) {

        
        self.completeButton.userInteractionEnabled = YES;
        
    }else{

        self.completeButton.userInteractionEnabled = NO;
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == _dataArray.count - 1) {
        
        return 150;
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    view.backgroundColor = [UIColor clearColor];
    
    NSArray *titleArray = @[@"接触多久",@"是否实践过",@"程度",@"我想找",@"我的学历",@"我的月薪",@"自我介绍/择偶要求等"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, WIDTH/2, 25)];
    
    label.text = titleArray[section];
    
    label.font = [UIFont systemFontOfSize:14];
    
    label.textColor = TextCOLOR;
    
    [view addSubview:label];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 , 5, WIDTH/2 - 30, 25)];
    
    if (section == _dataArray.count - 1) {
        
        hintLabel.text = @"最多可输入256个字";
        
    }else if(section == 2 || section == 3){
    
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == _dataArray.count - 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH,150)];
        view.backgroundColor = [UIColor clearColor];
        _completeButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, WIDTH - 60, 51)];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:normal];
        _completeButton.userInteractionEnabled = NO;
        [_completeButton setBackgroundColor:TextCOLOR];
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_completeButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.layer.cornerRadius = 25;
        _completeButton.clipsToBounds = YES;
        [self status];
        [view addSubview:_completeButton];
        return view;
    }
    return nil;
}

-(void)ButtonClick:(UIButton *)button{
        
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
    
    if (_level.length == 0 || _want.length == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"程度或我想找不能为空~"];
        
    }else{
    
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *new_device_brand = [[LDFromwebManager defaultTool] getCurrentDeviceModel];
        
        NSString *new_device_version = [[UIDevice currentDevice] systemVersion];
        
        NSString *new_device_appversion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
        NSString *new_device_token = [NSString new];
        if ([keychain[@"device_token"] length] == 0) {
            new_device_token = @"";
        }else{
            new_device_token = keychain[@"device_token"];
        }
        
        NSDictionary *dict = @{@"along":_along,
                               @"experience":_experience,
                               @"level":_level,
                               @"want":_want,
                               @"culture":_culture,
                               @"monthly":_monthly,
                               @"introduce":_introduce,
                               @"new_device_brand":new_device_brand?:@"",
                               @"new_device_version":new_device_version?:@"",
                               @"new_device_appversion":new_device_appversion?:@"",
                               @"new_device_token":new_device_token?:@""};
        
        NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithDictionary:self.dict];
        
        NSArray *array = [dict allKeys];
        
        for (int i = 0; i < dict.count; i++) {
            
            [diction setObject:dict[array[i]] forKey:array[i]];
        }
        
        
        NSString *lat;
        NSString *lng;
        NSString *city;
        NSString *addr;
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:latitude] length] == 0) {
            
            lat = @"";
            
        }else{
            
            lat = [[NSUserDefaults standardUserDefaults] objectForKey:latitude];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:longitude] length] == 0) {
            
            lng = @"";
            
        }else{
            
            lng = [[NSUserDefaults standardUserDefaults] objectForKey:longitude];
        }
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] length] == 0) {
            
            city = @"";
            
        }else{
            
            city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"] length] == 0) {
            
            addr = @"";
            
        }else{
            
            addr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addr"];
        }
        
        NSDictionary *locationDic =
        
        @{@"lat":lat,@"lng":lng,@"city":city,@"addr":addr
          };
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,registernewrdUrl]];
        
        NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
        
        NSDictionary *d;
        
        if ([self.loginState isEqualToString:@"wx"] || [self.loginState isEqualToString:@"qq"] || [self.loginState isEqualToString:@"wb"]) {
            
            self.basicDic = @{@"openid":[[NSUserDefaults standardUserDefaults] objectForKey:@"openid"],@"channel":[[NSUserDefaults standardUserDefaults] objectForKey:@"loginChannel"]};
            
            d = @{@"basic":self.basicDic,@"userinfo":diction,@"location":locationDic};
            
        }else{
            
            d = @{@"basic":self.basicDic,@"userinfo":diction,@"location":locationDic};
        }
        
        NSData* da = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *bodyData = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
        
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        [postRequest setHTTPMethod:@"POST"];
        
        [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        //    ViewController * __weak weakSelf = self;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                
                NSDictionary *responseDic = [NSObject parseJSONStringToNSDictionary:result];
                
                if ([responseDic[@"retcode"] intValue] == 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    //男同性恋
                    if ([diction[@"sex"] intValue] == 1) {
                        
                        if ([diction[@"sexual"] isEqualToString:@"1,3"]) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1,3" forKey:@"sexButton"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexualButton"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sexual"] forKey:@"dynamicSex"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sex"] forKey:@"dynamicSexual"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"群组筛选"];
                            
                        }else if ([diction[@"sexual"] intValue] == 1) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexButton"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sexualButton"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sexual"] forKey:@"dynamicSex"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sex"] forKey:@"dynamicSexual"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"群组筛选"];
                        }
                        
                    }
                    
                    //女同性恋
                    if ([diction[@"sex"] intValue] == 2) {
                        
                        if ([diction[@"sexual"] isEqualToString:@"2,3"]) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"2,3" forKey:@"sexButton"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"sexualButton"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sexual"] forKey:@"dynamicSex"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sex"] forKey:@"dynamicSexual"];
                            
                            //根据我的性取向展示感兴趣的群组
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"群组筛选"];
                            
                        }else if([diction[@"sexual"] intValue] == 2) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"sexButton"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"sexualButton"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sexual"] forKey:@"dynamicSex"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sex"] forKey:@"dynamicSexual"];
                            
                            //根据我的性取向展示感兴趣的群组
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"群组筛选"];
                        }
                        
                    }
                    
                    //CDTS
                    if ([diction[@"sex"] intValue] == 3) {
                        
                        if ([diction[@"sexual"] isEqualToString:@"3"]) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchSwitch"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"sexButton"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sexualButton"];
                            
                            //根据我的性取向展示感兴趣的动态
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"动态筛选"];
                            [[NSUserDefaults standardUserDefaults] setObject:diction[@"sexual"] forKey:@"dynamicSex"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"dynamicSexual"];
                            
                            //根据我的性取向展示感兴趣的群组
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"群组筛选"];
                        }
                    }
                    
                    
                    //根据我的性取向展示感兴趣的人
                    [[NSUserDefaults standardUserDefaults] setObject:diction[@"sex"] forKey:@"newestSex"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:diction[@"sexual"] forKey:@"newestSexual"];
                    
                    
                    //存储个人UID和融云token
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseDic[@"data"][@"uid"]] forKey:@"uid"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"data"][@"r_token"] forKey:@"token"];
                    
                    /**
                     融云聊天集成
                     */
                    [[RCIM sharedRCIM] connectWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] success:^(NSString *userId) {
                        
                        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                        
                        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                        
                        
                    } error:^(RCConnectErrorCode status) {
                        NSLog(@"登陆的错误码为:%ld", (long)status);
                    } tokenIncorrect:^{
                        //token过期或者不正确。
                        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                        NSLog(@"token错误");
                    }];
                    
                    
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    
                    
                    LDMainTabViewController *mvc = [[LDMainTabViewController alloc] initWithNibName:@"LDMainTabViewController" bundle:nil];
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    app.window.rootViewController = mvc;
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseDic objectForKey:@"msg"]];
                }
            });
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==4) {
        return 144;
    }
    else if (indexPath.section==6) {
        return 130;
    }
    else{
        if ([_dataArray[indexPath.section] count] >= 5) {
            return 100;
            
        }else{
            return 65;
        }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
