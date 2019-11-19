//
//  LDMatchmakerPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMatchmakerPageViewController.h"
#import "LDMatchmasterDetailViewController.h"
#import "MatchmakerCell.h"
#import "MatchmakerModel.h"

@interface LDMatchmakerPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) UILabel *mobileLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectArray;
@property (nonatomic,assign) int collectPage;
//保存最初的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;
@end

@implementation LDMatchmakerPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.content intValue] == 0) {
        
//        [self setupIntroduce];
        WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 50)];
        web.scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Home/Info/hongniang"]]];
        [web loadRequest:request];
        [self.view addSubview:web];
    }else{
        self.collectArray = [NSMutableArray array];
        [self setUpCollectionView];
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _collectPage = 0;
            [self createDataType:@"1"];
        }];
        
        [self.collectionView.mj_header beginRefreshing];
        
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _collectPage++;
            [self createDataType:@"2"];
        }];
    }
    
    //起始偏移量为0
    self.lastScrollOffset = 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.lastScrollOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + HEIGHT < scrollView.contentSize.height) {
        
        CGFloat y = scrollView.contentOffset.y;
        
        if (y >= self.lastScrollOffset) {
            //用户往上拖动，也就是屏幕内容向下滚动
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"红娘申请按钮隐藏" object:nil];
            
        } else if(y < self.lastScrollOffset){
            //用户往下拖动，也就是屏幕内容向上滚动
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"红娘申请按钮显示" object:nil];
        }
        
    }
}

-(void)createDataType:(NSString *)type{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Matchmaker/getMatchUsersList"];
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_collectPage],@"sex":[NSString stringWithFormat:@"%d",[self.content intValue] - 1]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            if (integer == 3000 || integer == 3001) {
                
                if ([type intValue] == 1) {
                    [self.collectArray removeAllObjects];
                    [self.collectionView reloadData];
                    self.collectionView.mj_footer.hidden = YES;
                }else{
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            
            if ([type intValue] == 1) {
                [self.collectArray removeAllObjects];
                [self.collectionView reloadData];
            }
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[MatchmakerModel class] json:responseObj[@"data"]]];
            [self.collectArray addObjectsFromArray:data];
            self.collectionView.mj_footer.hidden = NO;
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
            
        }
        
        [self.collectionView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];

}

//创建collectionView,展示斯慕才俊和斯慕佳丽界面
-(void)setUpCollectionView{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, [self getIsIphoneX:ISIPHONEX] - 50) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    layout.itemSize = CGSizeMake((WIDTH - 30)/2,(WIDTH - 30)/2 + 45);
    // 设置最小行间距
    layout.minimumLineSpacing = 10;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 10;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate =  self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MatchmakerCell" bundle:nil] forCellWithReuseIdentifier:@"Matchmaker"];
    [self.view addSubview:self.collectionView];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectArray.count?:0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MatchmakerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Matchmaker" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MatchmakerCell" owner:self options:nil].lastObject;
    }
    MatchmakerModel *model = self.collectArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    LDMatchmasterDetailViewController *dvc = [[LDMatchmasterDetailViewController alloc] init];
    MatchmakerModel *model = _collectArray[indexPath.row];
    dvc.userId = model.uid;
    dvc.title = model.match_num;
    [self.navigationController pushViewController:dvc animated:YES];
}

//创建服务介绍界面
-(void)setupIntroduce{
    
    CGFloat backH;

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    backView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:backView];
    
    backH = backView.frame.size.height;
    
    //创建拨打座机的图片,电话号,点击事件
    UIImageView *mobileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3 - 4, backH/4 + 2, backH/4 - 4 , backH/4 - 4)];
    mobileImageView.image = [UIImage imageNamed:@"座机电话"];
    [backView addSubview:mobileImageView];
    
    _mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3 + (backH/4 - 4) + 1, backH/4 + 2, WIDTH/3 - (backH/4 - 4), backH/4 - 4)];
    _mobileLabel.text = @"010-56405100";
    _mobileLabel.font = [UIFont systemFontOfSize:12];
    _mobileLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [backView addSubview:_mobileLabel];
    
    UIButton *mobileButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3, backH/4, WIDTH/3, backH/4)];
    [mobileButton addTarget:self action:@selector(mobileButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mobileButton];
    
    //创建拨打手机的图片,电话号,点击事件
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3 - 4, backH/2 + 2, backH/4 - 4, backH/4 - 4)];
    phoneImageView.image = [UIImage imageNamed:@"手机电话"];
    [backView addSubview:phoneImageView];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3 + (backH/4 - 4) + 1, backH/2 + 2, WIDTH/3 - (backH/4 - 4), backH/4 - 4)];
    _phoneLabel.text = @"13436537298";
    _phoneLabel.font = [UIFont systemFontOfSize:12];
    _phoneLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [backView addSubview:_phoneLabel];
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3, backH/2, WIDTH/3, backH/4)];
    [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:phoneButton];
    
    //创建中间的分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - WIDTH/3 - 15, backH/4, 1, backH/2)];
    lineView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:lineView];
    
    CGFloat surplusW;
    
    surplusW = WIDTH - WIDTH/3 - 15;
    
    //创建红娘的按钮
    
    NSArray *nameArray = @[@"红娘小魔",@"红娘小斯",@"红娘小慕"];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((surplusW - 44 * 3)/4 + (surplusW - 44 * 3)/4 * i + 44 * i, 10, 44, 44)];
        [button setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
        [backView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( (surplusW - 44 * 3)/8 + (surplusW - 44 * 3)/4 * i + 44 * i, 58, 44 + (surplusW - 44 * 3)/4, 16)];
        label.text = nameArray[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
    }
    
}

-(void)mobileButtonClick{

    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mobileLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

-(void)phoneButtonClick{

    WKWebView *webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
