//
//  LDDynamicDetailViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//
    
#import "LDDynamicDetailViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDAlertOtherDynamicViewController.h"
#import "HeaderTabViewController.h"
#import "ImageBrowserViewController.h"
#import "LDMemberViewController.h"
#import "attentionCell.h"
#import "TableModel.h"
#import "LDOwnInformationViewController.h"
#import "commentModel.h"
#import "CommentCell.h"
#import "LDReportResonViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDShareView.h"
#import "GifView.h"
#import "LDChargeCenterViewController.h"
#import "bottomView.h"
#import "UITableView+YLSeperatorLine.h"
#import "NSString+QT.h"
#import "DynamicModel.h"
#import "LDSharepageVC.h"
#import "LDSelectpersonpageVC.h"

@interface LDDynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,YBAttributeTapActionDelegate,SMLabelDelegate,PlatformButtonClickDelegate,CommentDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomY;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) CGFloat cellH;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *replyUid;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backH;
@property (weak, nonatomic) IBOutlet UIImageView *recommendView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UIImageView *idView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewW;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceY;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet SMLabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTopH;

@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopH;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;

@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;

@property (weak, nonatomic) IBOutlet UIButton *totopButton;

//发送评论
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;

//点赞数和点赞状态
@property(nonatomic,copy) NSString *zanNum;
@property(nonatomic,copy) NSString *zanState;

//评论数
@property(nonatomic,copy) NSString *commentNum;

//打赏数
@property(nonatomic,copy) NSString *rewordNum;

//是不是志愿者
@property(nonatomic,copy) NSString *volunteer;

//收藏的状态
@property(nonatomic,copy) NSString *collectstate;

//举报动态的状态
@property(nonatomic,copy) NSString *reportstate;

//置顶的状态
@property(nonatomic,copy) NSString *stickstate;

//动态的隐藏状态
@property (nonatomic,copy) NSString *is_hidden;

//推荐的状态
@property(nonatomic,copy) NSString *recommendstate;

//黑V推荐的状态
@property(nonatomic,copy) NSString *recommend;

//黑V置顶的状态
@property(nonatomic,copy) NSString *recommendall;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;

//图片数组
@property(nonatomic,copy) NSArray *picArray;

//存储话题的id
@property (nonatomic,copy) NSString *tid;

//是否可以评论
@property (nonatomic,copy) NSString *publishComment;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;

//礼物界面
@property (nonatomic,strong) GifView *gif;

//动态数与推荐动态数
@property (weak, nonatomic) IBOutlet UILabel *dyAndRdNumLabel;

@property (nonatomic,strong) bottomView *bottom;

@property (nonatomic,copy)   NSString *topnumStr;
@property (nonatomic,strong) UIImageView *rocketsView;
@property (nonatomic,strong) topimgView3 *rocketsView2;
@property (nonatomic,strong) topimgView4 *rocketsView3;

@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) NSArray *atnameArray;
@property (nonatomic,strong) NSArray *atuidArray;

//share
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *picStr;
@property (nonatomic,assign) BOOL iscanUser;

//
@property (nonatomic,strong) NSMutableAttributedString *zanattriStr;
@property (nonatomic,strong) NSMutableAttributedString *conmmentAttriStr;
@property (nonatomic,strong) NSMutableAttributedString *replyAttriStr;
@property (nonatomic,strong) NSMutableAttributedString *totopAttriStr;

@property (nonatomic,strong) NSDictionary *dynamicDic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totopButtonW;
@property (nonatomic,assign) BOOL iskeyboardTop;

@property (nonatomic,strong) NSMutableArray *sendatunameArray;
@property (nonatomic,strong) NSMutableArray *sendatuidArray;
@property (nonatomic,copy) NSString *sendatuname;
@property (nonatomic,copy) NSString *sendatuid;

@end

@implementation LDDynamicDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"动态详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.sendatunameArray = [NSMutableArray array];
    self.sendatuidArray = [NSMutableArray array];
    self.dynamicDic = [NSDictionary dictionary];
    [self.tableView addSubview:self.sendView];
    
    self.atnameArray = [NSArray array];
    self.atuidArray = [NSArray array];
    
    _dataArray = [NSMutableArray array];
    //点赞,评论,打赏 推顶状态
    _status = @"2";
    [self createTableView];
    
    self.sendView.hidden = YES;
    
    self.headView.layer.cornerRadius = 20;
    self.headView.clipsToBounds = YES;
    
    self.onlineView.layer.cornerRadius = 4;
    self.onlineView.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.sendButton.layer.cornerRadius = 2;
    self.sendButton.clipsToBounds = YES;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 2;
    self.textView.clipsToBounds = YES;
    
    [self createButton];
    
    if ([_clickState isEqualToString:@"comment"]) {
        
    }
    
    self.backView.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self createData:@"1"];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self createData:@"2"];
    }];
    
    [self createScanData];

    [self createPublishCommentData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardSuccess) name:@"动态详情打赏成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindPhoneNumSuccess) name:@"绑定手机号码成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editDynamicSuccess) name:@"编辑动态成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    [self createBottomView];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        if (self.returnblock) {
            self.returnblock(self.model.auditMark);
        }
    }
}

-(void)createBottomView
{
    self.bottom= [[bottomView alloc] init];
    self.bottom.isfromDis = YES;

    [self.view addSubview:self.bottom];
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        if (ISIPHONEX) {
            make.bottom.equalTo(self.view).with.offset(-32);
        }
        else
        {
            make.bottom.equalTo(self.view).with.offset(-12);
        }
    }];

    [self.bottom.zanBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
    [self.bottom.commentBtn setTitleColor:MainColor forState:normal];
    [self.bottom.replyBtn setTitleColor:MainColor forState:normal];
    [self.bottom.topBtn setTitleColor:MainColor forState:normal];
    [self.bottom.commentBtn setImage:[UIImage imageNamed:@"评论紫"] forState:normal];
    [self.bottom.replyBtn setImage:[UIImage imageNamed:@"打赏紫"] forState:normal];
    [self.bottom.topBtn setImage:[UIImage imageNamed:@"推顶紫"] forState:normal];
    [self.bottom.zanBtn setTitle:@"赞" forState:normal];
    [self.bottom.commentBtn setTitle:@"评论" forState:normal];
    [self.bottom.replyBtn setTitle:@"打赏" forState:normal];
    [self.bottom.topBtn setTitle:@"推顶" forState:normal];
    [self.bottom.zanBtn addTarget:self action:@selector(dianzanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom.commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom.replyBtn addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom.topBtn addTarget:self action:@selector(topcardClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 禁用IQKeyboardManager

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_gif) {
        [_gif removeView];
    }
}

/**
 * 编辑动态成功的监听方法
 */
-(void)editDynamicSuccess{
    
    [self createScanData];
}

/**
 * 绑定手机号码成功的监听方法
 */

-(void)bindPhoneNumSuccess{

    _publishComment = @"YES";
}

/**
 * 打赏成功的监听方法
 */

-(void)rewardSuccess{
    
    [self createScanData];
    if (_rewordBlock) {
        self.rewordBlock([NSString stringWithFormat:@"%d",[_rewordNum intValue]]);
    }
}

/**
 * 获取判断是否可以评论的状态
 */
-(void)createPublishCommentData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,judgeDynamicNewrdUrl];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer == 4003) {
            _publishComment = @"NO";
        }else  if(integer == 2000 || integer == 4004){
            _publishComment = @"YES";
        }else if(integer == 3001){
            _publishComment = @"";
        }
        else if (integer==5000)
        {
            self.iscanUser = YES;
            _publishComment = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"msg"]];
        }
    } failed:^(NSString *errorMsg) {
         _publishComment = @"NO";
    }];
}

