//
//  XYgiftgroupMessageCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import "XYgiftgroupMessageCell.h"
#import "XYgiftMessageContent.h"
#import "FlowFlower.h"

@interface XYgiftgroupMessageCell()
@property (copy) NSString *imageName;
@property UIImageView *bubbleBackgroundView;

/**
 创建礼物掉落的效果
 */
//创建礼物下落的定时器
@property (nonatomic,strong) NSTimer * gifTimer;
//掉落礼物的view
@property (nonatomic,strong) FlowFlower *flowFlower;
//存储选中的礼物
@property (nonatomic,strong) UIImage *gifImage;
//掉落的时间
@property (nonatomic,assign) int second;

@end

@implementation XYgiftgroupMessageCell
//当应用自定义消息时，必须实现该方法来返回cell的Size
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    //这里我们设定的高度是120，所以加上extraHeight
    return CGSizeMake(WIDTH , 80 + extraHeight);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView setUserInteractionEnabled:YES];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] init] ;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    self.detailLabel = [[UILabel alloc] init] ;
    self.detailLabel.numberOfLines = 2;
    self.detailLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    
    [self.bubbleBackgroundView addSubview:self.imageView];
    [self.bubbleBackgroundView addSubview:self.titleLabel];
    [self.bubbleBackgroundView addSubview:self.detailLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

/**
 点击当前cell

 @param sender 当前的cell
 */
- (void)tapMessage:(id)sender {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
//    _gifTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//    //face
//    UIImage *faceImage = [UIImage imageNamed:_imageName];
//    [[NSRunLoop currentRunLoop] addTimer:_gifTimer forMode:NSRunLoopCommonModes];
//    //飞行
//    _flowFlower = [FlowFlower flowerFLow:@[faceImage]];
//    [_flowFlower startFlyFlowerOnView:[self getCurrentVC].view];
}

///**
// 礼物定时器release
// */
//-(void)timeFireMethod{
//    _second ++;
//    if (_second >= 3) {
//        [_flowFlower endFlyFlower];
//        [_gifTimer invalidate];
//        _flowFlower = nil;
//        _gifTimer = nil;
//    }
//}

////获取当前屏幕显示的viewcontroller
//- (UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    return result;
//}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}

- (void)setAutoLayout
{
    XYgiftMessageContent *richMessage = (XYgiftMessageContent *)self.model.content;
    self.imageName = richMessage.imageName;
    [self.messageContentView setBounds:CGRectMake(0, 0, 200, 80)];
    [self.bubbleBackgroundView setFrame:CGRectMake(0, 0, 200, 80)];
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
                                                                                        image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                                                        image.size.height * 0.2, image.size.width * 0.8)];
    }
    
    CGSize contentViewSize = self.bubbleBackgroundView.bounds.size;
    [self.titleLabel setFrame:CGRectMake(76, 30, contentViewSize.width - 80, 20)];
    [self.detailLabel setFrame:CGRectMake(76, 33, contentViewSize.width - 80, 40)];
    [self.imageView setCenter:CGPointMake(40, 40)];
    NSString *str1 = [NSString stringWithFormat:@"%@",richMessage.imageName];
    NSString *str2 = richMessage.number;
    [self.titleLabel setText:[NSString stringWithFormat:@"%@%@%@",str1,@" × ",str2]];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    UIImage *img = [UIImage imageNamed:self.imageName];
    [self.imageView setImage:img];
}

@end
