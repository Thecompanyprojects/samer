//
//  idcardCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/12.
//  Copyright © 2019 a. All rights reserved.
//

#import "idcardCell.h"

@interface idcardCell()

@end

@implementation idcardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.idimg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(12);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(WIDTH-28);
    }];
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(14);
        make.height.mas_offset(98);
        make.width.mas_offset(WIDTH/2-14-10);
    }];
    [weakSelf.idimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(14);
        make.height.mas_offset(98);
        make.width.mas_offset(WIDTH/2-14-10);
    }];
}

#pragma mark - getters

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = TextCOLOR;
    }
    return _titleLab;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}

-(idcardImg *)idimg
{
    if(!_idimg)
    {
        _idimg = [[idcardImg alloc] init];
        _idimg.backgroundColor = [UIColor colorWithHexString:@"DDDDDD" alpha:1];
        
    }
    return _idimg;
}





@end
