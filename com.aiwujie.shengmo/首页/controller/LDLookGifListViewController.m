//
//  LDLookGifListViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/7/6.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDLookGifListViewController.h"
#import "MyWalletCell.h"
#import "MyWalletModel.h"

@interface LDLookGifListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//首页tableview和collectView及数据源
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectArray;

@end

@implementation LDLookGifListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"礼物列表";
    
    [self createCollectionView];
    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//
//    // bg.png为自己ps出来的想要的背景颜色。
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:[UIImage new]];
    
    _collectArray = [NSMutableArray array];
    
    [self createData];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self vhl_setNavBarBackgroundColor:[UIColor colorWithHexString:@"B73ACB" alpha:1]];
}

//创建collectionView
-(void)createCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) collectionViewLayout:layout];
    
    if (@available(iOS 11.0, *)) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 1, 2);
    
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if (HEIGHT == 667){
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((int)(WIDTH - 8)/3,120);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 2;
        
    }else{
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((WIDTH - 8)/3,120);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 2;
        
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.delegate =  self;
    
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyWalletCell" bundle:nil] forCellWithReuseIdentifier:@"MyWallet"];
    
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_collectArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MyWalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyWallet" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyWalletCell" owner:self options:nil].lastObject;
    }
    
    if (_collectArray.count > 0) {
        
        MyWalletModel *model = _collectArray[indexPath.row];
        
        cell.model = model;
        
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    cell.gifNameLabel.textColor = [UIColor whiteColor];
    
    cell.gifNumLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

//请求首页数据源
-(void)createData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getMyPresentUrl];
    NSDictionary *parameters = @{@"uid":self.userId};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                [_collectArray removeAllObjects];
                
                [_collectionView reloadData];
                
            }else{
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
            
        }else{
            
            NSArray *amountArray = @[@"7",@"35",@"70",@"350",@"520",@"700",@"1888",@"2888",@"3888",@"2",@"6",@"10",@"38",@"99",@"88",@"123",@"166",@"199",@"520",@"666",@"250",@"777",@"888",@"999",@"1314",@"1666",@"1999",@"666",@"999",@"1888",@"2899",@"3899",@"6888",@"9888",@"52000",@"99999",@"1",@"3",@"5",@"10",@"8"];
            
            //对数组进行排序
            NSArray *result = [responseObj[@"data"][@"giftArr"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                int number1;
                int number2;
                
                if (amountArray.count >= [obj1[@"type"] intValue]) {
                    
                    number1 = [amountArray[[obj1[@"type"] intValue] - 1] intValue];
                    
                }else{
                    
                    number1 = 0;
                }
                
                if (amountArray.count >= [obj2[@"type"] intValue]) {
                    
                    number2 = [amountArray[[obj2[@"type"] intValue] - 1] intValue];
                    
                }else{
                    
                    number2 = 0;
                }
                
                if (number1 > number2) {
                    
                    return (NSComparisonResult)NSOrderedAscending;
                    
                }else if (number1 < number2){
                    
                    return (NSComparisonResult)NSOrderedDescending
                    ;
                }else{
                    
                    return (NSComparisonResult)NSOrderedSame
                    ;
                }
            }];
            for (NSDictionary *dic in result) {
                MyWalletModel *model = [[MyWalletModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_collectArray addObject:model];
            }
            
            [self.collectionView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
