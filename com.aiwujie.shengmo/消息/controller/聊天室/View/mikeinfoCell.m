//
//  mikeinfoCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/15.
//  Copyright © 2019 a. All rights reserved.
//

#import "mikeinfoCell.h"

@interface mikeinfoCell()
@property (nonatomic,strong) UIImageView *ruleImg;
@end

@implementation mikeinfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
}

- (void)setModel:(chatmikeModel *)model
{
    if (model.head_pic.length==0) {
        self.iconImg.image = [UIImage imageNamed:@"麦克分-聊天室"];
    }
    else
    {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    if (self.talkArray.count!=0) {
         BOOL isbool = [self.talkArray containsObject: model.uid];
        if (isbool) {
            self.iconImg.layer.masksToBounds = YES;
            self.iconImg.layer.borderWidth = 1;
            self.iconImg.layer.borderColor = [UIColor redColor].CGColor;
        }
        else
        {
            self.iconImg.layer.masksToBounds = YES;
            self.iconImg.layer.borderWidth = 0;
            self.iconImg.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
    }
    return _iconImg;
}

@end
