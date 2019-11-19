//
//  XYredMessageCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/28.
//  Copyright © 2019 a. All rights reserved.
//

#import "XYredMessageCell.h"
#import "XYredMessageContent.h"

@interface XYredMessageCell()
@property (copy) NSString *imageName;
@property UIImageView *bubbleBackgroundView;
@property (copy,nonatomic) NSString *extra;
@end

@implementation XYredMessageCell

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
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 50, 50)];
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
    
    self.bubbleBackgroundView.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

/**
 点击当前cell
 
 @param sender 当前的cell
 */
- (void)tapMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    self.extra = model.extra;
    [self setAutoLayout];
}

- (void)updateStatusContentView:(RCMessageModel *)model
{
    [super updateStatusContentView:model];
    
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
    
    XYredMessageContent *richMessage = (XYredMessageContent *)self.model.content;
    [self.messageContentView setBounds:CGRectMake(0, 0, 200, 80)];
    [self.bubbleBackgroundView setFrame:CGRectMake(0, 0, 200, 80)];
    if (MessageDirection_RECEIVE == self.messageDirection) {

    } else {

    }

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
            self.bubbleBackgroundView.backgroundColor = [UIColor colorWithHexString:@"FBD2C1" alpha:1];
        }
        else
        {
            self.bubbleBackgroundView.backgroundColor = [UIColor colorWithHexString:@"F99D3F" alpha:1];
        }
    }
    else
    {
        if ([str2 isEqualToString:@"0"]) {
            self.bubbleBackgroundView.backgroundColor = [UIColor colorWithHexString:@"F99D3F" alpha:1];
        }
        else
        {
            
            self.bubbleBackgroundView.backgroundColor = [UIColor colorWithHexString:@"FBD2C1" alpha:1];
        }
    }
  
    
    CGSize contentViewSize = self.bubbleBackgroundView.bounds.size;
    [self.titleLabel setFrame:CGRectMake(56, 10, contentViewSize.width - 40, 20)];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.detailLabel setFrame:CGRectMake(0, 60, contentViewSize.width, 20)];
    self.detailLabel.backgroundColor = [UIColor whiteColor];
    self.detailLabel.text = @"  Samer红包";
    if (richMessage.message.length==0) {
        [self.titleLabel setText:@"恭喜发财，大吉大利"];
    }
    else
    {
       [self.titleLabel setText:richMessage.message];
    }

    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    UIImage *img = [UIImage imageNamed:@"大红包顶部"];
    [self.imageView setImage:img];
}

@end