/**
 获取用户数据
 */
-(void)createScanData{
    
    NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
    [waitQueue addOperationWithBlock:^{
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getDynamicdetailFiveUrl];
        NSDictionary *parameters;
        
        parameters = @{@"did":self.did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:latitude]?:@"0",@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:longitude]?:@"0"};
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (integer != 2000 && integer != 2001) {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                    self.tableView.mj_footer.hidden = YES;
                    self.tableView.mj_header.hidden = YES;
                }else{
                    
                    [self createUI:responseObj[@"data"] andInteger:integer];
                    [self.tableView reloadData];
                }
                
            });
           
        } failed:^(NSString *errorMsg) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.tableView.mj_footer.hidden = YES;
                self.tableView.mj_header.hidden = YES;
                
            });

        }];
        
    }];
}

/**
 请求赞，评论，打赏 推顶数据

 @param str 接口
 */
-(void)createData:(NSString *)str{

    NSString *url = [NSString string];
    NSDictionary *parameters;
    //查询推顶列表 不传UID

    parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    if ([_status intValue] == 1)
    {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getLaudListNew];
    }else if ([_status intValue] == 2)
    {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getCommentListNew];
    }else if ([_status intValue] == 3)
    {
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getRewardListNew];
    }
    else if ([_status intValue]==4)
    {
         url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getTopcardUsedRs];
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000) {
            if (integer == 4002||integer == 3000) {
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
            if ([_status intValue] == 2) {
                
                NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[commentModel class] json:responseObj[@"data"]]];
                [self.dataArray addObjectsFromArray:data];
                
            }else{
                NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[TableModel class] json:responseObj[@"data"]]];
                [self.dataArray addObjectsFromArray:data];

            }
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)createTableView{
    if (ISIPHONEX) {
        self.bottomY.constant = IPHONEXBOTTOMH;
        self.tableViewBottomY.constant = self.tableViewBottomY.constant + IPHONEXBOTTOMH;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count?:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.status intValue] == 1 || [self.status intValue] == 3||[self.status intValue] == 4) {
        attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attention"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"attentionCell" owner:self options:nil].lastObject;
         
        }
        cell.isfromDis = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section==self.dataArray.count-1) {
            [cell.lineView setHidden:YES];
        }
        else
        {
            [cell.lineView setHidden:NO];
        }
        TableModel *model;
        if (self.dataArray.count > 0) {
            model = self.dataArray[indexPath.section];
            cell.otherType = @"0";
            cell.model = model;
        }
        [cell.attentButton addTarget:self action:@selector(attentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if([_status intValue]==4)
        {
            cell.introduceLabel.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithSeconds:model.addtime];
            cell.numLabel.numberOfLines = 0;
            [cell sizeToFit];
            if ([model.sum intValue]==1) {
                cell.numLabel.text = @"+100魅力值";
            }
            else
            {
                NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",model.use_sum,@"次/",model.sum,@"卡/",model.interval,@"\n",@"+100魅力值"];
                cell.numLabel.text = str;
            }
            [cell.numLabel setHidden:NO];
            [cell.modouView setHidden:NO];
            cell.modouView.image = [UIImage imageNamed:@"推顶火箭"];
        }
        return cell;
    }else if([self.status intValue] == 2){
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil].lastObject;
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        commentModel *model = [[commentModel alloc] init];
        if (self.dataArray.count > 0) {
            model = self.dataArray[indexPath.section];
            cell.model = model;
        }
        [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"bkvip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"blvip"] intValue]==1) {
            cell.deleteButton.hidden = NO;
            [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
            if ([self.ownUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] || [model.uid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                cell.deleteButton.hidden = NO;
                [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                cell.deleteButton.hidden = YES;
            }
        }
        if (indexPath.section==self.dataArray.count-1) {
            [cell.lineView setHidden:YES];
        }
        else
        {
            [cell.lineView setHidden:NO];
        }
        self.cellH = cell.contentView.frame.size.height;
        return cell;
    }
    return [UITableViewCell new];
}

/**
 删除评论

 @param button 删除评论Button
 */
-(void)deleteButtonClick:(UIButton *)button{

    CommentCell *cell = (CommentCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    commentModel *model = _dataArray[indexPath.section];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,delComment];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"cmid":model.cmid};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer != 2000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            [_dataArray removeObjectAtIndex:indexPath.section];
            [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %@",[NSString stringWithFormat:@"%d",[_commentNum intValue] - 1]] forState:UIControlStateNormal];
            _commentNum = [NSString stringWithFormat:@"%d",[_commentNum intValue] - 1];
            if (_commentBlock) {
                self.commentBlock([NSString stringWithFormat:@"%d",[_commentNum intValue]]);
            }
            [self.tableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

-(void)headButtonClick:(UIButton *)button{

    CommentCell *cell = (CommentCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    commentModel *model = _dataArray[indexPath.section];
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = model.uid;
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)attentButtonClick:(UIButton *)button{
    attentionCell *cell = (attentionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TableModel *model = _dataArray[indexPath.section];
    
    if ([model.state intValue] == 0 || [model.state intValue] == 2) {
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setfollowOne];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]?:@"",@"fuid":model.uid?:@""};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
            if (integer != 2000) {

                if (integer==5000)
                {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:responseObj[@"msg"]];
                }
                else
                {
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                        [self.navigationController pushViewController:mvc animated:YES];
                    }];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                        cvc.where = @"9";
                        [self.navigationController pushViewController:cvc animated:YES];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [control addAction:action1];
                    [control addAction:action0];
                    [control addAction:action2];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                }
                
           
            }else{
                if ([model.state intValue] == 0) {
                    model.state = @"1";
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }else if ([model.state intValue] == 2){
                    model.state = @"3";
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    else if([model.state intValue] == 1 || [model.state intValue] == 3){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定不再关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,setoverfollow];
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                if (integer != 2000) {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                }else{
                    if ([model.state intValue] == 1) {
                        model.state = @"0";
                        [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [self.tableView reloadData];
                    }else if ([model.state intValue] == 3){
                        model.state = @"2";
                        [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [self.tableView reloadData];
                    }
                }
            } failed:^(NSString *errorMsg) {
                
            }];

        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_status intValue] == 2) {
        return _cellH;
    }
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_status intValue] == 1 || [_status intValue] == 3|| [_status intValue] == 4) {
        LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
        TableModel *model = _dataArray[indexPath.section];
        ivc.userID = model.uid;
        [self.navigationController pushViewController:ivc animated:YES];
    }else if ([_status intValue] == 2){
        commentModel *model = _dataArray[indexPath.section];
        if ([model.uid intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            _replyUid = model.uid;
            [self.textView becomeFirstResponder];
            if (self.textView.text.length != 0) {
                self.textView.text = @"";
            }
            self.introduceLabel.hidden = NO;
            self.introduceLabel.text = [NSString stringWithFormat:@"回复 %@:",model.nickname];
        }else{
            self.introduceLabel.hidden = YES;
            self.introduceLabel.text = @"";
            _replyUid = @"";
        }
    }
}

