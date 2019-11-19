//
//  idcardImg.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/11.
//  Copyright © 2019 a. All rights reserved.
//

#import "idcardImg.h"

@implementation idcardImg

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        [self addSubview:self.addImg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.addImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(25);
        make.height.mas_offset(25);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)addImg
{
    if(!_addImg)
    {
        _addImg = [[UIImageView alloc] init];
        _addImg.image = [UIImage imageNamed:@"加加"];
    }
    return _addImg;
}


@end
