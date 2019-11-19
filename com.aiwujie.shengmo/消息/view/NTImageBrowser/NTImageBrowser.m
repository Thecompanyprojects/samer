//
//  NTImageBrowser.m
//  NTImageBrowser
//
//  Created by Nineteen on 10/5/16.
//  Copyright © 2016 Nineteen. All rights reserved.
//

#import "NTImageBrowser.h"


#define NTDeviceSize [UIScreen mainScreen].bounds.size
#define NTCurrentWindow [[UIApplication sharedApplication].windows lastObject]

@interface NTImageBrowser()
{
    //倒计时时间
    __block NSInteger timeOut;
    dispatch_queue_t queue;
    __block dispatch_source_t _timer ;
}
@property (nonatomic, assign) BOOL timerStop;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) NSString *urls;
@property (nonatomic, strong) UILabel *messageLab;
@end


@implementation NTImageBrowser

+ (instancetype)sharedShow{
    static NTImageBrowser *_show = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _show = [[NTImageBrowser alloc]init];
    });
   
    return _show;
}

static CGRect originFrame; // 用于记录imageView本来的frame

-(void)showImageBrowserWithImageView:(NSString *)imageUrl {

    originFrame = [UIScreen mainScreen].bounds;
    // 1、创建新的UIImageView，原因有两点：第一点是原来的imageView已经被添加了手势,第二点是原来的frame不对新的父控件生效
    self.showImage = [[UIImageView alloc]initWithFrame:originFrame];
    self.showImage.image = [UIImage imageNamed:@""];
    self.showImage.backgroundColor = [UIColor lightGrayColor];
    self.showImage.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.showImage addGestureRecognizer: longPress];
    self.urls = imageUrl.copy;
    //self.showImage.contentMode =  UIViewContentModeScaleAspectFill;
    self.showImage.contentMode =  UIViewContentModeCenter;
    self.showImage.clipsToBounds  = YES;
    //
    self.showImage.tag = 19; // 这个标记用于在hide方法中获取到backgroundView（如果不想采用这个方法也可以将backgroundView变成全局变量）
    self.showImage.contentMode = UIViewContentModeScaleAspectFit;
    // 2、创建黑色的背景视图
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NTDeviceSize.width, NTDeviceSize.height)];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImageBrowser :)];
    [self.backgroundView addGestureRecognizer: tap];
    
    [self.backgroundView addSubview:self.showImage];
    [NTCurrentWindow addSubview:self.backgroundView];
    
   
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.frame = CGRectMake(WIDTH-60, 20, 40, 40);
    self.doneBtn.tag = 201;
    self.doneBtn.backgroundColor = [UIColor lightGrayColor];
    [NTCurrentWindow addSubview:self.doneBtn];
    
    self.messageLab = [UILabel new];
    self.messageLab.frame = CGRectMake(40, HEIGHT/2-40, WIDTH-80, 40);
    self.messageLab.textAlignment = NSTextAlignmentCenter;
    self.messageLab.numberOfLines = 2;
    self.messageLab.textColor = TextCOLOR;
    self.messageLab.text = @"长按屏幕查看\n只可查看一次";
    self.messageLab.font = [UIFont systemFontOfSize:13];
    [NTCurrentWindow addSubview:self.messageLab];
    [self.messageLab setHidden:NO];
    
    // 3、执行动画效果
    [UIView animateWithDuration:0.3f animations:^{
        // frame的动画
        CGFloat width = NTDeviceSize.width;
        CGFloat height = NTDeviceSize.width/originFrame.size.width * originFrame.size.height;
        CGFloat x = 0;
        CGFloat y = NTDeviceSize.height/2 - height/2;
        self.showImage.frame = CGRectMake(x, y, width, height);
        
        // 透明度的动画
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
   
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self showanimation];
    }
    if (longPress.state==UIGestureRecognizerStateEnded) {
        if (self.returnBlock) {
            self.returnBlock();
        }
        [self.doneBtn removeFromSuperview];
        [self.showImage removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }
}

-(void)showanimation
{
    timeOut = 5;
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (self.timerStop) {
            dispatch_source_cancel(_timer);
            _timer = nil;
            self.timerStop = NO;
        }
        //倒计时结束，关闭
        if (timeOut <= 0) {
            if (self.returnBlock) {
                self.returnBlock();
            }
            dispatch_source_cancel(_timer);
            _timer = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.doneBtn.backgroundColor = [UIColor clearColor];
                [self.doneBtn setTitle:@"" forState:UIControlStateNormal];
                self.doneBtn.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)5 + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.doneBtn.backgroundColor = [UIColor clearColor];
                [self.doneBtn setTitle:timeStr forState:normal];
                [self.doneBtn setTitleColor:[UIColor whiteColor] forState:normal];
                self.doneBtn.userInteractionEnabled = NO;
                [self.messageLab setHidden:YES];
                self.showImage.backgroundColor = [UIColor clearColor];
                self.showImage.contentMode = UIViewContentModeScaleAspectFit;
                [_showImage sd_setImageWithURL:[NSURL URLWithString:self.urls]];
                
                if (timeOut==0) {
                    [UIView animateWithDuration:0.3f animations:^{
                        // frame的动画
                        self.showImage.frame = originFrame;
                        // 透明度的动画
                        self.backgroundView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.backgroundView removeFromSuperview];
                        [self.doneBtn removeFromSuperview];
                    }];
                }
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
    
}

-(void)hideImageBrowser :(UIGestureRecognizer *)sender {
    if (self.returnBlock) {
        self.returnBlock();
    }
    UIView *backgroundView = sender.view;
    UIView *imageView = (UIView *)[backgroundView viewWithTag:19];
    //self.timerStop = YES;
    [self.doneBtn removeFromSuperview];
    [self.messageLab removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        // frame的动画
        imageView.frame = originFrame;
        // 透明度的动画
        backgroundView.alpha = 0;
       
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
       
    }];
}

@end
