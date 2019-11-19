//
//  GifView.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "GifView.h"
#import "FlowFlower.h"

@interface GifView ()<UIScrollViewDelegate,UITextFieldDelegate>

//展示礼物的view
@property (nonatomic,strong) UIView *backView;
//赠送的view
@property (nonatomic,strong) UIView *giveView;
//展示礼物的scroll
@property (nonatomic,strong) UIScrollView *scrollView;
//展示系统礼物的scroll
@property (nonatomic,strong) UIScrollView *SystemScrollView;
//送礼物的按钮
@property (nonatomic,strong) UILabel *giveGifLabel;
//送系统礼物的按钮
@property (nonatomic,strong) UIButton *giveSystemGifButton;
//输入赠送礼物的数量
@property (nonatomic,strong) UITextField *buyField;
//展示拥有的魔豆
@property (nonatomic,strong) UILabel *beansLabel;
//赠送魔豆的总数
@property (nonatomic,strong) UILabel *giveAllNumLabel;
//下方点
@property (nonatomic,strong) UIPageControl *pageControl;
//bool值判断送哪种礼物
@property (nonatomic,assign) BOOL isSelect;
//存储魔豆和动态的id,礼物id
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *psid;
@property (nonatomic,copy) NSString *buyNum;

//存储送礼物的颜色状态
@property (nonatomic,strong) NSArray *grayArray;
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) NSArray *amountArray;
//系统礼物数据源
@property (nonatomic,strong) NSMutableArray *systemGifArray;
@property (nonatomic,strong) NSArray *systemAmountArray;
@property (nonatomic,strong) NSArray *systemArray;

//动态的id和位置
@property (nonatomic,copy) NSString *did;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UIViewController *viewController;

//赠送给默认的UID
@property (nonatomic,copy) NSString *userId;

//从哪里传过来的标签
@property (nonatomic,copy) NSString *sign;

/**
 创建礼物掉落的效果
 */
//创建礼物下落的定时器
@property (nonatomic,strong) NSTimer * gifTimer;
//掉落礼物的view
@property (nonatomic,strong) FlowFlower *flowFlower;
//存储选中的礼物
@property (nonatomic,strong) UIImage *gifImage;
//掉落的时间
@property (nonatomic,assign) int second;

//图片字符串
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,assign) BOOL isChoose;
@end

@implementation GifView

-(instancetype)initWithFrame:(CGRect)frame andisMine:(BOOL )ismine :(void (^)(void))block{

    _MyBlock = block;
    
    if (self = [super initWithFrame:frame]) {
        
        _systemGifArray = [NSMutableArray array];
        _systemArray = @[@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
        _systemAmountArray = @[@"1",@"3",@"5",@"10",@"8"];
        
        _grayArray = @[@[@"棒棒糖",@"狗粮",@"雪糕",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花"],@[@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光"],@[@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡"]];
        
        _amountArray = @[@[@"2",@"6",@"10",@"38",@"99",@"88",@"123",@"166",@"199"],@[@"520",@"666",@"250",@"777",@"888",@"999",@"1314",@"1666",@"1999"],@[@"666",@"999",@"1888",@"2899",@"3899",@"6888",@"9888",@"52000",@"99999"]];
        
        //获取我的系统礼物
        
        [self createOwnSystemGifData:frame andismine:ismine];
       
    }
    return self;
}

//获取我的系统礼物
-(void)createOwnSystemGifData:(CGRect)frame andismine:(BOOL )ismine{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Users/getMyBasicGift"];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                
                if ([dic[@"num"] intValue] != 0) {
                    
                    [_systemGifArray addObject:dic];
                }
            }
        }
        
        [self createUI:frame wihtismine:ismine];
        [self createData];
    } failed:^(NSString *errorMsg) {
        
    }];
}
/**
 获取动态id,位置,及从哪个界面传过来的标记
 */
-(void)getDynamicDid:(NSString *)did  andIndexPath:(NSIndexPath *)indexPath andSign:(NSString *)sign andUIViewController:(UIViewController *)controller{
    _did = did;
    _indexPath = indexPath;
    _sign = sign;
    _viewController = controller;
}

