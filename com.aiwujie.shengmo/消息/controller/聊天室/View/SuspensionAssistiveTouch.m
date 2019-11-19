//
//  SuspensionAssistiveTouch.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "SuspensionAssistiveTouch.h"
#import "UIView+Extension.h"
#import "ChatroomVC.h"
#import <RongRTCLib/RongRTCLib.h>

@interface SuspensionAssistiveTouch ()
@property(nonatomic,strong) UIImageView *iconImg;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) ChatroomVC *chatVC;
@end

@implementation SuspensionAssistiveTouch

static SuspensionAssistiveTouch *defaultTool = nil;

//单例模式对外的唯一接口，用到的dispatch_once函数在一个应用程序内只会执行一次，且dispatch_once能确保线程安全

+(SuspensionAssistiveTouch*)defaultTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultTool == nil) {
            defaultTool = [[self alloc] init];
        }
    });
    return defaultTool;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultTool == nil) {
            defaultTool = [super allocWithZone:zone];
        }
    });
    return defaultTool;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
-(id)copy{
    
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
-(id)mutableCopy{
    return self;
}

-(instancetype)init
{
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height/2-25, 80, 50);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 25;
        self.windowLevel = UIWindowLevelAlert + 1;
        [self makeKeyAndVisible];

        [self addSubview:self.iconImg];
//        [self addSubview:self.titleLab];
        [self addSubview:self.backBtn];
        [self setuplayout];
        
        self.backgroundColor = [UIColor colorWithHexString:@"FD407B" alpha:1];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [self addGestureRecognizer:pan];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesturRecognizer];
        self.alpha = 0;
        
        [kNotificationCenter addObserver:self selector:@selector(suspensionAssistiveTouch) name:kSuspensionViewShowNotificationName object:nil];
        
    }
    return self;
}

-(void)tapAction
{
    [self suspensionAssistiveTouch];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    weakSelf.iconImg.frame = CGRectMake(5, 5, 40, 40);
//    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf);
//        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(3);
//        make.right.equalTo(weakSelf).with.offset(-15);
//        make.height.mas_offset(15);
//    }];
//    weakSelf.titleLab.frame = CGRectMake(50, 10, 100, 30);
    weakSelf.backBtn.frame = CGRectMake(50, 15, 20, 20);
}

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.backgroundColor = [UIColor whiteColor];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
        _iconImg.hidden = YES;
    }
    return _iconImg;
}


-(UIButton *)backBtn
{
    if(!_backBtn)
    {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"关闭2"] forState:normal];
        [_backBtn addTarget:self action:@selector(backbtnClick) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}

-(void)showView
{
    self.alpha = 1;
    self.iconImg.hidden = NO;
//    self.titleLab.hidden = NO;
    self.backBtn.hidden = NO;
//    self.titleLab.text = [self.infoDic objectForKey:@"name"]?:@"";
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"zm-聊天室"]];
}

-(void)dismissView
{
    self.hidden = YES;
    self.iconImg.hidden = YES;
//    self.titleLab.hidden = YES;
    self.backBtn.hidden = YES;
}

-(void)backbtnClick
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[RongRTCEngine sharedEngine] leaveRoom:self.roomidStr completion:^(BOOL isSuccess, RongRTCCode code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    
    if ([self.str0 intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]||[self.str1 intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        NSString *url = [PICHEADURL stringByAppendingString:chatroomDownMicrophoneUrl];
        NSDictionary *params = @{@"roomid":self.roomidStr?:@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]?:@""};
        [NetManager afPostRequest:url parms:params finished:^(id responseObj) {
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        self.alpha = 0;
        self.iconImg.hidden = YES;
//        self.titleLab.hidden = YES;
        self.backBtn.hidden = YES;
    } completion:^(BOOL finished) {
        
        [kWindow endEditing:YES];
    }];
}

-(void)suspensionAssistiveTouch {

    NSNotification *notification = [NSNotification notificationWithName:SUPVIEWNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        self.alpha = 0;
        self.iconImg.hidden = YES;
//        self.titleLab.hidden = YES;
        self.backBtn.hidden = YES;
    } completion:^(BOOL finished) {
        [kWindow endEditing:YES];
    }];
    
}

-(UINavigationController *)currentTabbarSelectedNavigationController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }else if([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabarController = [self currentTtabarController];
        UINavigationController *selectedNV = (UINavigationController *)tabarController.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }
    
    return nil;
}

-(UITabBarController *)currentTtabarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}


-(void)changePostion:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    self.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self beginPoint];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self changePoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self endPoint];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self endPoint];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)beginPoint {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        self.alpha = 1.0;
    }];
}

- (void)changePoint {
    
    BOOL isOver = NO;
    
    CGRect frame = self.frame;
    
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
        isOver = YES;
    } else if (frame.origin.x+frame.size.width > kWindow.Sw) {
        frame.origin.x = kWindow.Sw - frame.size.width;
        isOver = YES;
    }
    
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
        isOver = YES;
    } else if (frame.origin.y+frame.size.height > kWindow.Sh) {
        frame.origin.y = kWindow.Sh - frame.size.height;
        isOver = YES;
    }
    if (isOver) {
        [UIView animateWithDuration:kPrompt_DismisTime animations:^{
            self.frame = frame;
        }];
    }
}

static CGFloat _allowance = 30;

- (void)endPoint {
    
    if (self.X <= kWindow.Sw / 2 - self.Sw/2) {
        
        if (self.Y >= kWindow.Sh - self.Sh - _allowance) {
            self.Y = kWindow.Sh - self.Sh;
        }else
        {
            if (self.Y <= _allowance) {
                self.Y = 0;
            }else
            {
                self.X = 0;
            }
        }
        
    }else
    {
        if (self.Y >= kWindow.Sh - self.Sh - _allowance) {
            self.Y = kWindow.Sh - self.Sh;
        }else
        {
            if (self.Y <= _allowance) {
                self.Y = 0;
            }else
            {
                self.X = kWindow.Sw - self.Sw;
            }
        }
    };

}

-(void)setX:(CGFloat)X
{
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        [super setX:X];
    }];
}

-(void)setY:(CGFloat)Y
{
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        [super setY:Y];
    }];
}

@end