-(void)createUI:(NSDictionary *)dic andInteger:(NSInteger)integer{

    self.model = [[DynamicModel alloc] init];
    self.model = [DynamicModel yy_modelWithDictionary:dic];
    self.atnameArray = [self.model.atuname componentsSeparatedByString:@","];
    self.atuidArray = [self.model.atuid componentsSeparatedByString:@","];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        self.dyAndRdNumLabel.text = [NSString stringWithFormat:@"%@/%@",dic[@"dynamic_num"],dic[@"rdynamic_num"]];
        self.dyAndRdNumLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"发",dic[@"dynamic_num"],@"推",dic[@"rdynamic_num"],@"隐",dic[@"hidedstatustimes"],@"封",dic[@"dynamicstatusouttimes"]];
    }

    _reportstate = [NSString stringWithFormat:@"%@",dic[@"reportstate"]];
    _stickstate = [NSString stringWithFormat:@"%@",dic[@"stickstate"]];
    _is_hidden = [NSString stringWithFormat:@"%@",dic[@"is_hidden"]];
    _collectstate = [NSString stringWithFormat:@"%@",dic[@"collectstate"]];
    _recommendstate = [NSString stringWithFormat:@"%@",dic[@"recommend"]];
    _recommend = [NSString stringWithFormat:@"%@",dic[@"recommend"]];
    _recommendall = [NSString stringWithFormat:@"%@",dic[@"recommendall"]];
    _tid = dic[@"tid"];
    
    NSArray *picArr = [NSMutableArray array];
    picArr = dic[@"pic"];
    NSString *pic;
    if (picArr.count!=0) {
        pic = [picArr firstObject];
    }
    else
    {
        pic = @"";
    }
    self.nickName = dic[@"nickname"];
    self.picStr = pic;
    
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLabel.text = dic[@"nickname"];
    
    [self.nameLabel sizeToFit];
    
    if ([_ownUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        if ([dic[@"stickstate"] intValue] == 1) {
            
            self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
            
            self.recommendView.hidden = NO;
            
        }else if ([dic[@"is_hidden"] intValue] == 1){
        
            self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
            
            self.recommendView.hidden = NO;

        }else if([dic[@"recommend"] intValue] == 1){
        
            self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
            
            self.recommendView.hidden = NO;
            
        }else{
            
            self.recommendView.hidden = YES;
        }
        
        if ([dic[@"recommend"] intValue] == 0) {
            
            self.scanLabel.text = @"";
            
            self.distanceY.constant = 15;
            
        }else{
        
            NSString *readtimes = [NSString stringWithFormat:@"%@",dic[@"readtimes"]];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"浏览 ",readtimes]];
            if ([readtimes intValue]>=10000) {
                [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,3)];
                [noteStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,readtimes.length)];
                
            }
            else
            {
                [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,readtimes.length+3)];
            }
            self.scanLabel.attributedText = noteStr;

            self.distanceY.constant = 38;
        }

    }else{
        
        if ([dic[@"is_hidden"] intValue] == 1){
            
            self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
            
            self.recommendView.hidden = NO;
            
            if ([dic[@"recommend"] intValue] == 0) {
                
                self.scanLabel.text = @"";
                
                self.distanceY.constant = 15;
                
            }else{

                NSString *readtimes = [NSString stringWithFormat:@"%@",dic[@"readtimes"]];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"浏览 ",readtimes]];
                if ([readtimes intValue]>=10000) {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,3)];
                    [noteStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,readtimes.length)];
                    
                }
                else
                {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,readtimes.length+3)];
                }
                self.scanLabel.attributedText = noteStr;
                
                self.distanceY.constant = 38;
            }
            
        }else{
            
            if ([dic[@"recommend"] intValue] == 0) {
                
                self.recommendView.hidden = YES;
                
                self.scanLabel.text = @"";
                
                self.distanceY.constant = 15;
                
            }else{

                NSString *readtimes = [NSString stringWithFormat:@"%@",dic[@"readtimes"]];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"浏览 ",readtimes]];
                if ([readtimes intValue]>=10000) {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,3)];
                    [noteStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,readtimes.length)];
                    
                }
                else
                {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,readtimes.length+3)];
                }
                self.scanLabel.attributedText = noteStr;

                self.distanceY.constant = 38;
                
                self.recommendView.hidden = NO;
                
                if ([dic[@"recommendall"] length] != 0) {
                    
                    if ([dic[@"recommendall"] intValue] > 0) {
                        
                        self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                        
                    }else{
                        
                        self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                    }
                    
                }else{
                    
                    self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                }
            }
        }
    }
    
    if ([[dic objectForKey:@"is_admin"] intValue]==1) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
    }
    else if ([[dic objectForKey:@"bkvip"] intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"贵宾黑V"];
        
    }
    else if ([[dic objectForKey:@"blvip"] intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"蓝V"];
        
    }
    else if ([[dic objectForKey:@"is_volunteer"] intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
    }
    else
    {
        if ([[dic objectForKey:@"svipannual"] intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
        }else if ([[dic objectForKey:@"svip"] intValue] == 1){
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
        }else if ([[dic objectForKey:@"vipannual"] intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
        }else{
            if ([[dic objectForKey:@"vip"] intValue] == 1) {
                self.vipView.hidden = NO;
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
            }else{
                self.vipView.hidden = YES;
            }
        }
    }
    
    if ([dic[@"onlinestate"] intValue] == 1) {
        self.onlineView.hidden = NO;
    }else{
        self.onlineView.hidden = YES;
    }
    if ([dic[@"realname"] intValue] == 1) {
        self.idView.hidden = NO;
        self.idViewW.constant = 17;
    }else{
        self.idView.hidden = YES;
        self.idViewW.constant = 0;
    }
    if ([dic[@"distance"] floatValue] != 0) {
        if (integer == 2001) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
            
        }else{
            if ([dic[@"location_switch"] intValue]==1) {
                self.distanceLabel.text = [NSString stringWithFormat:@"%@ %@",@"隐身",dic[@"addtime"]];
            }else
            {
                self.distanceLabel.text = [NSString stringWithFormat:@"%@km %@",dic[@"distance"],dic[@"addtime"]];
            }
        }
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
    }
    
    self.commentLabel.delegate = self;
    self.commentLabel.userInteractionEnabled = YES;

    NSString *content;
    
    self.commentLabel.font = [UIFont systemFontOfSize:16];
    
    if ([dic[@"topictitle"] length] == 0) {
        
        content = dic[@"content"];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];

        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        self.commentLabel.attributedText = attributedString;

    }else{
        
        content = [NSString stringWithFormat:@"#%@# %@",dic[@"topictitle"],dic[@"content"]];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];

        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        self.commentLabel.attributedText = attributedString;
     
        CGSize size = [[NSString stringWithFormat:@"#%@#",dic[@"topictitle"]] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [button addTarget:self action:@selector(topicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.commentLabel addSubview:button];
    }
    
    self.backH.constant = 150;
    
    if (content.length==0) {
        self.commentTopH.constant = 0;
        self.commentH.constant = 0;
    }
    else
    {
        if (![content isMoreThanOneLineWithSize:CGSizeMake(WIDTH-24, MAXFLOAT) font:[UIFont systemFontOfSize:16] lineSpaceing:5]) {
            self.commentLabel.linespace = 0;
            self.commentTopH.constant = 18;
            self.commentH.constant = 20;
        }
        else
        {
            self.backH.constant = 150 - 16;
            self.commentLabel.linespace = 6;
            
            CGFloat boundingRectHeight = [content boundingRectWithSize:CGSizeMake(WIDTH-24, MAXFLOAT) font:[UIFont systemFontOfSize:16] lineSpacing:5].height;
            
            if (boundingRectHeight<120) {
                  self.commentH.constant = boundingRectHeight+3;
            }
            else
            {
                CGFloat boundingRectHeight2 = [content boundingRectWithSize:CGSizeMake(WIDTH-24, MAXFLOAT) font:[UIFont systemFontOfSize:16] lineSpacing:3].height;
                self.commentH.constant = boundingRectHeight2;
            }
            
            self.commentTopH.constant = 18;
            
            if (content.length == 0) {
                self.commentH.constant = 0;
                self.commentTopH.constant = 0;
                self.backH.constant = 150 - 16 - 12;
            }
        }
    }
    
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if ([dic[@"sypic"] count] == 0) {
        _picArray = dic[@"pic"];
    }else{
        _picArray = dic[@"sypic"];
    }
    if (_picView.subviews.count != 0) {
        
        for (UIView *view in _picView.subviews) {
            [view removeFromSuperview];
        }
    }
    if ([dic[@"pic"] count] != 0) {
        self.picTopH.constant = 12;
        if ([dic[@"pic"] count] == 1) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"pic"][0]]]];
            imageV.userInteractionEnabled = YES;
            imageV.tag = 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageV addGestureRecognizer:tap];
            [_picView addSubview:imageV];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            self.picH.constant = 240;
            self.backH.constant = self.backH.constant + self.picH.constant + self.commentH.constant;

            self.backView.frame = CGRectMake(self.backView.frame.origin.x, 2, WIDTH, self.backH.constant);
        }else if ([dic[@"pic"] count] > 1){
            CGFloat imageH = (WIDTH - 24 - 8)/3;
            for (int i = 0; i < [dic[@"pic"] count]; i++) {
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * imageH + i%3 * 4, i/3 * imageH + i/3 * 4, imageH, imageH)];
                [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"pic"][i]]]];
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                imageV.clipsToBounds = YES;
                imageV.userInteractionEnabled = YES;
                imageV.tag = i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                [imageV addGestureRecognizer:tap];
                [_picView addSubview:imageV];
                if (i == [dic[@"pic"] count] - 1) {
                    
                    self.picH.constant = i/3 * imageH + i/3 * 4 + imageH;
                }
            }
            self.backH.constant = self.backH.constant + self.picH.constant + self.commentH.constant;
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, 2, WIDTH,self.backH.constant);
        }
    }else{
        self.picH.constant = 0;
        self.picTopH.constant = 0;
        self.backH.constant = self.backH.constant - 12 + self.commentH.constant;
        self.backView.frame = CGRectMake(self.backView.frame.origin.x, 2, WIDTH , self.backH.constant);
    }
    
    [self.tableView reloadData];
    if ([dic[@"role"] isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        self.sexualLabel.backgroundColor = DOUBLECOLOR;
        
    }else{
    
        self.sexualLabel.text = @"~";
        self.sexualLabel.backgroundColor = GREENCOLORS;
    }
    
    if ([dic[@"sex"] intValue] == 1) {
        
        self.sexLabel.image = [UIImage imageNamed:@"男"];
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"sex"] intValue] == 2){
        
        self.sexLabel.image = [UIImage imageNamed:@"女"];
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        self.sexLabel.image = [UIImage imageNamed:@"双性"];
        self.aSexView.backgroundColor = DOUBLECOLOR;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@",dic[@"age"]];
    
    if ([dic[@"laudstate"] intValue] == 0) {
        [self.bottom.zanBtn setImage:[UIImage imageNamed:@"赞灰"] forState:normal];
        [self.bottom.zanBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
    }else{
        [self.bottom.zanBtn setImage:[UIImage imageNamed:@"赞紫"] forState:normal];
        [self.bottom.zanBtn setTitleColor:[UIColor colorWithHexString:@"#c450d6" alpha:1] forState:normal];
    }
    
    self.dynamicDic = dic.copy;
    [self createButtom:dic];
    
    //获取展示的财富值和魅力值
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:dic[@"wealth_val"] andNSLayoutConstraint:_wealthW andType:@"财富"];
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:dic[@"charm_val"] andNSLayoutConstraint:_charmW andType:@"魅力"];
    _backView.hidden = NO;
    self.tableView.tableHeaderView = self.backView;
    
    UIView *line = [UIView new];
    [self.tableView addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.backView);
        make.height.mas_offset(1);
    }];
    [self.tableView.mj_header beginRefreshing];
}