/**
 获取界面传过来的赠送给人的UID及标记
 */
-(void)getPersonUid:(NSString *)userId andSign:(NSString *)sign andUIViewController:(UIViewController *)controller{
    _userId = userId;
    _sign = sign;
    _viewController = controller;
}

-(void)createData{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getmywalletUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:_viewController andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            self.beansLabel.text = [NSString stringWithFormat:@"我的魔豆: %@",responseObj[@"data"][@"wallet"]];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


-(void)createUI:(CGRect)frame wihtismine:(BOOL) ismine{

    self.backgroundColor = [UIColor clearColor];
    
    UIButton *singleButton = [[UIButton alloc] initWithFrame:frame];
    [singleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:singleButton];
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(5 ,(HEIGHT - ( 3 * (WIDTH - 50)/3 + 130))/2, WIDTH - 10, 3 * (WIDTH - 50)/3 + 130)];
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.75;
    back.layer.cornerRadius = 4;
    back.clipsToBounds = YES;
    [self addSubview:back];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(5 ,(HEIGHT - ( 3 * (WIDTH - 50)/3 + 130))/2, WIDTH - 10, 3 * (WIDTH - 50)/3 + 130)];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.layer.cornerRadius = 4;
    _backView.clipsToBounds = YES;
    [self addSubview:_backView];
    
    _isSelect = YES;
    
    _giveGifLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, WIDTH - 200, 15)];
    _giveGifLabel.text = @"送礼物";
    _giveGifLabel.textColor = [UIColor whiteColor];
    _giveGifLabel.textAlignment = NSTextAlignmentCenter;
    _giveGifLabel.font = [UIFont systemFontOfSize:17];
    [_backView addSubview:_giveGifLabel];
    
    _giveSystemGifButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, 15, 100, 15)];
    [_giveSystemGifButton setTitle:@"送免费礼物" forState:UIControlStateNormal];
    [_giveSystemGifButton addTarget:self action:@selector(giveSystemGifButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _giveSystemGifButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_backView addSubview:_giveSystemGifButton];
   
    if (ismine) {
        [self.giveSystemGifButton setHidden:YES];
    }
    else
    {
        [self.giveSystemGifButton setHidden:NO];
    }

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, WIDTH - 10, WIDTH - 10)];
    _scrollView.contentSize = CGSizeMake(_grayArray.count * (WIDTH - 10), WIDTH - 20);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_backView addSubview:_scrollView];
    
    _SystemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, WIDTH - 10, WIDTH - 10)];
    _SystemScrollView.hidden = YES;
    _SystemScrollView.contentSize = CGSizeMake( WIDTH - 10, WIDTH - 20);
    _SystemScrollView.pagingEnabled = NO;
    _SystemScrollView.delegate = self;
    _SystemScrollView.showsHorizontalScrollIndicator = NO;
    [_backView addSubview:_SystemScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, WIDTH + 40, WIDTH - 10, 10)];
    _pageControl.currentPage = 0;
     _pageControl.numberOfPages = _grayArray.count;
    [_backView addSubview:_pageControl];
    
    if (_systemGifArray.count != 0) {
        
        for (int i = 0; i < [_systemGifArray count]; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10, i/3 * (WIDTH - 50)/3 + i/3 * 15, (WIDTH - 50)/3, (WIDTH - 50)/3)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
            button.tag = 1000 * 4 + i;
            [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
            [_SystemScrollView addSubview:button];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10 + ((WIDTH - 50)/3 - (WIDTH - 50)/4)/2, i/3 * (WIDTH - 50)/3 + i/3 * 15, (WIDTH - 50)/4, (WIDTH - 50)/4)];
            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_systemArray[[_systemGifArray[i][@"type"] intValue] - 37]]];
            [_SystemScrollView addSubview:imageV];
            
            UILabel *gifNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10,(WIDTH - 50)/4 + 3 + i/3 * (WIDTH - 50)/3 + i/3 * 15, (WIDTH - 50)/3, 10)];
             gifNameLabel.text = [NSString stringWithFormat:@"%@(×%@)",_systemArray[[_systemGifArray[i][@"type"] intValue] - 37],_systemGifArray[i][@"num"]];
            gifNameLabel.textAlignment = NSTextAlignmentCenter;
            gifNameLabel.font = [UIFont systemFontOfSize:14];
            gifNameLabel.textColor = [UIColor whiteColor];
            [_SystemScrollView addSubview:gifNameLabel];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10,(WIDTH - 50)/4 + 3 + i/3 * (WIDTH - 50)/3 + i/3 * 15 + 15, (WIDTH - 50)/3, 10)];
            numberLabel.text = [NSString stringWithFormat:@"%@魔豆",[NSString stringWithFormat:@"%@",_systemAmountArray[[_systemGifArray[i][@"type"] intValue] - 37]]];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.font = [UIFont systemFontOfSize:13];
            numberLabel.textColor = [UIColor lightGrayColor];
            [_SystemScrollView addSubview:numberLabel];
            
        }
        
    }
    
    for (int j = 0; j < _grayArray.count; j++) {

        for (int i = 0; i < [_grayArray[j] count]; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10 + j * (WIDTH - 10), i/3 * (WIDTH - 50)/3 + i/3 * 15, (WIDTH - 50)/3, (WIDTH - 50)/3)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
            button.tag = 1000 * (j + 1) + i;
            [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10 + ((WIDTH - 50)/3 - (WIDTH - 50)/4)/2 + j * (WIDTH - 10), i/3 * (WIDTH - 50)/3 + i/3 * 15, (WIDTH - 50)/4, (WIDTH - 50)/4)];
            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_grayArray[j][i]]];
            [_scrollView addSubview:imageV];
            
            UILabel *gifNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10 + j * (WIDTH - 10),(WIDTH - 50)/4 + 3 + i/3 * (WIDTH - 50)/3 + i/3 * 15, (WIDTH - 50)/3, 10)];
            gifNameLabel.text = _grayArray[j][i];
            gifNameLabel.textAlignment = NSTextAlignmentCenter;
            gifNameLabel.font = [UIFont systemFontOfSize:14];
            gifNameLabel.textColor = [UIColor whiteColor];
            [_scrollView addSubview:gifNameLabel];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i%3 * (WIDTH - 50)/3 + i%3 * 10 + j * (WIDTH - 10),(WIDTH - 50)/4 + 3 + i/3 * (WIDTH - 50)/3 + i/3 * 15 + 15, (WIDTH - 50)/3, 10)];
            numberLabel.text = [NSString stringWithFormat:@"%@魔豆",_amountArray[j][i]];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.font = [UIFont systemFontOfSize:13];
            numberLabel.textColor = [UIColor lightGrayColor];
            [_scrollView addSubview:numberLabel];

        }

    }
    
    _money = @"";
    
    _psid = @"";
    
    _beansLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 * (WIDTH - 50)/3 + 95, 200, 30)];
    _beansLabel.textColor = [UIColor whiteColor];
    _beansLabel.font = [UIFont systemFontOfSize:13];
    [_backView addSubview:_beansLabel];
    
    UIButton *chargeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width - 60, 3 * (WIDTH - 50)/3 + 95, 40, 30)];
    [chargeButton setTitle:@"充值" forState:UIControlStateNormal];
    chargeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [chargeButton addTarget:self action:@selector(chargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:chargeButton];
    

}

