//
//  LDDiscoverViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDDiscoverViewController.h"
#import "LDAlwaysQuestionH5ViewController.h"
#import "LDModalH5ViewController.h"
#import "LDStandardViewController.h"
#import "LDHelpCenterViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "PersonChatViewController.h"
#import "LDCertificateViewController.h"
#import "LDBulletinViewController.h"
#import "LDMapViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDShengMoViewController.h"
#import "ShowBadgeCell.h"
#import "LDMatchmakerViewController.h"
#import "LDAboutShengMoViewController.h"
#import "LDSoundControlViewController.h"
#import "HeaderTabViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDCertificatePageVC.h"
#import "announcementVC.h"
#import "informationVC.h"
#import "announcementModel.h"


#define NewUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.3]

@interface LDDiscoverViewController ()<SDCycleScrollViewDelegate>

//九宫格的图片名称数组
@property (nonatomic,strong) NSArray *dataArray;

//话题的数组
@property (nonatomic,strong) NSMutableArray *topicArray;

//广告展示的数组数据
@property (nonatomic,strong) UIView *advView;
@property (nonatomic,strong) NSMutableArray *slideArray;

//定位
@property (nonatomic,strong) CLLocationManager *locationManager;
//底部滚动的scrollView
@property (nonatomic,strong) UIScrollView * scrollView;
//客服的数组
@property (nonatomic,strong) NSMutableArray *serviceArray;
//官方公告的数组
@property (nonatomic,strong) NSMutableArray *viewTitleArray;
//常见问题的数组
@property (nonatomic,strong) NSMutableArray *viewTitleArray1;
@property (nonatomic,copy) NSString *toptitle;
@property (nonatomic,copy) NSString *topurl;
@property (nonatomic,strong) announcementModel *anmodel;
@end

@implementation LDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"绿色斯慕",@"志愿者",@"全职招聘",@"关于圣魔",@"圣魔文化节",@"创始人"];
    _topicArray = [NSMutableArray array];
    _serviceArray = [NSMutableArray array];
    _slideArray = [NSMutableArray array];
    //判断视图顶部是否有广告栏
    [self createHeadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspenshowView) name:SUPVIEWNOTIFICATION object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[LDFromwebManager defaultTool] createDataLat];
    [self vhl_setNavBarShadowImageHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self vhl_setNavBarShadowImageHidden:NO];
}

/**
 * 判断视图顶部是否有广告栏
 */
-(void)createHeadData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getSlideMoreUrl];
    NSDictionary *parameters = @{@"type":@"3"};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            [_slideArray addObjectsFromArray:responseObj[@"data"]];
        }
        //获取客服的数据
        [self createServiceData];
    } failed:^(NSString *errorMsg) {
        //获取客服的数据
        [self createServiceData];
    }];
}

/**
 * 获取客服的数据
 */
-(void)createServiceData{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Index/getServiceInfo"];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            [_serviceArray addObjectsFromArray:responseObj[@"data"]];
            [self createPublishGood];
        }else{
            [self createPublishGood];
        }
    } failed:^(NSString *errorMsg) {
         [self createPublishGood];
    }];
}

/**
 * 搭建首页展示的视图
 */
-(void)createPublishGood{
    
    if (_scrollView != nil) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    //创建底层的滑动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    _scrollView.showsVerticalScrollIndicator = NO;

    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"edebf1" alpha:1];
    if (_slideArray.count == 0) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        [_scrollView addSubview:headView];
        //创建9宫格
        [self createGridView:headView];
        
    }else{
        
        CGFloat headRatio = 0.4;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * headRatio)];
        [_scrollView addSubview:headView];
        NSMutableArray *pathArray = [NSMutableArray array];
        
        for (NSDictionary *dic in _slideArray) {
            
            [pathArray addObject:dic[@"path"]];
        }
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, headView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.imageURLStringsGroup = pathArray;
        cycleScrollView.autoScrollTimeInterval = 3.0;
        [headView addSubview:cycleScrollView];
        
        //创建9宫格
        [self createGridView:headView];
    }
}

