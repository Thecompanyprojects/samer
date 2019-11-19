//
//  XYshareuserinfoCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/29.
//  Copyright © 2019 a. All rights reserved.
//

#import "XYshareuserinfoCell.h"
#import "XYshareuserinfoContent.h"

@interface XYshareuserinfoCell()
@property (copy) NSString *imageName;
@property UIImageView *bubbleBackgroundView;

@property UIImageView *iconImg;
@property UILabel *titleLab;
@property UIView *lineView;
@property UILabel *contentLab;
@end

@implementation XYshareuserinfoCell
//当应用自定义消息时，必须实现该方法来返回cell的Size
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    //这里我们设定的高度是120，所以加上extraHeight
    return CGSizeMake(WIDTH , 110 + extraHeight);
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
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.frame = CGRectMake(10, 10, 200, 16);
    self.titleLab.font = [UIFont systemFontOfSize:14];
    self.titleLab.textColor = [UIColor colorWithHexString:@"9B9C9D" alpha:1];
    self.titleLab.text = @"hi,给你推荐一个同好";
    [self.bubbleBackgroundView addSubview:self.titleLab];
    
    
    self.iconImg = [UIImageView new];
    self.iconImg.frame = CGRectMake(12, 38, 55, 55);
    [self.bubbleBackgroundView addSubview:self.iconImg];
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = 55/2;
    
    self.contentLab = [[UILabel alloc] init];
    self.contentLab.frame = CGRectMake(74, 38, 120, 50);
    self.contentLab.textColor = TextCOLOR;
    self.contentLab.numberOfLines = 0;
    self.contentLab.font = [UIFont systemFontOfSize:13];
    [self.bubbleBackgroundView addSubview:self.contentLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

- (void)tapMessage:(id)sender {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

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
    XYshareuserinfoContent *richMessage = (XYshareuserinfoContent *)self.model.content;
    
    [self.messageContentView setBounds:CGRectMake(0, 0, 200, 110)];
    [self.bubbleBackgroundView setFrame:CGRectMake(0, 0, 200, 110)];
    
    self.bubbleBackgroundView.backgroundColor = [UIColor whiteColor];
    self.bubbleBackgroundView.layer.masksToBounds = YES;
    self.bubbleBackgroundView.layer.cornerRadius = 6;
    
    CGSize contentViewSize = self.bubbleBackgroundView.bounds.size;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    self.lineView.frame = CGRectMake(10, 31, contentViewSize.width-20, 1);
    [self.bubbleBackgroundView addSubview:self.lineView];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:richMessage.icon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.contentLab.text = richMessage.content;
}

@end
