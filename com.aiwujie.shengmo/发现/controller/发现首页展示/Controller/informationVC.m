//
//  informationVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "informationVC.h"
#import "infomationCell.h"
#import "announcementModel.h"
#import "LDAlwaysQuestionH5ViewController.h"
#import "LDDynamicDetailViewController.h"
#import "HeaderTabViewController.h"
#import "LDOwnInformationViewController.h"

@interface informationVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)  UICollectionView *collectionView;
@property (nonatomic,strong)  NSMutableArray *dataSource;
@property (nonatomic,assign)  NSInteger page;
@end

static NSString *infomationidentfity = @"infomationidentfity";

@implementation informationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Samer资讯";
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createDatatype:@"1"];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createDatatype:@"2"];
    }];
}

-(void)createDatatype:(NSString *)type
{
    if ([type intValue]==1) {
        [self.dataSource removeAllObjects];
    }
    
    NSString *url = [PICHEADURL stringByAppendingString:getQuestionsListUrl];
    NSDictionary *param = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSArray *data = [NSArray yy_modelArrayWithClass:[announcementModel class] json:responseObj[@"data"]];
            [self.dataSource addObjectsFromArray:data];
            [self.collectionView reloadData];
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    } failed:^(NSString *errorMsg) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = YES;
        flowLayout.itemSize = CGSizeMake(WIDTH/2-2, 60);
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumLineSpacing = 1;
//        //定义每个UICollectionView 横向的间距
        flowLayout.minimumInteritemSpacing = 1;
//        flowLayout.sectionInset = UIEdgeInsetsMake(12, 16*W_screen, 2, 16*W_screen);//上左下右
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[infomationCell class] forCellWithReuseIdentifier:infomationidentfity];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

#pragma mark 每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    infomationCell *cell = (infomationCell*)[collectionView dequeueReusableCellWithReuseIdentifier:infomationidentfity forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    announcementModel *model = self.dataSource[indexPath.row];
    if ([model.url_type intValue]==0) {
        NSString *newid = model.Newid;
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Info/news/id/",newid];
        JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:url];
        webVC.title = @"Samer";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([model.url_type intValue]==1) { //动态
        LDDynamicDetailViewController *vc = [LDDynamicDetailViewController new];
        vc.did = model.url;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([model.url_type intValue]==2) { //话题
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = model.url;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if ([model.url_type intValue]==3) { //主页
        LDOwnInformationViewController *VC = [LDOwnInformationViewController new];
        VC.userID = model.url;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