/**
 点击广告图片回调

 @param cycleScrollView 广告图片
 @param index 广告index
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //link_type 0:url,1:话题,2:动态,3:主页,
    if ([self.slideArray[index][@"link_type"] intValue] == 0) {
        NSString *newURL = [NSString stringWithFormat:@"%@?uid=%@",self.slideArray[index][@"url"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
        LDWebVC *webVC = [[LDWebVC alloc] initWithURLString:newURL];
        webVC.title = self.slideArray[index][@"title"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([self.slideArray[index][@"link_type"] intValue] == 1) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",self.slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([self.slideArray[index][@"link_type"] intValue] == 2) {
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = [NSString stringWithFormat:@"%@",self.slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([self.slideArray[index][@"link_type"] intValue] == 3) {
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = [NSString stringWithFormat:@"%@",self.slideArray[index][@"link_id"]];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

/**
 * 创建九宫格
 */
-(void)createGridView:(UIView *)headImageView{
    
    __block CGFloat tophei = 0.00f;
    NSString *url = [PICHEADURL stringByAppendingString:topnewUrl];
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            tophei = 36;
            self.anmodel = [announcementModel yy_modelWithDictionary:data];
            self.toptitle = self.anmodel.title;
            
            UILabel *pointView = [[UILabel alloc] init];
            pointView.text = @"●";
            pointView.font = [UIFont systemFontOfSize:8];
            pointView.textColor = MainColor;
            pointView.frame = CGRectMake(15, CGRectGetMaxY(headImageView.frame)+6, 14, 36);
            [_scrollView addSubview:pointView];
            
            UILabel *messageLab = [[UILabel alloc] init];
            messageLab.frame = CGRectMake(15+8, CGRectGetMaxY(headImageView.frame)+6, WIDTH-30, 36);
            [_scrollView addSubview:messageLab];
            messageLab.textAlignment = NSTextAlignmentCenter;
            messageLab.backgroundColor = [UIColor whiteColor];
            messageLab.text = [NSString stringWithFormat:@"%@%@",@"",self.toptitle];
            messageLab.font = [UIFont systemFontOfSize:20];
            messageLab.textColor = MainColor;
            messageLab.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside)];
            [messageLab addGestureRecognizer:labelTapGestureRecognizer];
            [self createcollview:headImageView andtophei:tophei];
        }
        else
        {
            tophei = 0.00f;
            [self createcollview:headImageView andtophei:tophei];
        }
    } failed:^(NSString *errorMsg) {
        tophei = 0.00f;
        [self createcollview:headImageView andtophei:tophei];
    }];
}

-(void)createcollview:(UIView *)heiview andtophei:(CGFloat )tophei
{
    //大间距
    CGFloat bigSpace = 0;
    //方块总数
    CGFloat totleNum = 8;
    //每行的个数
    int number = 4;
    //每个小块的间距
    CGFloat space = 0;
    //每个小块的宽
    CGFloat itemW = (WIDTH)/4;
    //每个小块的高
    CGFloat itemH = (WIDTH-25)/4;
    //存储最后一个item的最大y值
    CGFloat lastItemY;

    NSArray *itemArray = @[@"gongyi1",@"gongyi2",@"gongyi3",@"gongyi7",@"gongyi5",@"gongyi6",@"bangzhu",@"gongyi8"];
    NSArray *titleArray = @[@"严格审核",@"爱无界公益",@"检测预约",@"全职招聘",@"关于我们",@"创始人",@"帮助中心",@"官方网站"];
    for (int i = 0; i < totleNum; i++) {
        
        //每个模块的在第几列
        int itemX = i%number;
        //每个模块在第几行
        int itemY = i/number;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(itemX * space + itemX * itemW, (CGRectGetMaxY(heiview.frame)+tophei + bigSpace + itemY * (itemH-25) + itemY *space), itemW, itemH-25)];
        backView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
        [_scrollView addSubview:backView];

        //展示9宫格的图片
        
        UIImageView *itemImageView = [[UIImageView alloc] init];
        itemImageView.image = [UIImage imageNamed:itemArray[i]];
        [backView addSubview:itemImageView];
        itemImageView.alpha = 0.8;
        [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(backView).with.offset(15);
            make.width.mas_offset(itemH-60);
            make.height.mas_offset(itemH-60);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        [backView addSubview:titleLab];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = [UIColor lightGrayColor];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(itemImageView.mas_bottom).with.offset(5);
            make.height.mas_offset(15);
        }];
        
        titleLab.text = [titleArray objectAtIndex:i];
        
        //添加按钮使其可点击
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = 10 + i;
        [backView addSubview:itemButton];
        
        if (i == totleNum - 1) {
            lastItemY = CGRectGetMaxY(backView.frame);
            //创建话题的view
            [self createTopicView:lastItemY andBigSpace:bigSpace];
        }
    }
}

