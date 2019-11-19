//
//  bottomView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "bottomView.h"

@implementation bottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgView];
        [self addSubview:self.zanBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.replyBtn];
        [self addSubview:self.topBtn];
        
        if (self.isfromDis) {
            [self setuplayout2];
        }
        else
        {
            [self setuplayout];
        }
        
    }
    return self;
}
              
-(void)setuplayout2
{
    __weak typeof (self) weakSelf = self;
    
    
    [weakSelf.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(12);
        make.width.mas_offset(WIDTH/4);
    }];
    
    [weakSelf.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.zanBtn.mas_right);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.zanBtn);
        make.width.mas_offset(WIDTH/4);
    }];
    
    [weakSelf.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.commentBtn.mas_right);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.zanBtn);
        make.width.mas_offset(WIDTH/4);
    }];
    
    [weakSelf.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.zanBtn);
        make.width.mas_offset(WIDTH/4);
    }];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    
    [weakSelf.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.mas_offset(WIDTH/4);
    }];
    
    [weakSelf.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.zanBtn.mas_right);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.mas_offset(WIDTH/4);
    }];

    [weakSelf.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.commentBtn.mas_right);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.mas_offset(WIDTH/4);
    }];

    [weakSelf.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.mas_offset(WIDTH/4);
    }];
    
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        
    }
    return _bgView;
}


-(UIButton *)zanBtn
{
    if(!_zanBtn)
    {
        _zanBtn = [[UIButton alloc] init];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_zanBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
        [_zanBtn setImage:[UIImage imageNamed:@"赞灰"] forState:normal];
        [_zanBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _zanBtn;
}

-(UIButton *)commentBtn
{
    if(!_commentBtn)
    {
        _commentBtn = [[UIButton alloc] init];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
        [_commentBtn setImage:[UIImage imageNamed:@"评论"] forState:normal];
        [_commentBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _commentBtn;
}

-(UIButton *)replyBtn
{
    if(!_replyBtn)
    {
        _replyBtn = [[UIButton alloc] init];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_replyBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
        [_replyBtn setImage:[UIImage imageNamed:@"打赏灰"] forState:normal];
        [_replyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _replyBtn;
}

-(UIButton *)topBtn
{
    if(!_topBtn)
    {
        _topBtn = [[UIButton alloc] init];
        _topBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_topBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
        [_topBtn setImage:[UIImage imageNamed:@"推顶灰"] forState:normal];
        [_topBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _topBtn;
}

@end