//点击送礼物按钮切换
-(void)giveSystemGifButtonClick{
    
    if (_isSelect) {
        
        _scrollView.hidden = YES;
        
        [_giveSystemGifButton setTitle:@"送礼物" forState:UIControlStateNormal];
        
        _SystemScrollView.hidden = NO;
        
       _giveGifLabel.text =  @"送免费礼物";
        
        _pageControl.hidden = YES;
        
        _isSelect = NO;
        
    }else{
    
        _scrollView.hidden = NO;
        
        _giveGifLabel.text =  @"送礼物";
        
        _SystemScrollView.hidden = YES;
        
        [_giveSystemGifButton setTitle:@"送免费礼物" forState:UIControlStateNormal];
        
        _pageControl.hidden = NO;
        
        _isSelect = YES;
    }

   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
        
        if (scrollView.contentOffset.x <= (WIDTH - 50) * 0.5) {
            
            _pageControl.currentPage = 0;
            
        }else if (scrollView.contentOffset.x >= (WIDTH - 50) * 0.5 && scrollView.contentOffset.x <= (WIDTH - 50) * 1.5){
            
            _pageControl.currentPage = 1;
            
        }else{
            
            _pageControl.currentPage = 2;
        }
    }
}

//点击充值跳转到充值界面
-(void)chargeButtonClick{
    
    if (_MyBlock) {
        
        _MyBlock();
    }
}

