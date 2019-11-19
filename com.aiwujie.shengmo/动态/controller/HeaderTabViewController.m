//
//  HeaderTabViewController.m
//  HJTabViewControllerDemo
//
//  Created by haijiao on 2017/3/18.
//  Copyright © 2017年 olinone. All rights reserved.
//

#import "HeaderTabViewController.h"
#import "LDPublishDynamicViewController.h"
#import "TableViewController.h"
#import "HJTabViewControllerPlugin_HeaderScroll.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"
#import "HJDefaultTabViewBar.h"

@interface HeaderTabViewController () <HJTabViewControllerDataSource, HJTabViewControllerDelagate, HJDefaultTabViewBarDelegate>
@property (strong, nonatomic)  UIView *headerView;
@property (nonatomic,strong) NSMutableDictionary *dict;
//参与话题按钮
@property (nonatomic,strong) UIButton *joinTopicButton;
@end

@implementation HeaderTabViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"话题";
    
    self.tabDataSource = self;
    self.tabDelegate = self;
    
    HJDefaultTabViewBar *tabViewBar = [HJDefaultTabViewBar new];
    tabViewBar.delegate = self;
    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
    
    [self enablePlugin:tabViewBarPlugin];
    
    [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
    
    _dict = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getTopicDetail"];
    if (self.tid.length == 0) {
        self.tid = @"";
    }
    NSDictionary *parameters = @{@"tid":self.tid};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 3000) {
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            _headerView.frame = CGRectMake(0, 0, WIDTH, 44);
            
        }else if(integer == 2000){
            
            [_dict setDictionary:responseObj[@"data"]];
            
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 210)];
            _headerView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *headerBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 210)];
            [headerBackImage sd_setImageWithURL:[NSURL URLWithString:_dict[@"pic"]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            headerBackImage.contentMode = UIViewContentModeScaleAspectFill;
            headerBackImage.clipsToBounds = YES;
            [_headerView addSubview:headerBackImage];
            
            UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 210)];
            alphaView.backgroundColor = [UIColor whiteColor];
            alphaView.alpha = 0.93;
            [_headerView addSubview:alphaView];
            
            UIImageView *topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 33, 75, 75)];
            [topicImageView sd_setImageWithURL:[NSURL URLWithString:_dict[@"pic"]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            topicImageView.userInteractionEnabled = YES;
            [topicImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicImageView:)]];
            [_headerView addSubview:topicImageView];
            
            UILabel *topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topicImageView.frame) + 14, 30, WIDTH - CGRectGetMaxX(topicImageView.frame) - 2 * 14, 21)];
            topicLabel.text = [NSString stringWithFormat:@"#%@#",_dict[@"title"]];
            topicLabel.font = [UIFont boldSystemFontOfSize:16];
            topicLabel.textColor = MainColor;
            [_headerView addSubview:topicLabel];
            
            UILabel *topicIntroduceLabel = [[UILabel alloc] init];
            topicIntroduceLabel.text = _dict[@"introduce"];
            topicIntroduceLabel.font = [UIFont systemFontOfSize:14];
            topicIntroduceLabel.numberOfLines = 0;
            topicIntroduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize size = [topicIntroduceLabel sizeThatFits:CGSizeMake(CGRectGetWidth(topicLabel.frame), MAXFLOAT)];
            topicIntroduceLabel.frame = CGRectMake(CGRectGetMinX(topicLabel.frame), CGRectGetMaxY(topicLabel.frame) + 20, CGRectGetWidth(topicLabel.frame), size.height);
            [_headerView addSubview:topicIntroduceLabel];
            
            UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topicLabel.frame), CGRectGetMaxY(topicIntroduceLabel.frame) + 20, 70, 21)];
            inviteLabel.text = [NSString stringWithFormat:@"%@来访",_dict[@"readtimes"]];
            inviteLabel.font = [UIFont systemFontOfSize:13];
            [_headerView addSubview:inviteLabel];
            
            UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 70 - 11, CGRectGetMaxY(topicIntroduceLabel.frame) + 20, 70, 21)];
            joinLabel.text = [NSString stringWithFormat:@"%@参与",_dict[@"partaketimes"]];
            joinLabel.textAlignment = NSTextAlignmentRight;
            joinLabel.font = [UIFont systemFontOfSize:13];
            [_headerView addSubview:joinLabel];
            
            UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inviteLabel.frame), CGRectGetMaxY(topicIntroduceLabel.frame) + 20, CGRectGetMinX(joinLabel.frame) - CGRectGetMaxX(inviteLabel.frame), 21)];
            dynamicLabel.text = [NSString stringWithFormat:@"%@动态",_dict[@"dynamicnum"]];
            dynamicLabel.textAlignment = NSTextAlignmentCenter;
            dynamicLabel.font = [UIFont systemFontOfSize:13];
            [_headerView addSubview:dynamicLabel];
            
            _headerView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(dynamicLabel.frame) + 44 + 20);
            alphaView.frame = _headerView.frame;
            headerBackImage.frame = _headerView.frame;
            if ([_dict[@"is_admin"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
                [self createJoinTopicButton];
            }
            [self reloadData];
        }
    } failed:^(NSString *errorMsg) {
        _headerView.frame = CGRectMake(0, 0, WIDTH, 44);

    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideJoinTopicButton) name:@"参与话题按钮隐藏" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showJoinTopicButton) name:@"参与话题按钮显示" object:nil];
    
   
}


