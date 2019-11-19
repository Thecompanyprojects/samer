//
//  LDSearchViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSearchViewController.h"
#import "GroupSqureCell.h"
#import "GroupSqureModel.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "LDGroupInformationViewController.h"

@interface LDSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *nearTableView;
@property (nonatomic,strong) NSMutableArray *nearDataArray;

@property (nonatomic,strong) UITableView *hotTableView;
@property (nonatomic,strong) NSMutableArray *hotDataArray;

@property (weak, nonatomic) IBOutlet UIButton *nearButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIView *nearView;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic,assign) int integer;

@property (nonatomic,assign) int nearPage;

@property (nonatomic,assign) int hotPage;

@end

@implementation LDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.content;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, WIDTH, HEIGHT - 110)];
    
    _scrollView.contentSize = CGSizeMake(WIDTH * 2, 0);
    
    _scrollView.delegate = self;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.bounces = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.contentOffset = CGPointZero;
    
    [self.view addSubview:self.scrollView];
    
    _nearPage = 0;
    
    _hotPage = 0;
    
    _nearDataArray = [NSMutableArray array];
    
    _hotDataArray = [NSMutableArray array];
    
    [self createNearTableView];
    
    [self createHotTableView];
    
    [self createData:@"0" state:@"1"];
    
    [self createData:@"1" state:@"1"];
    
    self.nearTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _nearPage = 0;
        
        [self createData:@"0" state:@"1"];
        
    }];
    
    self.nearTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _nearPage++;
        
        [self createData:@"0" state:@"2"];
        
    }];

    
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _hotPage = 0;
        
        [self createData:@"1" state:@"1"];
        
    }];
    
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _hotPage++;
        
        [self createData:@"1" state:@"2"];
        
    }];
    
}
- (IBAction)nearButtonClick:(id)sender {
    
    _nearView.hidden = NO;
    
    _hotView.hidden = YES;
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
}
- (IBAction)hotButtonClick:(id)sender {
    
    _nearView.hidden = YES;
    
    _hotView.hidden = NO;
    
    self.scrollView.contentOffset = CGPointMake(WIDTH, 0);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x >= 0.5 * WIDTH) {
        
        _nearView.hidden = YES;
        
        _hotView.hidden = NO;
        
    }else if (scrollView.contentOffset.x < 0.5 * WIDTH && scrollView.contentOffset.x > 0){
        
        _nearView.hidden = NO;
        
        _hotView.hidden = YES;
    
    }
}

-(void)createHotTableView{

    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) style:UITableViewStyleGrouped];
    
    if (@available(iOS 11.0, *)) {
        
        self.hotTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.hotTableView.delegate = self;
    
    self.hotTableView.dataSource = self;
    
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hotTableView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView addSubview:self.hotTableView];
}

-(void)createData:(NSString *)type state:(NSString *)state{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/searchGroup"];
    
    NSDictionary *parameters;
    
    if ([type intValue] == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_nearPage],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"search":self.content};
            
        }else{
            
           parameters = @{@"page":[NSString stringWithFormat:@"%d",_nearPage],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"search":self.content};
        }
        
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_hotPage],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"search":self.content};
            
        }else{
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_hotPage],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"search":self.content};
        }
        
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        _integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001) {
                
                if ([state intValue] == 1) {
                    
                    if ([type intValue] == 0) {
                        
                        [_nearDataArray removeAllObjects];
                        
                        [self.nearTableView reloadData];
                        
                        self.nearTableView.mj_footer.hidden = YES;
                        
                    }else{
                        
                        [_hotDataArray removeAllObjects];
                        
                        [self.hotTableView reloadData];
                        
                        self.hotTableView.mj_footer.hidden = YES;
                    }
                    
                }else{
                    
                    if ([type intValue] == 0) {
                        
                        [self.nearTableView.mj_footer endRefreshingWithNoMoreData];
                        
                    }else{
                        
                        [self.hotTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                }
                
            }else{
                
                if ([type intValue] == 0) {
                    
                    [self.nearTableView.mj_footer endRefreshing];
                    
                }else{
                    
                    [self.hotTableView.mj_footer endRefreshing];
                    
                }
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
            
        }else{
            
            if ([type intValue] == 0) {
                
                if ([state intValue] == 1) {
                    
                    [_nearDataArray removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObj[@"data"]) {
                    
                    GroupSqureModel *model = [[GroupSqureModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_nearDataArray addObject:model];
                }
                
                self.nearTableView.mj_footer.hidden = NO;
                
                [self.nearTableView reloadData];
                
                [self.nearTableView.mj_footer endRefreshing];
                
            }else{
                
                if ([state intValue] == 1) {
                    
                    [_hotDataArray removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObj[@"data"]) {
                    
                    GroupSqureModel *model = [[GroupSqureModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_hotDataArray addObject:model];
                }
                
                self.hotTableView.mj_footer.hidden = NO;
                
                [self.hotTableView reloadData];
                
                [self.hotTableView.mj_footer endRefreshing];
                
            }
            
        }
        
        [self.nearTableView.mj_header endRefreshing];
        [self.hotTableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.nearTableView.mj_header endRefreshing];
        [self.nearTableView.mj_footer endRefreshing];
        [self.hotTableView.mj_header endRefreshing];
        [self.hotTableView.mj_footer endRefreshing];
    }];
}

-(void)createNearTableView{
    
    self.nearTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 108) style:UITableViewStyleGrouped];
    
    if (@available(iOS 11.0, *)) {
        
        self.nearTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.nearTableView.delegate = self;
    
    self.nearTableView.dataSource = self;
    
    self.nearTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.nearTableView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView addSubview:self.nearTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _nearTableView) {
        
        return _nearDataArray.count;
    }
    
    return _hotDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSqure"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSqureCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == _nearTableView) {
        
        GroupSqureModel *model = _nearDataArray[indexPath.section];
        
        cell.integer = [NSString stringWithFormat:@"%d",_integer];
        
        cell.model = model;
        
    }else{
    
        GroupSqureModel *model = _hotDataArray[indexPath.section];
        
        cell.integer = [NSString stringWithFormat:@"%d",_integer];
        
        cell.model = model;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureModel *model;
    
    if (tableView == _nearTableView) {
        
        model = _nearDataArray[indexPath.section];
        
    }else{
        
        model = _hotDataArray[indexPath.section];
        
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters = @{@"gid":model.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
        }else{
            if ([responseObj[@"data"][@"userpower"] intValue] < 1) {
                LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                ivc.gid = model.gid;
                [self.navigationController pushViewController:ivc animated:YES];
            }else{
                LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                fvc.gid = model.gid;
                [self.navigationController pushViewController:fvc animated:YES];
            }
        }
    } failed:^(NSString *errorMsg) {
        
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