//点击礼物外移除打赏礼物的view
-(void)cancleButtonClick{
    [self removeView];
}

-(void)doneButtonClick:(UIButton *)button{
    
    if (_buyField.text.length == 0 || [_buyField.text intValue] == 0 ||
        [[_buyField.text substringToIndex:1] intValue] == 0) {
        [AlertTool alertWithViewController:_viewController andTitle:@"提示" andMessage:@"请输入正确的赠送数量"];
    }else{
        
        [self removeView];
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:_viewController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        NSURL *url;
        NSDictionary *d;
        int idint = [[[TimeManager defaultTool] getNowTimeTimestamp] intValue]*1000;
        NSString *orderid = [NSString stringWithFormat:@"%@%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],idint];
        
//        大喇叭：上大喇叭前端传值1，不上大喇叭传值2
//        字段：dalaba
        NSString *dalaba = [NSString new];
    
        if (self.isChoose) {
            dalaba = @"1";
        }
        else
        {
            dalaba = @"2";
        }
        
        if (self.isfromGroup) {
            if (_isSelect) {
                //赠送个人收费礼物
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/RewardOne"]];
                
            }else{
                //赠送个人免费礼物
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/RewardOneBasicG"]];
            }
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *beans = [NSString stringWithFormat:@"%d",[_money intValue] * [_buyField.text intValue]];
            NSString *num = _buyField.text;
            NSDictionary *params = @{@"orderid":orderid?:@"",@"uid":uid?:@"",@"beans":beans?:@"",@"num":num?:@"",@"type":_psid,@"dalaba":dalaba,@"groupid":self.groupid?:@""};
            d = params.copy;
        }
        else
        {
            if ([_sign isEqualToString:@"赠送给某人"]) {
                
                if (_isSelect) {
                    //赠送个人收费礼物
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/RewardOne"]];
                    
                }else{
                    //赠送个人免费礼物
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/RewardOneBasicG"]];
                    
                }
                if (self.isfromchatroom) {
                    d = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"fuid":self.userId,@"beans":[NSString stringWithFormat:@"%d",[_money intValue] * [_buyField.text intValue]],@"type":_psid,@"num":_buyField.text,@"dalaba":dalaba,@"roomid":roomidStr,@"is_home":@"4"};
                }
                else
                {
                    d = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"fuid":self.userId,@"beans":[NSString stringWithFormat:@"%d",[_money intValue] * [_buyField.text intValue]],@"type":_psid,@"num":_buyField.text,@"dalaba":dalaba,@"is_home":self.is_home?:@""};
                }
         
                
            }else{
                
                if (_isSelect) {
                    //打赏动态收费礼物
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/RewardDynamicnew"]];
                    
                }else{
                    //打赏动态面礼物
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/RewardBasicGDynamic"]];
                    
                }
                
                d = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"did":_did,@"amount":[NSString stringWithFormat:@"%d",[_money intValue] * [_buyField.text intValue]],@"psid":_psid,@"num":_buyField.text,@"dalaba":dalaba};
            }
        }

        NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
        
        NSData* da = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *bodyData = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
        
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        
        [postRequest setHTTPMethod:@"POST"];
        
        [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDic = [NSObject parseJSONStringToNSDictionary:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([responseDic[@"retcode"] intValue] == 2000) {
                    
                    NSDictionary *data = [responseDic objectForKey:@"data"];
                    if (data.count) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatroomgif" object:data];
                    }
                    
                    if ([_sign isEqualToString:@"赠送给某人"]) {
                        
                        HUD.labelText = @"赠送成功";
                        HUD.removeFromSuperViewOnHide = YES;
                        [HUD hide:YES afterDelay:1];
                        if (self.sendmessageBlock) {
                            NSDictionary *dic = @{@"num":self.buyField.text,@"image":self.imageName,@"orderid":orderid};
                            self.sendmessageBlock(dic);
                        }
                    }else{
                        
                        HUD.labelText = @"打赏成功";
                        HUD.removeFromSuperViewOnHide = YES;
                        [HUD hide:YES afterDelay:1];
                        if (self.sendmessageBlock) {
                            NSDictionary *dic = @{@"num":self.buyField.text,@"image":self.imageName};
                            self.sendmessageBlock(dic);
                        }
                        if ([_sign isEqualToString:@"动态"]) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"打赏成功" object:nil userInfo:@{@"section":[NSString stringWithFormat:@"%ld",(long)_indexPath.section]}];
                            
                        }else if([_sign isEqualToString:@"更多动态"]){
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"更多打赏成功" object:nil userInfo:@{@"section":[NSString stringWithFormat:@"%ld",(long)_indexPath.section]}];
                            
                        }else if([_sign isEqualToString:@"个人主页动态"]){
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"个人主页打赏成功" object:nil userInfo:@{@"section":[NSString stringWithFormat:@"%ld",(long)_indexPath.section]}];
                            
                        }else if ([_sign isEqualToString:@"动态详情"]){
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"动态详情打赏成功" object:nil];
                            
                        }else if([_sign isEqualToString:@"收藏动态"]){
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"收藏动态打赏成功" object:nil userInfo:@{@"section":[NSString stringWithFormat:@"%ld",(long)_indexPath.section]}];
                        }
                    }
                    
                    _second = 0;
                    
                    _gifTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                    
                    //face
                    UIImage *faceImage = _gifImage;
                    
                    [[NSRunLoop currentRunLoop] addTimer:_gifTimer forMode:NSRunLoopCommonModes];
                    
                    //飞行
                    _flowFlower = [FlowFlower flowerFLow:@[faceImage]];
                    
                    [_flowFlower startFlyFlowerOnView:_viewController.view];
                    
                    [self createData];
                    
