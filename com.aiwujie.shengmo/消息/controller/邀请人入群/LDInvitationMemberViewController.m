//
//  LDInvitationMemberViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/6.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDInvitationMemberViewController.h"
#import "LDInvitationMemberPageViewController.h"
#import "TableModel.h"

@interface LDInvitationMemberViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;

@property (nonatomic, strong) LDInvitationMemberPageViewController *invitationMemberPageViewController;

@property (nonatomic, strong) NSMutableArray *allStorageArray;

@property (weak, nonatomic) IBOutlet UIView *chatLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentLabel;

@end

@implementation LDInvitationMemberViewController

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDInvitationMemberPageViewController *v1 = [[LDInvitationMemberPageViewController alloc] init];
        LDInvitationMemberPageViewController *v2 = [[LDInvitationMemberPageViewController alloc] init];
        LDInvitationMemberPageViewController *v3 = [[LDInvitationMemberPageViewController alloc] init];
        LDInvitationMemberPageViewController *v4 = [[LDInvitationMemberPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        [arrayM addObject:v3];
        [arrayM addObject:v4];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"邀请新成员";
    
    self.chatLabel.layer.cornerRadius = 2;
    self.chatLabel.clipsToBounds = YES;
    
    self.nearLabel.layer.cornerRadius = 2;
    self.nearLabel.clipsToBounds = YES;
    
    self.lookLabel.layer.cornerRadius = 2;
    self.lookLabel.clipsToBounds = YES;
    
    self.attentLabel.layer.cornerRadius = 2;
    self.attentLabel.clipsToBounds = YES;
    
    _allStorageArray = [NSMutableArray array];
    
    [self createPageViewController];
    
    [self createButton];
}

//点击切换页面
- (IBAction)buttonClick:(UIButton *)sender {
    
    LDInvitationMemberPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 10];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:sender.tag - 10];
}

//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDInvitationMemberPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDInvitationMemberPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDInvitationMemberPageViewController *)viewController];
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index++;
    
    if (index == [self.pageContentArray count]) {
        
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    _invitationMemberPageViewController = (LDInvitationMemberPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_invitationMemberPageViewController];
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            [self changeNavButtonColor:index];
        }
        
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDInvitationMemberPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDInvitationMemberPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    
    contentVC.pageContentArray = self.pageContentArray;
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDInvitationMemberPageViewController *)viewController {

    return [viewController.content integerValue];
    
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 10];
    
    for (int i = 10; i < 14; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:i + 10];
        
        if (button.tag == btn.tag) {
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view.hidden = NO;
            
        }else{
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            view.hidden = YES;
        }
    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(completeButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)completeButtonOnClick{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LDInvitationMemberPageViewController *contentVC0 = self.pageContentArray[0];
    LDInvitationMemberPageViewController *contentVC1 = self.pageContentArray[1];
    LDInvitationMemberPageViewController *contentVC2 = self.pageContentArray[2];
    LDInvitationMemberPageViewController *contentVC3 = self.pageContentArray[3];
    
    NSString *uidstr = [NSString string];
    
    if (contentVC0.storageArray.count != 0) {
        
        [_allStorageArray addObjectsFromArray:contentVC0.storageArray];
    }
    
    if (contentVC1.storageArray.count != 0) {
        
        [_allStorageArray addObjectsFromArray:contentVC1.storageArray];
    }
    
    if (contentVC2.storageArray.count != 0) {
        
        [_allStorageArray addObjectsFromArray:contentVC2.storageArray];
    }
    
    if (contentVC3.storageArray.count != 0) {
        
        [_allStorageArray addObjectsFromArray:contentVC3.storageArray];
    }
    
    if (_allStorageArray.count == 0) {
        
        uidstr = @"";
        
    }else if (_allStorageArray.count == 1){
    
        uidstr = _allStorageArray[0];
        
    }else if (_allStorageArray.count > 1){
    
        for (int i = 0; i < _allStorageArray.count; i++) {
            
            if (i == 0) {
                
                uidstr = _allStorageArray[0];
                
            }else{
            
                uidstr = [NSString stringWithFormat:@"%@,%@",uidstr,_allStorageArray[i]];
            }
        }
    }
    
    NSString *gidstr = [NSString string];
    
    if (contentVC0.storageGroupArray.count == 0) {
        
        gidstr = @"";
        
    }else{
    
        if (contentVC0.storageGroupArray.count == 1) {
            
            gidstr = contentVC0.storageGroupArray[0];
            
        }else{
        
            for (int i = 0; i < contentVC0.storageGroupArray.count; i++) {
                
                if (i == 0) {
                    
                    gidstr = contentVC0.storageGroupArray[0];
                    
                }else{
                    
                    gidstr = [NSString stringWithFormat:@"%@,%@",gidstr,contentVC0.storageGroupArray[i]];
                }
            }
        }
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Restrict/inviteOneIntoGroupNew"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"gid":self.gid,@"uidstr":uidstr,@"gidstr":gidstr};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObj objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
