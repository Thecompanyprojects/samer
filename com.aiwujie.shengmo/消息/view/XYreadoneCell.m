//
//  XYreadoneCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/3.
//  Copyright © 2019 a. All rights reserved.
//

#import "XYreadoneCell.h"
#import "XYreadoneContent.h"

@interface XYreadoneCell()
@property (copy) NSString *imageName;
@property UIImageView *bubbleBackgroundView;
@property UIBlurEffect *beffect;
@property UIVisualEffectView *befview;
@property (copy,nonatomic) NSString *extra;
@property (nonatomic,assign) BOOL iscanShow;
@property (nonatomic,strong) UIImageView *smallImg;
@end

@implementation XYreadoneCell

//当应用自定义消息时，必须实现该方法来返回cell的Size
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    //这里我们设定的高度是120，所以加上extraHeight
    return CGSizeMake(WIDTH , 120 + extraHeight);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iscanShow = YES;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView setUserInteractionEnabled:YES];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 120)];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 10;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bubbleBackgroundView addSubview:self.imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
    
    
    UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtapMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:longtap];
    
    self.beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.befview = [[UIVisualEffectView alloc] initWithEffect:self.beffect];
    self.befview.frame = self.imageView.bounds;
    self.befview.layer.masksToBounds = YES;
    self.befview.layer.cornerRadius = 10;
    [self.bubbleBackgroundView addSubview:self.befview];
    
    self.smallImg = [UIImageView new];
    self.smallImg.image = [UIImage imageNamed:@"小闪照"];
    [self.bubbleBackgroundView addSubview:self.smallImg];
    self.smallImg.frame = CGRectMake(30, 23, 90, 70);
    
}

- (void)tapMessage:(id)sender {
    if (self.iscanShow) {
        if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
            [self.delegate didTapMessageCell:self.model];
        }
    }

}

-(void)longtapMessage:(id)sender
{
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)updateStatusContentView:(RCMessageModel *)model
{
    [super updateStatusContentView:model];
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    self.extra = model.extra;
    [self setAutoLayout];
}

- (void)setAutoLayout
{
    XYreadoneContent *richMessage = (XYreadoneContent *)self.model.content;
    self.imageName = richMessage.imageUrl;
    [self.messageContentView setBounds:CGRectMake(0, 0, 160, 120)];
    [self.bubbleBackgroundView setFrame:CGRectMake(0, 0, 160, 120)];
    
    NSString *str1 = @"";
    if (self.extra.length!=0) {
        str1 = [self.extra substringToIndex:1];
    }
    else
    {
        str1 = @"0";
    }
    
    NSString *str2 = [richMessage.isopen substringToIndex:1];
    
    if (self.extra.length!=0) {
        if ([str1 isEqualToString:@"1"]) {
            [self.befview setHidden:YES];
            self.iscanShow = NO;
            self.imageView.image = [UIImage imageNamed:@"闪照"];
            
            [self.smallImg setHidden:YES];
        }
        else
        {
            [self.befview setHidden:NO];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:richMessage.imageUrl]];
            self.iscanShow = YES;
            
            [self.smallImg setHidden:NO];

        }
    }
    else
    {
        if ([str2 isEqualToString:@"0"]) {
            [self.befview setHidden:NO];
            self.iscanShow = YES;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:richMessage.imageUrl]];
            
            [self.smallImg setHidden:NO];

        }
        else
        {
            [self.smallImg setHidden:YES];
            [self.befview setHidden:YES];
            self.iscanShow = NO;
            self.imageView.image = [UIImage imageNamed:@"闪照"];
        }
    }
}

@end