//                    [self removeView];
                    
                }else{
                    
                    [HUD hide:YES];
                    
                    if ([responseDic[@"retcode"] intValue]/1000 != 4 || [responseDic[@"retcode"] intValue] == 4004) {
                        
                        [AlertTool alertWithViewController:_viewController andTitle:@"提示" andMessage:responseDic[@"msg"]];
                    }
                }
                
            });
            
        }];
    }

}

-(void)timeFireMethod{
    _second ++;
    if (_second == 3) {
        [_flowFlower endFlyFlower];
        [_gifTimer invalidate];
        _flowFlower = nil;
        _gifTimer = nil;
    }
}

-(void)buttonClick1:(UIButton *)button{
    if (_giveView) {
        [self giveCancelButtonClick];
    }
    CGFloat space = (WIDTH - 200 - (WIDTH - 50)/3)/4;
    _giveView = [[UIView alloc] initWithFrame:CGRectMake(20, (3 * (WIDTH - 50)/3 + 190 - WIDTH)/2, WIDTH - 50, WIDTH - 60)];
    _giveView.backgroundColor = [UIColor whiteColor];
    _giveView.layer.cornerRadius = 4;
    _giveView.clipsToBounds = YES;
    [_backView addSubview:_giveView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_giveView addGestureRecognizer:tap];

    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 50 - (WIDTH - 50)/3)/2, 15, (WIDTH - 50)/3, (WIDTH - 50)/3)];
    
    if (_isSelect) {
        
        image.image = [UIImage imageNamed:_grayArray[button.tag/1000 - 1][button.tag%1000]];
        self.imageName = _grayArray[button.tag/1000 - 1][button.tag%1000];
    }else{
    
            
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_systemArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37]]];
        self.imageName = _systemArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37];
    }
    
    _gifImage = image.image;
    
    [_giveView addSubview:image];
    
    UILabel *giveNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 + (WIDTH - 50)/3, WIDTH - 50, 10)];
    
    if (_isSelect) {
        
        giveNameLabel.text = _grayArray[button.tag/1000 - 1][button.tag%1000];
        
    }else{
            
        giveNameLabel.text = _systemArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37];
  
    }
    giveNameLabel.font = [UIFont systemFontOfSize:14];
    giveNameLabel.textAlignment = NSTextAlignmentCenter;
    [_giveView addSubview:giveNameLabel];
    
    UILabel *giveNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35 + (WIDTH - 50)/3, WIDTH - 50, 10)];
    
    if (_isSelect) {
       
        giveNumLabel.text = [NSString stringWithFormat:@"%@魔豆",_amountArray[button.tag/1000 - 1][button.tag%1000]];
        
        _money = _amountArray[button.tag/1000 - 1][button.tag%1000];
        
    }else{
        
        giveNumLabel.text = [NSString stringWithFormat:@"%@魔豆",_systemAmountArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37]];
  
        _money = _systemAmountArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37];
    }
    
    giveNumLabel.textColor = [UIColor lightGrayColor];
    giveNumLabel.font = [UIFont systemFontOfSize:14];
    giveNumLabel.textAlignment = NSTextAlignmentCenter;
    [_giveView addSubview:giveNumLabel];
    
    if (button.tag/1000 == 1) {
        
        _psid = [NSString stringWithFormat:@"%ld",10 + button.tag%1000];
        
    }else if (button.tag/1000 == 2){
    
        _psid = [NSString stringWithFormat:@"%ld",19 + button.tag%1000];
        
    }else if(button.tag/1000 == 3){
    
        _psid = _psid = [NSString stringWithFormat:@"%ld",28 + button.tag%1000];
        
    }else{
    
        _psid = [NSString stringWithFormat:@"%@",_systemGifArray[button.tag%1000][@"type"]];
    }
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + (WIDTH - 50)/3 + space, (WIDTH - 50)/2, 20)];
    buyLabel.textAlignment = NSTextAlignmentRight;
    buyLabel.text = @"赠送数量    ";
    buyLabel.font = [UIFont systemFontOfSize:14];
    [_giveView addSubview:buyLabel];
    
    _buyField = [[UITextField alloc] initWithFrame:CGRectMake((WIDTH - 50)/2 + 5, 50 + (WIDTH - 50)/3 + space, (WIDTH - 50)/4, 20)];
    _buyField.delegate = self;
    _buyField.text = @"1";
    _buyField.borderStyle = UITextBorderStyleRoundedRect;
    _buyField.keyboardType = UIKeyboardTypeNumberPad;
    [_buyField addTarget:self action:@selector(buyFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _buyField.font = [UIFont systemFontOfSize:14];
    [_giveView addSubview:_buyField];
     
    _giveAllNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,67.5 + (WIDTH - 50)/3 + 2 * space, WIDTH - 50, 20)];
    _giveAllNumLabel.textAlignment = NSTextAlignmentCenter;
    _giveAllNumLabel.font = [UIFont systemFontOfSize:14];
    NSString *newNum = [NSString new];
    if (_isSelect) {
         newNum = _amountArray[button.tag/1000 - 1][button.tag%1000];
        _giveAllNumLabel.text = [NSString stringWithFormat:@"总价值:  %@ 魔豆",_amountArray[button.tag/1000 - 1][button.tag%1000]];
        
    }else{
        newNum =_systemAmountArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37];
        _giveAllNumLabel.text = [NSString stringWithFormat:@"总价值:  %@ 魔豆",_systemAmountArray[[_systemGifArray[button.tag%1000][@"type"] intValue] - 37]];
    }
    
    [_giveView addSubview:_giveAllNumLabel];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85 + (WIDTH - 50)/3 + 3 * space, WIDTH - 50, 20)];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:14];
    warnLabel.text = @"总价值500魔豆及以上可选是否上大喇叭";
    warnLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosebtnclick)];
    [warnLabel addGestureRecognizer:singleTap];
    
    [_giveView addSubview:warnLabel];
    
    self.chooseBtn = [[UIButton alloc] init];
    [_giveView addSubview:self.chooseBtn];
    [self.chooseBtn setImage:[UIImage imageNamed:@"kongguanzhu"] forState:normal];
    if ([newNum intValue]>=500) {
         [self.chooseBtn setImage:[UIImage imageNamed:@"shiguanzhu"] forState:normal];
         self.isChoose = YES;
    }
    else
    {
         [self.chooseBtn setImage:[UIImage imageNamed:@"kongguanzhu"] forState:normal];
         self.isChoose = NO;
    }
    
    if (ISIPHONEPLUS) {
        self.chooseBtn.frame = CGRectMake(35, 83 + (WIDTH - 50)/3 + 3 * space, 25, 25);
    }else
    {
        self.chooseBtn.frame = CGRectMake(14, 83 + (WIDTH - 50)/3 + 3 * space, 25, 25);
    }
    
    [self.chooseBtn addTarget:self action:@selector(choosebtnclick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, WIDTH - 95, (WIDTH - 50)/2 - 7.5, 30)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = MainColor;
    [cancelButton addTarget:self action:@selector(giveCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_giveView addSubview:cancelButton];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(2.5 + (WIDTH - 50)/2, WIDTH - 95, (WIDTH - 50)/2 - 7.5, 30)];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureButton setTitle:@"确认赠送" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.backgroundColor = MainColor;
    [_giveView addSubview:sureButton];
}