-(void)createButtom:(NSDictionary *)dic
{
    _zanNum = [NSString stringWithFormat:@"%@",dic[@"laudnum"]];
    _zanState = [NSString stringWithFormat:@"%@",dic[@"laudstate"]];
    _commentNum = [NSString stringWithFormat:@"%@",dic[@"comnum"]];
    _rewordNum = [NSString stringWithFormat:@"%@",dic[@"rewardnum"]];
    
    self.zanattriStr =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"赞 %@",dic[@"laudnum"]]];
    self.conmmentAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论 %@",dic[@"comnum"]]];
    self.replyAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"打赏 %@",dic[@"rewardnum"]]];;
    
    [self.zanButton setAttributedTitle:self.zanattriStr forState:UIControlStateNormal];
    if ([self.status intValue]==1) {
        [self.zanattriStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,_zanNum.length+2)];
    }
    else
    {
        if ([_zanNum intValue]>=100) {
            
            [self.zanattriStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(2,_zanNum.length)];
            [self.zanattriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        }
        else
        {
            [self.zanattriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,_zanNum.length+2)];
        }
    }
    
    
    [self.commentButton setAttributedTitle:self.conmmentAttriStr forState:UIControlStateNormal];
    if ([self.status intValue]==2) {
        [self.conmmentAttriStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,_commentNum.length+3)];
    }
    else
    {
        if ([_commentNum intValue]>=100) {
            
            [self.conmmentAttriStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,_commentNum.length)];
            [self.conmmentAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 3)];
        }
        else
        {
            [self.conmmentAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,_commentNum.length+3)];
            
        }
    }
    
    [self.rewardButton setAttributedTitle:self.replyAttriStr forState:UIControlStateNormal];
    if ([self.status intValue]==3) {
        [self.replyAttriStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,_rewordNum.length+3)];
    }
    else
    {
        if ([_rewordNum intValue]>=10000) {
            
            [self.replyAttriStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,_rewordNum.length)];
            [self.replyAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 3)];
        }
        else
        {
            [self.replyAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,_rewordNum.length+3)];
            
        }
    }
    
    self.topnumStr = [NSString stringWithFormat:@"%@",dic[@"alltopnums"]];
    NSString *usetopnums = [NSString stringWithFormat:@"%@",dic[@"usetopnums"]];
    
    if ([self.status intValue]==4) {
        
        if ([usetopnums intValue]==0||[self.topnumStr intValue]==[usetopnums intValue]) {
            self.totopAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"推顶 %@",self.topnumStr]];
            [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,self.topnumStr.length+3)];
            [self.totopButton setAttributedTitle:self.totopAttriStr forState:normal];
        }
        else
        {
            self.totopAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"推顶 %@/%@",usetopnums,self.topnumStr]];
            [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,self.topnumStr.length+3+usetopnums.length+1)];
            [self.totopButton setAttributedTitle:self.totopAttriStr forState:normal];
        }
    }
    else
    {
        if ([self.topnumStr intValue]>=100) {
            if ([usetopnums intValue]==0||[self.topnumStr intValue]==[usetopnums intValue]) {
                self.totopAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"推顶 %@",self.topnumStr]];
                [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,3)];
                [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,self.topnumStr.length)];
                [self.totopButton setAttributedTitle:self.totopAttriStr forState:normal];
                
                CGFloat widths = [self clwidth:[NSString stringWithFormat:@"推顶 %@",self.topnumStr]];
                if (widths>89) {
                    self.totopButtonW.constant = widths+6;
                }
            }
            else
            {
                self.totopAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"推顶 %@/%@",usetopnums,self.topnumStr]];
                [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,3)];
                [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,self.topnumStr.length+usetopnums.length+1)];
                [self.totopButton setAttributedTitle:self.totopAttriStr forState:normal];
                CGFloat widths = [self clwidth:[NSString stringWithFormat:@"推顶 %@/%@",usetopnums,self.topnumStr]];
                if (widths>89) {
                    self.totopButtonW.constant = widths+6;
                }
            }
        }
        else
        {
            if ([usetopnums intValue]==0||[self.topnumStr intValue]==[usetopnums intValue]) {
                self.totopAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"推顶 %@",self.topnumStr]];
                [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,self.topnumStr.length+3)];
                [self.totopButton setAttributedTitle:self.totopAttriStr forState:normal];
            }
            else
            {
                self.totopAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"推顶 %@/%@",usetopnums,self.topnumStr]];
                [self.totopAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,self.topnumStr.length+usetopnums.length+3+1)];
                [self.totopButton setAttributedTitle:self.totopAttriStr forState:normal];
            }
        }
    }
}