/**
 * 创建话题的view
 */
-(void)createTopicView:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace{
    
    NSDictionary *parameters = @{@"pid":@"7"};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/getTopicEight"];
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            //创建一些介绍的view
            [self createIntrofuceView:lastItemY andBigSpace:bigSpace];
            
        }else {
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                [_topicArray addObject:dic];
            }
            CGFloat btnX = 5;
            UIScrollView *topicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lastItemY + bigSpace, WIDTH, 44+6)];
            topicScrollView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];;
            topicScrollView.showsHorizontalScrollIndicator = NO;
            [_scrollView addSubview:topicScrollView];
            UIImageView *recommendView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 30, 30)];
            recommendView.image = [UIImage imageNamed:@"官方话题"];
            [topicScrollView addSubview:recommendView];
            
            for (int i = 0; i < [_topicArray count]; i++) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                [btn setTitle:[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"0xb73acb" alpha:0.8];
                [btn setTitleColor:[UIColor whiteColor] forState:normal];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 14;
                
                btn.tag = 100 + i;
                [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //重要的是下面这部分哦！
                CGSize titleSize = [[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
                
                titleSize.height = 44;
                titleSize.width += 20;

                btn.frame = CGRectMake(btnX + 40, 9, titleSize.width, 30);
                btnX = btnX + titleSize.width+6;
                
                if (i == [responseObj[@"data"] count] - 1) {
                    topicScrollView.contentSize = CGSizeMake(btnX + 10 + 40, 44);
                    //创建一些介绍的view
                    [self createIntrofuceView:CGRectGetMaxY(topicScrollView.frame) andBigSpace:bigSpace];
                }
                [topicScrollView addSubview:btn];
            }
        }
    } failed:^(NSString *errorMsg) {
        //创建一些介绍的view
        [self createIntrofuceView:lastItemY andBigSpace:bigSpace];
    }];
}

/**
 * 创建官方公告,常见问题的view
 */