//赠送礼物view的删除
-(void)giveCancelButtonClick{

    [_giveView removeFromSuperview];
}

//数量的改变改变总价值
-(void)buyFieldDidChange{

    if (_buyField.text.length != 0 && [_buyField.text intValue] > 0) {
        
        _giveAllNumLabel.text = [NSString stringWithFormat:@"总价值:  %d 魔豆",[_buyField.text intValue] * [_money intValue]];
        if ([_buyField.text intValue] * [_money intValue]>=500) {
            self.isChoose = YES;
            [self.chooseBtn setImage:[UIImage imageNamed:@"shiguanzhu"] forState:normal];
        }else
        {
            self.isChoose = NO;
            [self.chooseBtn setImage:[UIImage imageNamed:@"kongguanzhu"] forState:normal];
        }
    }else{
    
        _giveAllNumLabel.text = [NSString stringWithFormat:@"总价值:  %d 魔豆",[_money intValue]];
        
        if ([_money intValue]>=500) {
            self.isChoose = YES;
            [self.chooseBtn setImage:[UIImage imageNamed:@"shiguanzhu"] forState:normal];
        }else
        {
            self.isChoose = NO;
            [self.chooseBtn setImage:[UIImage imageNamed:@"kongguanzhu"] forState:normal];
        }
    }
}

//隐藏键盘
-(void)hideKeyboard{
    
    [_buyField resignFirstResponder];
}

//移除展示礼物view
-(void)removeView{
    
    [self removeFromSuperview];
}

-(void)choosebtnclick
{
    if ([_buyField.text intValue] * [_money intValue]>=500) {
        self.isChoose = !self.isChoose;
        if (self.isChoose) {
            [self.chooseBtn setImage:[UIImage imageNamed:@"shiguanzhu"] forState:normal];
        }
        else
        {
            [self.chooseBtn setImage:[UIImage imageNamed:@"kongguanzhu"] forState:normal];
        }
    }
}

@end
