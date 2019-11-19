//
//  LDGroupSearchSignViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/3.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupSearchSignViewController.h"
#import "LDSearchViewController.h"
#import "GroupSearchCell.h"

@interface LDGroupSearchSignViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation LDGroupSearchSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"搜索群组";
    
    _dataArray = [NSMutableArray array];
    
    [self createTableView];
    
    [self createSignData];
}

-(void)createSignData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupSearchText"];
    
    [NetManager afPostRequest:url parms:nil finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer == 2000) {
            
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];
            NSMutableArray *array3 = [NSMutableArray array];
            NSMutableArray *array4 = [NSMutableArray array];
            NSMutableArray *array5 = [NSMutableArray array];
            NSMutableArray *array6 = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                
                if ([dic[@"pid"] intValue] == 1) {
                    
                    [array1 addObject:dic];
                    
                }else if ([dic[@"pid"] intValue] == 2){
                    
                    [array2 addObject:dic];
                    
                }else if ([dic[@"pid"] intValue] == 3){
                    
                    [array3 addObject:dic];
                    
                }else if ([dic[@"pid"] intValue] == 4){
                    
                    [array4 addObject:dic];
                    
                }else if ([dic[@"pid"] intValue] == 5){
                    
                    [array5 addObject:dic];
                    
                }else if ([dic[@"pid"] intValue] == 6){
                    
                    [array6 addObject:dic];
                }
            }
            
            if (array1.count != 0) {
                
                [_dataArray addObject:array1];
                
            }
            if (array2.count != 0){
                
                [_dataArray addObject:array2];
                
            }
            if (array3.count != 0){
                
                [_dataArray addObject:array3];
                
            }
            if (array4.count != 0){
                
                [_dataArray addObject:array4];
                
            }
            if (array5.count != 0){
                
                [_dataArray addObject:array5];
            }
            
            if (array6.count != 0) {
                
                [_dataArray addObject:array6];
            }
            
            [self.tableView reloadData];
            
        }else{
            
            [_dataArray removeAllObjects];
            
            [self.tableView reloadData];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GroupSearchCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSearchCell" owner:self options:nil][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (int i = 0; i < [_dataArray[indexPath.section] count]; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i%4 * (WIDTH - 50)/4 + i%4 * 10, 10 + i/4 * 30 + i/4 * 10, (WIDTH - 50)/4, 30)];
        button.tag = indexPath.section * 10 + i;
        [button setTitle:_dataArray[indexPath.section][i][@"content"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 2;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    return cell;
}

-(void)signButtonClick:(UIButton *)button{

    LDSearchViewController *svc = [[LDSearchViewController alloc] init];
    
    svc.content = button.titleLabel.text;
    
    [self.navigationController pushViewController:svc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_dataArray[indexPath.section] count]%4 == 0) {
        
        return ([_dataArray[indexPath.section] count]/4) * 30 + ([_dataArray[indexPath.section] count]/4 + 1) * 10;
    }

    return ([_dataArray[indexPath.section] count]/4 + 1) * 30 + ([_dataArray[indexPath.section] count]/4 + 2) * 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    if ([_dataArray[section][0][@"pid"] intValue] == 1) {
        
        label.text = @"  推荐关键词";
        
    }else if ([_dataArray[section][0][@"pid"] intValue] == 2){
    
        label.text = @"  生活休闲";
    
    }else if ([_dataArray[section][0][@"pid"] intValue] == 3){
    
        label.text = @"  省市地区";
        
    }else if ([_dataArray[section][0][@"pid"] intValue] == 4){
    
        label.text = @"  同好人群";
        
    }else if ([_dataArray[section][0][@"pid"] intValue] == 5){
    
        label.text = @"  斯慕爱好";
        
    }else if ([_dataArray[section][0][@"pid"] intValue] == 6){
    
        label.text = @"  其他";
        
    }

    label.font = [UIFont systemFontOfSize:13];
    
    label.textColor = [UIColor lightGrayColor];
    
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

//searchBar代理方法
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;

            [btn setTitleColor:MainColor forState:UIControlStateNormal];
        }
    }
    
    
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    searchBar.showsCancelButton = NO;
    
    searchBar.text = nil;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length != 0) {
        
        LDSearchViewController *svc = [[LDSearchViewController alloc] init];
        
        svc.content = searchBar.text;
        
        [self.navigationController pushViewController:svc animated:YES];
        
    }
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