- (void)tapTopicImageView:(UITapGestureRecognizer *)tap{
    
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:0 imagesBlock:^NSArray *{
        UIImageView *imageView = (UIImageView *)tap.view;
        NSArray *array = [NSArray arrayWithObject:imageView.image];
        return array;
    }];
}

-(void)hideJoinTopicButton{

    _joinTopicButton.hidden = YES;
}

-(void)showJoinTopicButton{

    _joinTopicButton.hidden = NO;
}

-(void)createJoinTopicButton{
    
    CGFloat joinTopicW = 106;
    CGFloat joinTopicH = 44;
    CGFloat joinTopicBottomY = 100;
    
    if (ISIPHONEX) {
        _joinTopicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - joinTopicW)/2, HEIGHT - joinTopicBottomY - joinTopicH - 34 - 24, joinTopicW, joinTopicH)];
    }else{
        
        if (ISIPHONEPLUS) {
            _joinTopicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - (joinTopicW / 375) * WIDTH)/2, HEIGHT - joinTopicBottomY - (joinTopicH / 667) * HEIGHT, (joinTopicW / 375) * WIDTH, (joinTopicH / 667) * HEIGHT)];
        }else{
            _joinTopicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - joinTopicW)/2, HEIGHT - joinTopicBottomY - joinTopicH, joinTopicW, joinTopicH)];
        }
    }
    [_joinTopicButton setBackgroundImage:[UIImage imageNamed:@"参与话题"] forState:UIControlStateNormal];
    [_joinTopicButton addTarget:self action:@selector(joinTopicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_joinTopicButton];
}

-(void)joinTopicButtonClick{
    
    NSString *url = [PICHEADURL stringByAppendingString:@"Api/users/getGirlState"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *dict = @{@"uid":uid};
    [NetManager afPostRequest:url parms:dict finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            LDPublishDynamicViewController *dvc = [[LDPublishDynamicViewController alloc] init];
            dvc.topicString = [NSString stringWithFormat:@"#%@#",_dict[@"title"]];
            dvc.topicTid = [NSString stringWithFormat:@"%@",_dict[@"tid"]];
            dvc.index = self.index;
            [self.navigationController pushViewController:dvc animated:YES];
        }
        else
        {
            NSString *msg = [responseObj objectForKey:@"msg"];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:msg];
        }
       
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark -

- (NSInteger)numberOfTabForTabViewBar:(HJDefaultTabViewBar *)tabViewBar {
    return [self numberOfViewControllerForTabViewController:self];
}

- (id)tabViewBar:(HJDefaultTabViewBar *)tabViewBar titleForIndex:(NSInteger)index {
    if (index == 0) {
        return @"最新";
    }
    return @"热门";
}

- (void)tabViewBar:(HJDefaultTabViewBar *)tabViewBar didSelectIndex:(NSInteger)index {
    
    BOOL anim = labs(index - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:index animated:anim];
}

#pragma mark -

- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
    self.navigationController.navigationBar.alpha = 1;
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    
    return 2;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    
    TableViewController *vc = [TableViewController new];
    vc.index = index;
    vc.tid = self.tid;
    return vc;
}

- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    return _headerView;
}

- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    
    return HJTabViewBarDefaultHeight;
}

//控制下方的两个tableview的偏移量
- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