-(CGFloat)clwidth:(NSString*)string
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

// 检索文本的正则表达式的字符串
- (NSString * _Nonnull)sm_regexStringHyperlinkOfLabel:(SMLabel * _Nonnull)label {
    NSString *regex3 = @"#\\S+# ";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)",kATRegular,regex3];
    return regex;
}

- (void)sm_label:(SMLabel * _Nonnull)label didTouche:(UITouch * _Nonnull)touche
{
    [self.textView resignFirstResponder];
}
#pragma mark - 1.1.0 添加长按显示UIMenuController功能

// 长按显示UIMenuController视图
- (NSMutableArray<UIMenuItem *> * _Nonnull)sm_menuItemsOfLabel:(SMLabel * _Nonnull)label {
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")];
    [menuItems addObject:copyItem];
    return menuItems;
}

/// 点击UIMenuItem的点击事件
- (void)sm_label:(SMLabel * _Nonnull)label menuItemsAction:(SEL _Nonnull)action sender:(id _Nonnull)sender {
    if (action == NSSelectorFromString(@"copyText:")) {
        NSLog(@"复制%@",sender);
    }
}

- (void)sm_label:(SMLabel * _Nonnull)label willToucheHyperlinkText:(NSString * _Nonnull)text
{
    NSLog(@"begintext---%@",text);

}

- (void)sm_label:(SMLabel * _Nonnull)label didToucheHyperlinkText:(NSString * _Nonnull)text
{
    NSLog(@"text---%@",text);
    if (self.model.atuname.length!=0) {
        if (self.model.topictitle.length!=0) {
            if ([self.atnameArray containsObject:text]) {
                int index = (int)[self.atnameArray indexOfObject:text];
                NSString *useridstr = [self.atuidArray objectAtIndex:index];
                dispatch_async(dispatch_get_main_queue(), ^{
                    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
                    ivc.userID = useridstr;
                    [self.navigationController pushViewController:ivc animated:YES];
                });
            }
            else
            {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"无此人"];
            }
        }
        else
        {
            if ([self.atnameArray containsObject:text]) {
                NSInteger indexs = [self.atnameArray indexOfObject:text];
                NSString *useridstr = [self.atuidArray objectAtIndex:indexs];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
                    ivc.userID = useridstr;
                    [self.navigationController pushViewController:ivc animated:YES];
                });
                
            }
            else
            {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"无此人"];
            }
        }
    }
}

// 设置当前链接文本的颜色
- (UIColor * _Nonnull)sm_linkColorOfLabel:(SMLabel * _Nonnull)label {
    return MainColor;
}

- (UIColor * _Nonnull)sm_passColorOfLabel:(SMLabel * _Nonnull)label
{
    return MainColor;
}

- (UIColor * _Nonnull)sm_menuControllerDidShowColorOfLabel:(SMLabel * _Nonnull)label;
{
    return [UIColor clearColor];
}

-(void)topicButtonClick{
    if (_tid.length != 0) {
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        tvc.tid = [NSString stringWithFormat:@"%@",_tid];
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView  andText:(NSString *)text andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([text intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            backView.hidden = YES;
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([text intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            backView.hidden = NO;
            label.text = [NSString stringWithFormat:@"%@",text];
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

-(CGSize)fitLabelWidth:(NSString *)string{
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return labelSize;
}

-(void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *img = (UIImageView *)tap.view;
    __weak typeof(self) weakSelf=self;
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag imagesBlock:^NSArray *{
        return weakSelf.picArray;
    }];
}

#pragma mark - 点赞 评论 打赏 推顶 列表

/**
 查看点赞列表

 @param sender 查看点赞列表
 */
- (IBAction)zanButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _status = @"1";
    [self createButtom:self.dynamicDic];
    _page = 0;
    [self createData:@"1"];
}


/**
 查看评论列表

 @param sender 查看评论列表
 */
- (IBAction)commentButtonCllick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _status = @"2";
    [self createButtom:self.dynamicDic];
    _page = 0;
    [self createData:@"1"];
}

/**
 查看打赏列表

 @param sender 查看打赏列表
 */
- (IBAction)rewardButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _status = @"3";
    [self createButtom:self.dynamicDic];
    _page = 0;
    [self createData:@"1"];
}

- (IBAction)topcardClick:(id)sender {
    self.iskeyboardTop = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _status = @"4";
    [self createButtom:self.dynamicDic];
    _page = 0;
    [self createData:@"1"];
}


//动态详情页点赞

-(void)dianzanClick
{
    if ([_zanState intValue] == 0) {
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Dynamic/laudDynamicNewrd"];
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            if (integer != 2000) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{

                [self createScanData];
                
                [self.bottom.zanBtn setTitleColor:MainColor forState:normal];
                [self.bottom.zanBtn setImage:[UIImage imageNamed:@"赞紫"] forState:normal];
                
                _zanState = @"1";
                
                _zanNum = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[_zanNum intValue] + 1]];
                if (_block) {
                    self.block([NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[_zanNum intValue]]],_zanState);
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}
//评论动态

-(void)commentClick
{
    [self.textView becomeFirstResponder];
}

/**
 打赏功能

 @param sender 打赏功能
 */
-(void)replyClick
{
    BOOL ismines = NO;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]==[self.ownUid intValue]) {
        ismines = YES;
    }
    _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:ismines :^{
        LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
        cvc.type = @"0";
        [self.navigationController pushViewController:cvc animated:YES];
        
    }];
    [_gif getDynamicDid:self.did andIndexPath:nil andSign:@"动态详情" andUIViewController:self];
    [self.tabBarController.view addSubview:_gif];
}


/**
 推顶功能
 */