-(void)createIntrofuceView:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace{

    UIView *introduceView = [[UIView alloc] init];
    introduceView.hidden = YES;
    [_scrollView addSubview:introduceView];
    
    CGFloat viewInSpaceX = 15;
    CGFloat viewInSpaceY = 8;
    CGFloat picH = 80;
    CGFloat picW = 120;
    CGFloat viewH = 2 * viewInSpaceY + picH;
    CGFloat viewSpace = 1;
    
    UILabel *rightLab = [[UILabel alloc] init];
    [introduceView addSubview:rightLab];
    rightLab.textColor = MainColor;
    rightLab.frame = CGRectMake(15, viewSpace-2, WIDTH-40, 30);
    rightLab.font = [UIFont systemFontOfSize:15];
    rightLab.text = @"更多";
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.userInteractionEnabled=YES;

    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gonggaoClick)];
    [rightLab addGestureRecognizer:labelTapGestureRecognizer2];

    UILabel *leftLab = [[UILabel alloc] init];
    [introduceView addSubview:leftLab];
    leftLab.frame = CGRectMake(15, viewSpace-2, 100, 30);
    leftLab.textColor = TextCOLOR;
    leftLab.font = [UIFont systemFontOfSize:15];
    leftLab.text = @"爱无界公益";

    UIImageView *rightImg = [[UIImageView alloc] init];
    [introduceView addSubview:rightImg];
    rightImg.image = [UIImage imageNamed:@"又箭头紫色"];
    rightImg.frame = CGRectMake(WIDTH-26, viewSpace+8-2, 14, 14);
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Index/getBasicNews"];
    
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [self createAlwaysQuestionWithView:introduceView andViewH:viewH andViewMaxY:0 andViewSpace:viewSpace andViewInSpaceX:viewInSpaceX andLastItemY:lastItemY andBigSpace:bigSpace andHaveData:NO];
            
        }else {
            
            _viewTitleArray = [NSMutableArray array];
            
            [_viewTitleArray addObjectsFromArray:responseObj[@"data"]];
            
            NSInteger num1 = _viewTitleArray.count;
            
            CGFloat viewMaxY = 0;
            
            for (int i = 0; i < num1; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i * viewH + i * viewSpace+28, WIDTH, viewH)];
                view.backgroundColor = [UIColor whiteColor];
                
                UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - picW - viewInSpaceX, viewInSpaceY, picW, picH)];
                [pic sd_setImageWithURL:[NSURL URLWithString:_viewTitleArray[i][@"pic"]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
                [view addSubview:pic];
                
                UILabel *dogLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewInSpaceX, 0, viewInSpaceX, viewH)];
                dogLabel.text = @"●";
                dogLabel.font = [UIFont systemFontOfSize:8];
                dogLabel.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
                [view addSubview:dogLabel];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * viewInSpaceX - 5, viewInSpaceY, WIDTH - 4 * viewInSpaceX + 5 - picW, viewH - 2 * viewInSpaceY)];
                label.text = _viewTitleArray[i][@"title"];
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = TextCOLOR;
                [view addSubview:label];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                button.tag = 100 + i;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
                [introduceView addSubview:view];
                
                if (i == num1 - 1) {
                    
                    viewMaxY = CGRectGetMaxY(view.frame)+30;
                    
                    [self createAlwaysQuestionWithView:introduceView andViewH:viewH andViewMaxY:viewMaxY andViewSpace:viewSpace andViewInSpaceX:viewInSpaceX andLastItemY:lastItemY andBigSpace:bigSpace andHaveData:YES];
                }
            }
            
        UILabel *rightLab = [[UILabel alloc] init];
        [introduceView addSubview:rightLab];
        rightLab.frame = CGRectMake(15, viewMaxY-30, WIDTH-40, 30);
        rightLab.textColor = MainColor;
        rightLab.font = [UIFont systemFontOfSize:15];
        rightLab.text = @"更多";
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wentiClick)];
        [rightLab addGestureRecognizer:labelTapGestureRecognizer];
        UILabel *leftLab = [[UILabel alloc] init];
        [introduceView addSubview:leftLab];
        leftLab.frame = CGRectMake(15, viewMaxY-30, 100, 30);
        leftLab.textColor = TextCOLOR;
        leftLab.font = [UIFont systemFontOfSize:15];
        leftLab.text = @"Samer资讯";
        
        UIImageView *rightImg = [[UIImageView alloc] init];
        [introduceView addSubview:rightImg];
        rightImg.image = [UIImage imageNamed:@"又箭头紫色"];
        rightImg.frame = CGRectMake(WIDTH-26, viewMaxY-30+8, 14, 14);
            
      }
    } failed:^(NSString *errorMsg) {
         [self createAlwaysQuestionWithView:introduceView andViewH:viewH andViewMaxY:0 andViewSpace:viewSpace andViewInSpaceX:viewInSpaceX andLastItemY:lastItemY andBigSpace:bigSpace andHaveData:NO];
    }];
}

/**
 * 创建常见问题
 */
-(void)createAlwaysQuestionWithView:(UIView *)introduceView andViewH:(CGFloat)viewH andViewMaxY:(CGFloat)viewMaxY andViewSpace:(CGFloat)viewSpace andViewInSpaceX:(CGFloat)viewInSpaceX andLastItemY:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace andHaveData:(BOOL)isHave{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Index/getSamerNews"];
    
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            introduceView.hidden = NO;
            
            if (isHave) {
                
                introduceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, viewMaxY);
                
            }else{
                
                introduceView.frame = CGRectMake(0, lastItemY, WIDTH, 0);
                
            }
            
            //创建客服的view
            [self createServiceView:CGRectGetMaxY(introduceView.frame) andBigSpace:bigSpace];
            
        }else {
            
            introduceView.hidden = NO;
            
            _viewTitleArray1 = [NSMutableArray array];
            
            [_viewTitleArray1 addObjectsFromArray:responseObj[@"data"]];
            
            NSInteger num2 = _viewTitleArray1.count;
            
            CGFloat viewItemW = (WIDTH - 1)/2;
            CGFloat viewItemH = viewH/2 + 10;
            CGFloat view2MaxY = 0;
            
            for (int j = 0; j < num2; j++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(j%2 * viewItemW + j%2 * viewSpace, viewMaxY + viewSpace + j/2 * viewItemH + j/2 * viewSpace, viewItemW, viewItemH)];
                view.backgroundColor = [UIColor whiteColor];
                
                UILabel *dogLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewInSpaceX, 0, viewInSpaceX, viewItemH)];
                dogLabel.text = @"●";
                dogLabel.font = [UIFont systemFontOfSize:8];
                dogLabel.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
                [view addSubview:dogLabel];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * viewInSpaceX - 5, 0, viewItemW - 3 * viewInSpaceX + 5, viewItemH)];
                label.text = _viewTitleArray1[j][@"title"];
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = TextCOLOR;
                [view addSubview:label];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                button.tag = 200 + j;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
                [introduceView addSubview:view];
                
                if (j == num2 - 1) {
                    
                    view2MaxY = CGRectGetMaxY(view.frame)+10;
                }
            }
            
            introduceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, view2MaxY);
            
