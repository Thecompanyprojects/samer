//
//  LDRewardRankingPageViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDRewardRankingPageViewController.h"
#import "RewardRankingCell.h"
#import "RewardRankingModel.h"
#import "totalRewardRankingCell.h"
#import "RankingModel.h"
#import "RankingCell.h"
#import "LDOwnInformationViewController.h"

@interface LDRewardRankingPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@end

@implementation LDRewardRankingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTableView];
    
    _dataArray = [NSMutableArray array];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createData:@"1"];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createData:@"2"];
    }];
}

-(void)createData:(NSString *)str{

    NSDictionary *parameters;
    NSString *url;
    NSString *type;
    if ([self.type isEqualToString:@"popularity"]) {
        
        if ([self.content intValue] >3 && [self.content intValue] < 8) {
            //点赞排行版  0 1 2 3
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getBeLaudedRankingList"];
            
            type = [NSString stringWithFormat:@"%d",[self.content intValue] - 4];
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else if ([self.content intValue] > 7 && [self.content intValue] < 12){
        //人气榜 热推榜
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getSendDynamicRandkingList"];
            
            type = [NSString stringWithFormat:@"%d",[self.content intValue] - 8];
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"recommend":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
        //人气榜 热评榜
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getBeCommentedRankingList"];
            type = self.content;
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        
    }else if ([self.type isEqualToString:@"diligence"]){
    
        if ([self.content intValue] >3 && [self.content intValue] < 8) {
            //点赞排行榜单
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getLaudRankingList"];
            type = [NSString stringWithFormat:@"%d",[self.content intValue]-4];
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else if ([self.content intValue] > 7 && [self.content intValue] < 12){
            //动态排行榜单
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getSendDynamicRandkingList"];
            type = [NSString stringWithFormat:@"%d",[self.content intValue]-8];
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"recommend":@"0",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
 
            //点评排行榜单
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getCommentRankingList"];
            type = [NSString stringWithFormat:@"%d",[self.content intValue]];
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        
    }else{
        if ([self.content intValue] > 2) {
            if ([self.content intValue] == 5) {
                //魅力榜总榜
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getGiftAllList"];
                type = @"1";
            }else{
                //魅力榜
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getCharmRankingList"];
                type = [NSString stringWithFormat:@"%d",[self.content intValue] - 3];
            }

        }else{
            if([self.content intValue] == 2){
                //富豪榜总榜
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getGiftAllList"];
                type = @"0";
            }else{
                //富豪榜
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getWealthRankingList"];
                type = self.content;
            }
        }
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":type,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000) {
            if (integer == 4000) {
                if ([str intValue] == 1) {
                    [_dataArray removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }
        }else{
            
            if ([str intValue] == 1) {
                [_dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                if ([_type isEqualToString:@"popularity"] || [self.type isEqualToString:@"diligence"]) {
                    RankingModel *model = [[RankingModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                    
                }else{
                    RewardRankingModel *model = [[RewardRankingModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                    
                }
            }
            
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            if (_page == 4) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 84) style:UITableViewStylePlain];
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
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView =  [[UIView alloc] init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count?:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_type isEqualToString:@"popularity"] || [self.type isEqualToString:@"diligence"]) {
        
        RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Ranking"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RankingCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
        cell.nickname.textColor = [UIColor lightGrayColor];
        cell.rewardLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==self.dataArray.count-1) {
            [cell.lineView setHidden:YES];
        }
        else
        {
            [cell.lineView setHidden:NO];
        }
        RankingModel *model = _dataArray[indexPath.row];
        
        cell.model = model;
        
        if (indexPath.row >= 9) {
            
            cell.rewardLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        }else{
            
            cell.rewardLabel.text = [NSString stringWithFormat:@"0%ld",indexPath.row + 1];
        }
        
        [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else{
        
        if ([self.content intValue] == 2 || [self.content intValue] == 5) {
            
            totalRewardRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalRewardRanking"];
            
            if (!cell) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"totalRewardRankingCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
            cell.nickname.textColor = [UIColor lightGrayColor];
            cell.rewardLabel.textColor = [UIColor lightGrayColor];
            if (indexPath.row==self.dataArray.count-1) {
                [cell.lineView setHidden:YES];
            }
            else
            {
                [cell.lineView setHidden:NO];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            RewardRankingModel *model = _dataArray[indexPath.row];
            
            if ([self.content intValue] == 5) {
                
                cell.numImageView.image = [UIImage imageNamed:@"魅"];
                cell.numLabel.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
                cell.numView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
                cell.numView.layer.borderWidth = 1;
                cell.numView.layer.cornerRadius = 2;
                cell.numView.clipsToBounds = YES;
                
            }else if ([self.content intValue] == 2){
                cell.numImageView.image = [UIImage imageNamed:@"财"];
                cell.numLabel.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
                cell.numView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
                cell.numView.layer.borderWidth = 1;
                cell.numView.layer.cornerRadius = 2;
                cell.numView.clipsToBounds = YES;
            }
            if (indexPath.row >= 9) {
                cell.rewardLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            }else{
                
                cell.rewardLabel.text = [NSString stringWithFormat:@"0%ld",indexPath.row + 1];
            }
            cell.model = model;
            [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            
            RewardRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardRanking"];
            
            if (!cell) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"RewardRankingCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
            cell.nickname.textColor = [UIColor lightGrayColor];
            cell.rewardLabel.textColor = [UIColor lightGrayColor];
            if (indexPath.row==self.dataArray.count-1) {
                [cell.lineView setHidden:YES];
            }
            else
            {
                [cell.lineView setHidden:NO];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            RewardRankingModel *model = _dataArray[indexPath.row];
            
            cell.indexPath = indexPath;
            
            if ([self.content intValue] > 2) {
                
                cell.imgView.image = [UIImage imageNamed:@"豪粉"];
                
                cell.numImageView.image = [UIImage imageNamed:@"魅"];
                
                cell.numLabel.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
                
                cell.numView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
                cell.numView.layer.borderWidth = 1;
                cell.numView.layer.cornerRadius = 2;
                cell.numView.clipsToBounds = YES;
                
                if ([self.content intValue] == 3) {
                    
                    cell.showLabel.text = @"24小时内收到:";
                    
                    [cell.showLabel sizeToFit];
                    
                    cell.showW.constant = cell.showLabel.frame.size.width;
                    
                }else if([self.content intValue] == 4){
                    
                    cell.showLabel.text = @"一周内收到:";
                    
                    [cell.showLabel sizeToFit];
                    
                    cell.showW.constant = cell.showLabel.frame.size.width;
                }
                
            }else{
                
                cell.imgView.image = [UIImage imageNamed:@"最爱"];
                
                cell.numImageView.image = [UIImage imageNamed:@"财"];
                
                cell.numLabel.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
                
                cell.numView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
                cell.numView.layer.borderWidth = 1;
                cell.numView.layer.cornerRadius = 2;
                cell.numView.clipsToBounds = YES;
                
                if ([self.content intValue] == 0) {
                    
                    cell.showLabel.text = @"24小时内送出:";
                    
                    [cell.showLabel sizeToFit];
                    
                    cell.showW.constant = cell.showLabel.frame.size.width;
                    
                }else if([self.content intValue] == 1){
                    
                    cell.showLabel.text = @"一周内送出:";
                    
                    [cell.showLabel sizeToFit];
                    
                    cell.showW.constant = cell.showLabel.frame.size.width;
                }
                
            }

            
            cell.model = model;
            
            [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.button1 addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (indexPath.row >= 9) {
                
                cell.rewardLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            }else{
                
                cell.rewardLabel.text = [NSString stringWithFormat:@"0%ld",indexPath.row + 1];
            }
            
            
            return cell;
        }
        
    }
}

-(void)otherButtonClick:(UIButton *)button{

    RewardRankingCell *cell = (RewardRankingCell *)[[button superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RewardRankingModel *model = _dataArray[indexPath.row];
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    
    if ([self.content intValue] > 2) {
        
        fvc.userID = model.rewarduserinfo[@"uid"];
        
    }else{
    
        fvc.userID = model.rewardeduserinfo[@"fuid"];
    }

    [self.navigationController pushViewController:fvc animated:YES];
}

-(void)headButtonClick:(UIButton *)button{
    
    if ([_type isEqualToString:@"popularity"] || [self.type isEqualToString:@"diligence"]) {
        
        RankingCell *cell = (RankingCell *)[[button superview] superview];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        RankingModel *model = _dataArray[indexPath.row];
        
        LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
        
        fvc.userID = model.uid;
        
        [self.navigationController pushViewController:fvc animated:YES];
        
    }else{
        
        RewardRankingCell *cell = (RewardRankingCell *)[[button superview] superview];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        RewardRankingModel *model = _dataArray[indexPath.row];
        
        LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
        
        if ([self.content intValue] > 2) {
            
            if ([self.content intValue] == 5) {
                
                fvc.userID = model.uid;
                
            }else{
            
                fvc.userID = model.fuid;
            }

        }else{
        
            fvc.userID = model.uid;
        }

        [self.navigationController pushViewController:fvc animated:YES];
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 93;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
