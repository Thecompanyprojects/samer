//
//  LDAttentionsetVC.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/10.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentionsetVC.h"
#import "LDAttentionpersonVC.h"
#import "LDAttentiongroupModel.h"

@interface LDAttentionsetVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSMutableArray *sortArray;

@end

static NSString *attentionsetidentfity = @"attentionsetidentfity";

@implementation LDAttentionsetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组设置";
    self.dataSource = [NSMutableArray array];
    self.sortArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self.tableView addGestureRecognizer:longTap];
    [self getdatafromweb];
}

-(void)getdatafromweb
{
    [self.dataSource removeAllObjects];
    NSString *url = [PICHEADURL stringByAppendingString:getfriendgrouplistUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *params = @{@"uid":uid};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSArray *data = [NSArray yy_modelArrayWithClass:[LDAttentiongroupModel class] json:responseObj[@"data"]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.tableView reloadData];
        
    } failed:^(NSString *errorMsg) {

    }];
}

-(void)rightbtns
{
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [right setTitle:@"新建" forState:UIControlStateNormal];
    [right setTitleColor:TextCOLOR forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入分组名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入分组名称";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);

        NSString *url = [PICHEADURL stringByAppendingString:addfriendgroupUrl];
        NSString *fgname = envirnmentNameTextField.text?:@"";
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        if (fgname.length==0) {
//            [MBProgressHUD showMessage:@"请输入分组名称"];
            [AlertTool alertqute:self andTitle:@"提示" andMessage:@"请输入分组名称"];
            return ;
        }
        NSString *newFgname = [NSString new];
        if (fgname.length>4) {
            [AlertTool alertqute:self andTitle:@"提示" andMessage:@"限4字以内"];
            newFgname = [fgname substringToIndex:4];
            return;
        }
        else
        {
            newFgname = fgname.copy;
        }
        NSDictionary *params = @{@"uid":uid,@"fgname":newFgname?:@""};
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            
            NSString *msg = [responseObj objectForKey:@"msg"];
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                [self getdatafromweb];
            }
            [MBProgressHUD showMessage:msg toView:self.view];
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - getters

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, WIDTH-30, 40)];
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = MainColor;
        titleLab.text = @"新建分组";
        [_headView addSubview:titleLab];
        UIImageView *leftImg = [UIImageView new];
        leftImg.image = [UIImage imageNamed:@"jiajia"];
        leftImg.frame = CGRectMake(15, 19, 20, 20);
        [_headView addSubview:leftImg];
        _headView.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside)];
        [_headView addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _headView;
}

-(void)labelTouchUpInside
{
    [self rightButtonOnClick];
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionsetidentfity];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attentionsetidentfity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LDAttentiongroupModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@%@%@%@",model.fgname?:@"",@"(",model.num,@")"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TextCOLOR;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDAttentiongroupModel *model = self.dataSource[indexPath.row];
    LDAttentionpersonVC *PVC = [LDAttentionpersonVC new];
    PVC.groupModel = model;
    __weak typeof (self) weakSelf = self;
    PVC.Complate = ^{
        [weakSelf getdatafromweb];
    };
    [self.navigationController pushViewController:PVC animated:YES];
}

#pragma mark - 左滑删除

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *url = [PICHEADURL stringByAppendingString:delfriendgroupUrl];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        LDAttentiongroupModel *model = self.dataSource[indexPath.row];
        NSString *fgid = model.Newid;
        NSDictionary *params = @{@"uid":uid,@"fgid":fgid?:@""};
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
    
}

#pragma mark - Cell拖动排序
- (void)handlelongGesture:(UILongPressGestureRecognizer *)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                snapshot = [self customSnapshoFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {

                [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
 
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0f;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    UIView *snapshot = nil;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
        //ios7.0 以下通过截图形式保存快照
        snapshot = [self customSnapShortFromViewEx:inputView];
    }else{
        //ios7.0 系统的快照方法
        snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    }
    
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (UIView *)customSnapShortFromViewEx:(UIView *)inputView
{
    CGSize inSize = inputView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

#pragma mark - 顺序

-(void)changesort
{
    for (int i = 0; i<self.dataSource.count; i++) {
        LDAttentiongroupModel *model = [self.dataSource objectAtIndex:i];
        [self.sortArray addObject:model.Newid];
    }
    NSString *url = [PICHEADURL stringByAppendingString:friendgroupsortUrl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *sort = [self.sortArray componentsJoinedByString:@","];
    NSDictionary *params = @{@"uid":uid,@"sort":sort?:@""};
    [NetManager afPostRequest:url parms:params finished:^(id responseObj) {

    } failed:^(NSString *errorMsg) {

    }];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        if (self.Returnback) {
            self.Returnback();
        }
        [self changesort];
    }
}

@end