//            UILabel *leftLab = [[UILabel alloc] init];
//            [introduceView addSubview:leftLab];
//            leftLab.frame = CGRectMake(15, view2MaxY-30, WIDTH-36, 30);
//            leftLab.textColor = MainColor;
//            leftLab.font = [UIFont systemFontOfSize:15];
//            leftLab.text = @"更多资讯";
//            leftLab.textAlignment = NSTextAlignmentRight;
//            leftLab.userInteractionEnabled=YES;
//            UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wentiClick)];
//            [leftLab addGestureRecognizer:labelTapGestureRecognizer];
//
//            UIImageView *rightImg = [[UIImageView alloc] init];
//            [introduceView addSubview:rightImg];
//            rightImg.image = [UIImage imageNamed:@"又箭头紫色"];
//            rightImg.frame = CGRectMake(WIDTH-20, view2MaxY-30+8, 14, 14);
            
            //创建客服的view
            [self createServiceView:CGRectGetMaxY(introduceView.frame) andBigSpace:bigSpace];
        }
        
    } failed:^(NSString *errorMsg) {
        introduceView.hidden = NO;
        if (isHave) {
            introduceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, viewMaxY);
        }else{
            introduceView.frame = CGRectMake(0, lastItemY, WIDTH, 0);
        }
        //创建客服的view
        [self createServiceView:CGRectGetMaxY(introduceView.frame) andBigSpace:bigSpace];
    }];
}

/**
 * 官方公告,常见问题点击
 */