-(void)topcardClick
{
    LDShowtopView *showview = [LDShowtopView new];
    showview.did = self.did?:@"";
    showview.alertshow = ^{
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入推顶卡张数"];
    };
    showview.sureclick = ^(NSString * _Nonnull num, NSString * _Nonnull rocket) {

        [self createScanData];
        if ([rocket intValue]==1) {
            
            self.rocketsView = [UIImageView new];
            self.rocketsView.frame = CGRectMake(WIDTH/2-150, HEIGHT-450, 300, 300);
            self.rocketsView.image = [UIImage imageNamed:@"推顶火箭"];
            [self.view addSubview:self.rocketsView];
            [self spring:self.rocketsView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self movewith:self.rocketsView];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.rocketsView removeFromSuperview];
            });
        }
        if ([rocket intValue]==2) {
            
            self.rocketsView2 = [topimgView3 new];
            self.rocketsView2.frame = CGRectMake(0, HEIGHT-450, WIDTH, 220);
            [self.view addSubview:self.rocketsView2];
            [self spring:self.rocketsView2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self movewith:self.rocketsView2];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.rocketsView2 removeFromSuperview];
            });
        }
        if ([rocket intValue]==3) {
            
            self.rocketsView3 = [topimgView4 new];
            self.rocketsView3.frame = CGRectMake(0, HEIGHT-450, WIDTH, 300);
            [self.view addSubview:self.rocketsView3];
            [self spring:self.rocketsView3];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self movewith:self.rocketsView3];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.rocketsView3 removeFromSuperview];
            });
            
        }
        
    };
    
    showview.buyclick = ^(NSString * _Nonnull str) {
        LDtotopViewController *VC = [LDtotopViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    };
    
    showview.alert = ^(NSString * _Nonnull str) {
        
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的推顶卡不足，请购买" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDtotopViewController *VC = [LDtotopViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    };
}

// 移动
- (void)movewith:(UIView *)theView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = 1;
    animation.repeatCount = 0;
    animation.fromValue = [NSValue valueWithCGPoint:theView.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(theView.layer.position.x, theView.layer.position.y-HEIGHT)];
    [theView.layer addAnimation:animation forKey:@"move"];
}

// 弹簧
- (void)spring:(UIView *)theView
{
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime();
    animation.damping = 2;
    animation.stiffness = 50;
    animation.mass = 1;
    animation.initialVelocity = 10;
    [animation setFromValue:[NSValue valueWithCGPoint:theView.layer.position]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(theView.layer.position.x, theView.layer.position.y + 50)]];
    animation.duration = animation.settlingDuration;
    [theView.layer addAnimation:animation forKey:@"spring"];
}


#pragma mark - 发布评论

- (IBAction)sendButtonClick:(id)sender {
    
    [self.textView resignFirstResponder];
    
    if (_publishComment.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据国家网信部《互联网跟帖评论服务管理规定》要求，需要绑定手机号后才可以发表评论~"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"立即绑定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            LDBindingPhoneNumViewController *bpnc = [[LDBindingPhoneNumViewController alloc] init];
            [self.navigationController pushViewController:bpnc animated:YES];
            
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            [action setValue:MainColor forKey:@"_titleTextColor"];
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        if (self.iscanUser) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:self.publishComment];
            return;
        }
        
        if ([_publishComment isEqualToString:@"NO"]) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"暂时不能评论,如有问题请联系客服~"];
        }else if ([_publishComment isEqualToString:@"YES"]){
            if (self.textView.text.length == 0) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入评论内容~"];
            }else{
                NSString *url;
                NSDictionary *parameters;

                if (_dataArray.count != 0 ) {
                    if (_replyUid.length == 0) {
                        parameters = @{@"content":self.textView.text,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"atuid":self.sendatuid?:@"",@"atuname":self.sendatuname?:@""};
                    }else{
                        parameters = @{@"content":self.textView.text,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"otheruid":_replyUid,@"atuid":self.sendatuid?:@"",@"atuname":self.sendatuname?:@""};
                    }
                }else{
                    parameters = @{@"content":self.textView.text,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"atuid":self.sendatuid?:@"",@"atuname":self.sendatuname?:@""};
                }
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,sendCommentNewredUrl];
                [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                    NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
                    if (integer != 2000) {
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                    }else{
                        self.textView.text = @"";
                        _replyUid = @"";
                        _introduceLabel.text = @"";
                        _introduceLabel.hidden = YES;
                        _page = 0;
                        [_dataArray removeAllObjects];
                        [self createData:@"1"];
                        [self createScanData];
                        
                        if (_commentBlock) {
                            self.commentBlock([NSString stringWithFormat:@"%d",[_commentNum intValue]]);
                        }
                    }
                } failed:^(NSString *errorMsg) {
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"评论失败,请稍后重试~"];
                }];
            }
        }
     }
}

-(void)touserinfovc:(NSString *)userId
{
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    ivc.userID = userId;
    [self.navigationController pushViewController:ivc animated:YES];
}

#pragma mark - 监听事件
- (void)keyboardWillChangeFrame:(NSNotification *) note {
    
    if (self.iskeyboardTop) {
        return;
    }
    // 1.取得弹出后的键盘frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.键盘弹出的耗时时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 3.键盘变化时，view的位移，包括了上移/恢复下移
    CGFloat transformY = keyboardFrame.size.height;
    //    NSLog(@"%f",_transformY);
    
    [UIView animateWithDuration:duration animations:^{
        self.sendView.hidden = NO;
        self.sendView.transform = CGAffineTransformMakeTranslation(0, -transformY);
    }];
}

