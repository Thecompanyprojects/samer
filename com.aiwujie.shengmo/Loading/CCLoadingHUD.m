//
//  CCLoadingHUD.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCLoadingHUD.h"
#import "CCLodingView.h"
#define whiteWidth 90
#define hudWidth 50
//#import "UtilsMacro.h"

@interface HUDview : UIView

@end

@implementation HUDview

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //设置路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //第一个参数是起点，是圆形的圆心
    //第二个参数是半径
    //第三个参数是起始弧度
    //第四个参数是结束弧度
    //第五个参数是传入yes是顺时针,no为顺时针，下面的另外一种实现方法的参数意思也是一致
    //path addArcWithCenter:<#(CGPoint)#> radius:<#(CGFloat)#> startAngle:<#(CGFloat)#> endAngle:<#(CGFloat)#> clockwise:<#(BOOL)#>
    path.lineWidth = 3;
    [[UIColor whiteColor] set];
    [path addArcWithCenter:CGPointMake(hudWidth*0.5, hudWidth*0.5) radius:20 startAngle:0 endAngle:M_PI_2 clockwise:NO];
    //渲染
    [path stroke];
}


@end



#define instance [CCLoadingHUD shareInstance]


@interface CCLoadingHUD ()

@property (nonatomic, assign) BOOL isShow; //是否在loading
@property (nonatomic, weak) UIView *loadingView;
@property (nonatomic, weak) HUDview *hudV;

@end

@implementation CCLoadingHUD

+ (instancetype) shareInstance{
    static CCLoadingHUD* _instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

+(void)show{
    if (!instance.isShow) {
        instance.isShow = YES;
        UIView *view = [self CreateLoadingViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        instance.loadingView = view;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];
    }
}

+(void)dismiss{
    if (instance.isShow) {
        instance.isShow = NO;
        [instance.loadingView removeFromSuperview];
    }
}

+(UIView *)CreateLoadingViewWithFrame:(CGRect)frame{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    baseView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, whiteWidth, whiteWidth)];
    view.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = whiteWidth*0.5;
    //    view.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:view];
    CCLodingView *loadingV = [[CCLodingView alloc]initWithFrame:CGRectMake(0, 0, hudWidth, hudWidth)];
    loadingV.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    [view addSubview:loadingV];
    [loadingV startAnimation];
    return baseView;
}

+(UIView *)CreateTarotLoadingViewWithFrame:(CGRect)frame{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //    baseView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, whiteWidth, whiteWidth)];
    view.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = whiteWidth*0.5;
    //    view.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:view];
    CCLodingView *loadingV = [[CCLodingView alloc]initWithFrame:CGRectMake(0, 0, hudWidth, hudWidth)];
    loadingV.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    [view addSubview:loadingV];
    [loadingV startAnimation];
    return baseView;
}

-(UIView *)loadingViewMethod{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    baseView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, whiteWidth, whiteWidth)];
    [baseView addSubview:view];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = whiteWidth*0.5;
    view.center = CGPointMake(WIDTH*0.5, HEIGHT*0.5);
    //    view.backgroundColor = [UIColor whiteColor];
    HUDview *hudV = [[HUDview alloc]initWithFrame:CGRectMake(0, 0, hudWidth, hudWidth)];
    self.hudV = hudV;
    //    hudV.backgroundColor = [UIColor whiteColor];
    hudV.center = CGPointMake(whiteWidth*0.5, whiteWidth*0.5);
    [view addSubview:hudV];
    
    CABasicAnimation *rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    
    rotationAnimation.duration = 0.5;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [hudV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    return baseView;
}



@end