-(void)buttonClick:(UIButton *)button{
    
    NSString *url = [NSString new];
    NSString *url_type = [NSString new];
    NSString *new_url = [NSString new];
    NSString *newUid = [NSString new];
    if (button.tag >= 100 && button.tag < 200) {
        
        if ([_viewTitleArray[button.tag - 100][@"url"] length] == 0) {
            
            url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",_viewTitleArray[button.tag - 100][@"id"]];
    
            url_type = [NSString stringWithFormat:@"%@",_viewTitleArray[button.tag-100][@"url_type"]];
            new_url = [NSString stringWithFormat:@"%@",_viewTitleArray[button.tag-100][@"url"]];
            newUid =  [NSString stringWithFormat:@"%@",_viewTitleArray[button.tag-100][@"id"]];
            
        }else{
            
            url = _viewTitleArray[button.tag - 100][@"url"];

            url_type = [NSString stringWithFormat:@"%@",_viewTitleArray[button.tag-100][@"url_type"]];
            new_url = [NSString stringWithFormat:@"%@",_viewTitleArray[button.tag-100][@"url"]];
            newUid =  [NSString stringWithFormat:@"%@",_viewTitleArray[button.tag-100][@"id"]];
        }
        
    }else{
        
        if ([_viewTitleArray1[button.tag - 200][@"url"] length] == 0) {
            
            url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",_viewTitleArray1[button.tag - 200][@"id"]];

            url_type = [NSString stringWithFormat:@"%@",_viewTitleArray1[button.tag-200][@"url_type"]];
            new_url = [NSString stringWithFormat:@"%@",_viewTitleArray1[button.tag-200][@"url"]];
            newUid =  [NSString stringWithFormat:@"%@",_viewTitleArray1[button.tag-200][@"id"]];
        }else{
            
            url = _viewTitleArray1[button.tag - 200][@"url"];

            url_type = [NSString stringWithFormat:@"%@",_viewTitleArray1[button.tag-200][@"url_type"]];
            new_url = [NSString stringWithFormat:@"%@",_viewTitleArray1[button.tag-200][@"url"]];
            newUid =  [NSString stringWithFormat:@"%@",_viewTitleArray1[button.tag-200][@"id"]];
        }
    }
    if ([url_type intValue]==0) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",newUid];
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"Samer";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([url_type intValue]==1) { //动态
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = new_url;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([url_type intValue]==2) { //话题
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = new_url;;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([url_type intValue]==3) { //主页
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = new_url;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

/**
 * 点击话题文字的响应事件
 */
-(void)btnButtonClick:(UIButton *)button{
    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    tvc.tid = [NSString stringWithFormat:@"%@",_topicArray[button.tag%100][@"tid"]];
    [self.navigationController pushViewController:tvc animated:YES];
}

/**
 * 点击九宫格按钮的响应事件
 */
-(void)itemButtonClick:(UIButton *)button{
    
    if (button.tag == 10) {
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Home/info/greensm"];
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"严格审核";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (button.tag == 11){
        NSString *url = @"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/16";
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"爱无界公益";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (button.tag == 12){
        NSString *url = @"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/18";
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"检测预约";
        [self.navigationController pushViewController:webVC animated:YES];
   
    }else if (button.tag == 13){
        NSString *url = @"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/14";
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"全职招聘";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (button.tag == 14){
        NSString *url = @"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/15";
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"关于我们";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (button.tag == 15){
        NSString *url = @"http://hao.aiwujie.net/Home/Info/Shengmosimu/id/17";
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"创始人";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (button.tag == 16){
        LDHelpCenterViewController *vc = [[LDHelpCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (button.tag == 17){
        NSString *url = @"http://www.aiwujie.net";
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"官方网站";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 头条广告跳转
 */
-(void)labelTouchUpInside
{
    if ([self.anmodel.url_type intValue]==0) {
        NSString *url = self.anmodel.url;
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = self.anmodel.title;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([self.anmodel.url_type intValue]==1) {
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = [NSString stringWithFormat:@"%@",self.anmodel.url];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([self.anmodel.url_type intValue]==2) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",self.anmodel.url];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([self.anmodel.url_type intValue]==3) {
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = [NSString stringWithFormat:@"%@",self.anmodel.url];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

/**
 * 创建客服模块
 */
-(void)createServiceView:(CGFloat)lastItemY andBigSpace:(CGFloat)bigSpace{

    UIView *serviceView = [[UIView alloc] init];
    serviceView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:serviceView];

    //客服个数
    int serviceNum = 4;
    //客服之间的间距
    CGFloat space = 20;
    //左边距
    CGFloat leftSpace = 30;
    //按钮大小
    CGFloat serviceW = (WIDTH - 2 * leftSpace - (serviceNum - 1) * space)/serviceNum;
    CGFloat serviceH = serviceW;
    //距离按钮的y值
    CGFloat serviceY = 13;
    
    for (int i = 0; i < serviceNum; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(leftSpace + serviceW * i + space * i, serviceY, serviceW, serviceH)];
        button.layer.cornerRadius = serviceW/2;
        button.clipsToBounds = YES;
        button.tag = 20 + i;
        [button addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i + 1 <= _serviceArray.count) {
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_serviceArray[i][@"head_pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"红娘未知图片"]];
            
        }else{
            
            [button setBackgroundImage:[UIImage imageNamed:@"红娘未知图片"] forState:UIControlStateNormal];
            
        }
    
        [serviceView addSubview:button];
        
        UIImageView *vipView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x + serviceW - 20,button.frame.origin.y + serviceW - 20, 20, 20)];
        vipView.image = [UIImage imageNamed:@"官方认证"];
        [serviceView addSubview:vipView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + serviceW * i + space * i, CGRectGetMaxY(button.frame) + 2, serviceW, 16)];
        
        if (i + 1 <= _serviceArray.count) {
            
            label.text = _serviceArray[i][@"nickname"];
            
        }else{
            
            label.text = @"斯慕客服";
        }
        
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
        label.textAlignment = NSTextAlignmentCenter;
        [serviceView addSubview:label];
        
        if (i == serviceNum - 1) {
            
            UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 13, WIDTH - 20, 30)];
            contactView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
            contactView.layer.cornerRadius = 2;
            contactView.clipsToBounds = YES;
            [serviceView addSubview:contactView];
            
            NSArray *contactArray = @[@"公益微信QQ",@"公益座机",@"公益手机号"];

            //图片的比例
            CGFloat contactP = 0.18;
            //联系方式view的width
            CGFloat contactW = contactView.frame.size.width;
            //联系方式view的height
            CGFloat contactH = contactView.frame.size.height;
            //距离左边界的距离
            CGFloat contactLeftX = 10;
            //每个联系方式的距离
            CGFloat contactSpace = 5;
            //每个联系方式的width
            CGFloat contactButtonW = (contactW - 2 * contactLeftX - (contactArray.count - 1) * contactSpace)/3;
            
            for (int j = 0; j < contactArray.count; j++) {
                
                UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(contactLeftX + j * contactSpace + j * contactButtonW, (contactH - contactButtonW * contactP)/2, contactButtonW, contactButtonW * contactP)];
                contactButton.tag = 100 + j;
                [contactButton setBackgroundImage:[UIImage imageNamed:contactArray[j]] forState:UIControlStateNormal];
                [contactButton addTarget:self action:@selector(contactButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [contactView addSubview:contactButton];
                
            }
            
            UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contactView.frame) + 13, WIDTH, 15)];
            warnLabel.alpha = 0.5;
            warnLabel.text = @"中国多元人群健康公益交流平台";
            warnLabel.textColor = UIColorFromRGB(strtoul([@"0x707070" UTF8String], 0, 0));
            warnLabel.textAlignment = NSTextAlignmentCenter;
            warnLabel.font = [UIFont systemFontOfSize:12];
            [serviceView addSubview:warnLabel];
            
            UILabel *warnLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(warnLabel.frame) + 10, WIDTH, 15)];
            warnLabel1.alpha = 0.5;
            warnLabel1.text = @"北京市通州区疾控中心合作单位";
            warnLabel1.textColor = UIColorFromRGB(strtoul([@"0x707070" UTF8String], 0, 0));
            warnLabel1.textAlignment = NSTextAlignmentCenter;
            warnLabel1.font = [UIFont systemFontOfSize:12];
            [serviceView addSubview:warnLabel1];
            
            UILabel *otherWarnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(warnLabel1.frame) + 8, WIDTH, 15)];
            otherWarnLabel.alpha = 0.5;
            otherWarnLabel.text = @"京ICP备:16047950号  京公网安备:11010502034234";
            otherWarnLabel.textColor = UIColorFromRGB(strtoul([@"0x707070" UTF8String], 0, 0));
            otherWarnLabel.textAlignment = NSTextAlignmentCenter;
            otherWarnLabel.font = [UIFont systemFontOfSize:12];
            [serviceView addSubview:otherWarnLabel];
            
            serviceView.frame = CGRectMake(0, lastItemY + bigSpace, WIDTH, CGRectGetMaxY(otherWarnLabel.frame) + 60);
            
            _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(serviceView.frame));
        }
    }
}

/**
 * 点击客服按钮与客服聊天
 */
-(void)serviceButtonClick:(UIButton *)button{
    if (button.tag - 19 <= _serviceArray.count) {
        LDOwnInformationViewController *InfoVC = [LDOwnInformationViewController new];
        InfoVC.userID = [NSString stringWithFormat:@"%@",_serviceArray[button.tag - 20][@"uid"]];
        [self.navigationController pushViewController:InfoVC animated:YES];
    }else{
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"客服未在线,请选择其他客服或电话联系我们~"];
    }
}

/**
 * 点击联系方式按钮的响应事件
 */
-(void)contactButtonClick:(UIButton *)button{
    
    if (button.tag == 101) {
        
        WKWebView *webView = [[WKWebView alloc]init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"010-56405100"]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
        
    }else if (button.tag == 102){
    
        WKWebView *webView = [[WKWebView alloc]init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"13436537298"]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
    }
}


-(void)gonggaoClick
{
    announcementVC *VC = [[announcementVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)wentiClick
{
    informationVC *VC = [[informationVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)suspenshowView
{
    int index =  (int)[self.tabBarController selectedIndex];
    if (index==0) {
        ChatroomVC *vc = [ChatroomVC new];
        vc.roomidStr = roomidStr.copy;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