- (void)keyboardChangeFrame:(NSNotification *) note {
    self.iskeyboardTop = NO;
    // 1.取得弹出后的键盘frame
    //    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.键盘弹出的耗时时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 3.键盘变化时，view的位移，包括了上移/恢复下移
    //    CGFloat transformY = keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.sendView.transform = CGAffineTransformMakeTranslation(0,0);
        self.sendView.hidden = YES;
    }];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"动态详情打赏成功" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSArray<NSTextCheckingResult *> *)findAllAt
{
    // 找到文本中所有的@
    NSString *string = self.textView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        [self.introduceLabel setHidden:NO];
    }else{
        [self.introduceLabel setHidden:YES];
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if(textView.text.length > 256){
            textView.text = [textView.text substringToIndex:256];
        }
    }
    
    if (textView.text.length!=0) {
        
        NSRange range = textView.selectedRange;
        
        NSString *str = [textView.text substringWithRange:NSMakeRange(range.location-1, 1)];
        
        if ([str isEqualToString:@"@"]) {
            
            NSMutableString *newText = [[NSMutableString alloc] initWithString:self.textView.text];
            [newText deleteCharactersInRange:NSMakeRange(range.location-1, 1)];
            
            LDSelectpersonpageVC *VC = [LDSelectpersonpageVC new];
            VC.newblock = ^(NSMutableArray * _Nonnull allUid, NSMutableArray * _Nonnull nameArr, int personNumber) {
                if (personNumber == 0) {

                    NSString *nameText = [nameArr componentsJoinedByString:@""];
                    NSMutableString *mustr1 = newText.mutableCopy;
                    [mustr1 insertString:nameText atIndex:range.location-1];
                    
                    self.textView.text = mustr1;
                    self.textView.text = [self.textView.text stringByAppendingString:@" "];
                    
                    [self.sendatunameArray addObjectsFromArray:nameArr];
                    [self.sendatuidArray addObjectsFromArray:allUid];
                    
                    self.sendatuname = [self.sendatunameArray componentsJoinedByString:@","];
                    self.sendatuid = [self.sendatuidArray  componentsJoinedByString:@","];
                    
                }
                
                if (allUid.count==0) {

                    self.textView.text = newText;
                }
            };
            VC.returnblock = ^{
                
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    
}

/**
 *  光标位置删除
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]) {
        self.textView.text = @"";
        _replyUid = @"";
        _introduceLabel.text = @"";
        _introduceLabel.hidden = YES;
        [textView resignFirstResponder];
        return NO;
    }

    // 判断删除的是一个@中间的字符就整体删除
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    NSArray *matches = [self findAllAt];
    
    BOOL inAt = NO;
    NSInteger index = range.location;
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            inAt = YES;
            index = match.range.location;
            NSString *str2 = [string substringWithRange:match.range];
            [string replaceCharactersInRange:match.range withString:@""];
            NSInteger inde =[self.sendatunameArray indexOfObject:str2];
       
            if (self.sendatunameArray.count>=inde) {
                [self.sendatunameArray removeObjectAtIndex:inde];
                [self.sendatuidArray removeObjectAtIndex:inde];
            }
            
            if (self.sendatunameArray.count!=0) {
                self.sendatuname = [self.sendatunameArray componentsJoinedByString:@","];
            }
            if (self.sendatuidArray.count!=0) {
                self.sendatuid = [self.sendatuidArray componentsJoinedByString:@","];
            }
            break;
        }
    }
    
    if (inAt)
    {
        textView.text = string;
        textView.selectedRange = NSMakeRange(index, 0);
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    // 光标不能点落在@词中间
    NSRange ranges = textView.selectedRange;
    NSArray *matches = [self findAllAt];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location+1, match.range.length-1);
        if (NSLocationInRange(ranges.location, newRange))
        {
            textView.selectedRange = NSMakeRange(match.range.location + match.range.length-1, 0);
            
            break;
        }
    }
}


-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if ([_ownUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"blvip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"bkvip"] intValue]==1) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]!=1) {
                [self createAdminHidden:alert];
            }
        }
        
        UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {

            YSActionSheetView* ysSheet = [[YSActionSheetView alloc] initNYSView];
            ysSheet.delegate = self;
            ysSheet.isTwo = YES;
            ysSheet.name = self.nickName;
            ysSheet.pic = self.picStr;
            ysSheet.comeFrom = @"Dynamic";
            ysSheet.shareId = self.did;
            [self.view addSubview:ysSheet];
        }];

        NSString *stick;
        
        if ([_stickstate intValue] == 0) {
            
            stick = @"置顶(vip)";
            
        }else{
        
            stick = @"取消置顶";
        }
        
        UIAlertAction * topAction = [UIAlertAction actionWithTitle:stick style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            
            if ([_stickstate intValue] == 0) {
                
                NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
                
                NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setStickDynamic"];
                [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                    NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
                    
                    if (integer == 4001) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        [self createGoOpenMemberVip:@"动态置顶功能VIP会员可用哦~"];
                        
                    }else if(integer == 2000){
                        
                        hud.labelText = @"置顶成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                        
                        self.recommendView.hidden = NO;
                        
                        _stickstate = @"1";
                        
                    }else{
                        
                        hud.labelText = @"置顶失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                    }
                } failed:^(NSString *errorMsg) {
                    [hud removeFromSuperview];
                }];
   
            }else{
                
                NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
                
                NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setUnStickDynamic"];
                
                [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                    NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
                    
                    if(integer == 2000){
                        
                        hud.labelText = @"取消置顶成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        if ([_recommendstate intValue] == 0) {
                            
                            self.recommendView.hidden = YES;
                            
                        }else{
                            
                            self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                            self.recommendView.hidden = NO;
                        }
                        
                        _stickstate = @"0";
                        
                    }else{
                        
                        hud.labelText = @"取消置顶失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                    }
                } failed:^(NSString *errorMsg) {
                     [hud removeFromSuperview];
                }];
            }
        }];

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            //创建黑V推荐置顶
            [self createAdminRecommendAndStick:alert];
            
            //黑V隐藏动态
            [self createAdminHidden:alert];
        }
        
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"编辑(svip)" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1) {
                
                LDAlertOtherDynamicViewController *dvc = [[LDAlertOtherDynamicViewController alloc] init];
                dvc.block = ^(NSString *content) {
                    [self.tableView.mj_header beginRefreshing];
                };
                dvc.did = self.did;
                [self.navigationController pushViewController:dvc animated:YES];
                
            }else{
                
                [self createGoOpenMemberVip:@"编辑功能限SVIP会员可用~"];
            }
        }];
        
        [alert addAction:alertAction];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [alertAction setValue:MainColor forKey:@"_titleTextColor"];

        }
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        [alert addAction:cancel];

        [alert addAction:topAction];
        
        [alert addAction:shareAction];
        
        //删除动态
        [self createDeleteDynamic:alert type:@"user"];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [shareAction setValue:MainColor forKey:@"_titleTextColor"];
            
            [topAction setValue:MainColor forKey:@"_titleTextColor"];
            
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
        }

        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([_ownUid intValue] != [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] intValue]) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"blvip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"bkvip"] intValue]==1) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]!=1) {
                [self createAdminHidden:alert];
            }
        }

        NSString *auditMark = self.model.auditMark.copy;
        NSString *auditmarkStr = [NSString new];
        if ([auditMark intValue]==0) {
            auditmarkStr = @"标记";
        }
        else
        {
            auditmarkStr = @"取消标记";
        }
        UIAlertAction *auditAction = [UIAlertAction actionWithTitle:auditmarkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *url = [PICHEADURL stringByAppendingString:setDynamicAuditMarkUrl];
            NSString *type = @"";
            if ([auditMark intValue]==0) {
                type = @"1";
                
            }
            else
            {
                type = @"0";
                
            }
            NSDictionary *param = @{@"type":type?:@"",@"did":self.did};
            [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                    [MBProgressHUD showMessage:[responseObj objectForKey:@"msg"]];
                    if ([type intValue]==1) {
                        self.model.auditMark = @"1";
                    }
                    else
                    {
                        self.model.auditMark = @"0";
                    }
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        }];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            [auditAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue]==1) {
            [alert addAction:auditAction];
        }
        
        NSString *reportState;
        
        if ([_reportstate intValue] == 1) {
            
            reportState = @"已举报";
            
        }else{
        
            reportState = @"举报";
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:reportState style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            if ([_reportstate intValue] == 1) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您已举报过该动态,不能再次举报~"];
  
            }else{
            
                LDReportResonViewController *rvc = [[LDReportResonViewController alloc] init];
                
                rvc.type = @"dynamic";
                
                __weak typeof(self) weakself = self;
                
                rvc.block = ^(NSString *reason) {
                   
                    weakself.reportstate = reason;
                    
                };
                
                rvc.did = _did;
                
                [self.navigationController pushViewController:rvc animated:YES];
            }
            
        }];
        
        UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            //[_shareView controlViewShowAndHide:nil];
            
            YSActionSheetView * ysSheet = [[YSActionSheetView alloc] initNYSView];
            ysSheet.delegate = self;
            ysSheet.isTwo = YES;
            ysSheet.name = self.nickName;
            ysSheet.pic = self.picStr;
            ysSheet.comeFrom = @"Dynamic";
            ysSheet.shareId = self.did;
            [self.view addSubview:ysSheet];
        }];
        
        NSString *collect;
        
        if ([_collectstate intValue] == 0) {
            
            collect = @"收藏";
            
        }else{
            
            collect = @"取消收藏";
        }
        
        UIAlertAction * collectAction = [UIAlertAction actionWithTitle:collect style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            
            NSString *url;
            
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
            
            if ([_collectstate intValue] == 0) {
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/collectDynamic"];
            }else{
                
                url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/cancelCollectDynamic"];
            }

            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
                
                if(integer == 2000){
                    
                    if ([_collectstate intValue] == 0) {
                        
                        hud.labelText = @"收藏成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        _collectstate = @"1";
                        
                    }else{
                        
                        hud.labelText = @"取消收藏成功";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                        _collectstate = @"0";
                    }
                    
                }else{
                    
                    if ([_collectstate intValue] == 0) {
                        
                        hud.labelText = @"收藏失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                        
                    }else{
                        
                        hud.labelText = @"取消收藏失败";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1];
                    }
                }
            } failed:^(NSString *errorMsg) {
                 [hud removeFromSuperview];
            }];
        }];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            //创建黑V推荐置顶
            [self createAdminRecommendAndStick:alert];
            
            //创建删除动态
           // [self createDeleteDynamic:alert type:@"is_admin"];
            
            UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"编辑(svip)" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                LDAlertOtherDynamicViewController *dvc = [[LDAlertOtherDynamicViewController alloc] init];
                dvc.block = ^(NSString *content) {
                    [self.tableView.mj_header beginRefreshing];
                };
                dvc.did = self.did;
                [self.navigationController pushViewController:dvc animated:YES];
            }];
            if (PHONEVERSION.doubleValue >= 8.3) {
                [alertAction setValue:MainColor forKey:@"_titleTextColor"];
            }
            [alert addAction:alertAction];
            //黑V隐藏动态
            [self createAdminHidden:alert];
        }
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        [alert addAction:cancel];
        if (PHONEVERSION.doubleValue >= 8.3) {
            [action setValue:MainColor forKey:@"_titleTextColor"];
            [shareAction setValue:MainColor forKey:@"_titleTextColor"];
            [cancel setValue:MainColor forKey:@"_titleTextColor"];
            [collectAction setValue:MainColor forKey:@"_titleTextColor"];
        }
        [alert addAction:shareAction];
        [alert addAction:collectAction];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/**
 黑V隐藏动态
 */
- (void)createAdminHidden:(UIAlertController *)alert{
    
    NSString *hidden;
    
    if ([_is_hidden intValue] == 0) {
        
        hidden = @"隐藏动态";
        
    }else{
        
        hidden = @"取消隐藏";
    }
    
    UIAlertAction * hiddenAction = [UIAlertAction actionWithTitle:hidden style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        NSString *url;
        
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
        
        if ([_is_hidden intValue] == 0) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/editHiddenState/method/forbid"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/editHiddenState/method/resume"];
        }
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if(integer == 2000){
                
                if ([_is_hidden intValue] == 0) {
                    
                    hud.labelText = @"隐藏动态成功";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                    self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
                    self.recommendView.hidden = NO;
                    _is_hidden = @"1";
                    
                }else{
                    
                    hud.labelText = @"取消隐藏成功";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                    if ([_recommendstate intValue] == 0) {
                        
                        self.recommendView.hidden = YES;
                        
                    }else{
                        
                        self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                        self.recommendView.hidden = NO;
                    }
                    
                    _is_hidden = @"0";
                }
                
                
            }else{
                
                if ([_is_hidden intValue] == 0) {
                    
                    hud.labelText = @"隐藏动态失败";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    
                }else{
                    
                    hud.labelText = @"取消隐藏失败";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
            }
        } failed:^(NSString *errorMsg) {
            [hud removeFromSuperview];
        }];
    }];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [hiddenAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:hiddenAction];
}

/**
 删除动态的方法
 */
-(void)createDeleteDynamic:(UIAlertController *)alert type:(NSString *)type{
    
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did};
        
        NSString *url;
        
        if ([type isEqualToString:@"is_admin"]) {
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/delDynamic"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/dynamic/delDynamic"];
        }
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                
                
            }else{
                
                if (_deleteBlock) {
                    
                    self.deleteBlock();
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }];
    
    [alert addAction:report];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        [report setValue:MainColor forKey:@"_titleTextColor"];
    }
}

/**
 判断是否是会员
 */
-(void)createGoOpenMemberVip:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];

    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:cancelAction];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
   创建黑V推荐置顶
 */
-(void)createAdminRecommendAndStick:(UIAlertController *)alert{
    
    UIAlertAction * adminRecommendAction = [UIAlertAction actionWithTitle:@"推荐" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self createAdminRecommendData:@"1"];
        
    }];
    
    [alert addAction:adminRecommendAction];

    
    if([_recommend intValue] > 0){
        
        UIAlertAction * adminCancelRecommendAction = [UIAlertAction actionWithTitle:@"取消推荐" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self createAdminRecommendData:@"2"];
            
        }];
        
        [alert addAction:adminCancelRecommendAction];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [adminCancelRecommendAction setValue:MainColor forKey:@"_titleTextColor"];
        }
    }
    
    UIAlertAction * adminStickAction = [UIAlertAction actionWithTitle:@"置顶" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self createAdminStickData:@"1"];
        
    }];
    
    [alert addAction:adminStickAction];
    
    if ([_recommendall intValue] > 0) {
        
        UIAlertAction * adminCancelStickAction = [UIAlertAction actionWithTitle:@"取消置顶" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self createAdminStickData:@"2"];
            
        }];
        [alert addAction:adminCancelStickAction];
        if (PHONEVERSION.doubleValue >= 8.3) {
            [adminCancelStickAction setValue:MainColor forKey:@"_titleTextColor"];
        }
    }
    if (PHONEVERSION.doubleValue >= 8.3) {
        [adminRecommendAction setValue:MainColor forKey:@"_titleTextColor"];
        [adminStickAction setValue:MainColor forKey:@"_titleTextColor"];
    }
}

/**
 黑V推荐的数据请求
 */
-(void)createAdminRecommendData:(NSString *)type{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *url;
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"method":@"0"};
    
    if ([type intValue] == 1){
        //推荐
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setDynamicRerommend"];
        
    }else{
        //取消推荐
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/cancelDynamicRerommend"];
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if(integer == 2000){
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"推荐成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommend = @"1";
                
            }else{
                
                hud.labelText = @"取消推荐成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommend = @"0";
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"推荐失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            }else{
                
                hud.labelText = @"取消推荐失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 黑V置顶的数据请求
 */
-(void)createAdminStickData:(NSString *)type{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *url;
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":_did,@"method":@"1"};
    
    if ([type intValue] == 1) {
        //置顶
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/setDynamicRerommend"];
        
    }else{
        //取消置顶
        url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/cancelDynamicRerommend"];
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if(integer == 2000){
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"置顶成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommendall = @"1";
                
            }else{
                
                hud.labelText = @"取消置顶成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                _recommendall = @"0";
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                hud.labelText = @"置顶失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            }else{
                
                hud.labelText = @"取消置顶失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
        }
    } failed:^(NSString *errorMsg) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (IBAction)imageButtonClick:(id)sender {
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    if (self.ownUid.length!=0) {
        ivc.userID = _ownUid;
    }
    else
    {
        ivc.userID = self.model.uid;
    }
    
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)customActionSheetButtonClick:(YSActionSheetButton *) btn
{
    if (btn.tag==5) {
        LDSharepageVC *vc = [[LDSharepageVC alloc] init];
        vc.content = self.model.content;
        vc.did = self.model.did;
        vc.typeStr = @"0";
        vc.userid = self.model.uid;
        if (self.model.pic.count!=0) {
            vc.pic = [self.model.pic firstObject];
        }
        else
        {
            vc.pic = @"";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
