//
//  VIPMemberCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "VIPMemberCell.h"

@implementation VIPMemberCell

-(void)setModel:(VIPMemberModel *)model{
    
    _model = model;
    
    self.monthLabel.text = model.month;
                            
    [self changeWordColorTitle:model.month andLoc:model.month.length - model.price.length - 1 andLen:model.price.length andLabel:self.monthLabel];
    
    if ([model.oldprice length] != 0) {
        
        self.oldProceLabel.hidden = NO;
        
        self.oldProceLabel.text = [NSString stringWithFormat:@"原价%@元",model.oldprice];
        
        //label添加删除线
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.oldProceLabel.text];
        [attributedStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attributedStr.length)];
        self.oldProceLabel.attributedText = attributedStr;
        
    }else{
        
        self.oldProceLabel.hidden = YES;
    }
    
    self.introduceLabel.text = model.introduce;
    
    if ([model.warnstate intValue] == 0) {
        
        self.warnLabel.hidden = YES;
        
    }else{
        
        self.warnLabel.hidden = NO;
    }
    
    if ([model.selectstate intValue] == 0) {
        
        self.selectImageView.image = [UIImage imageNamed:@"照片认证空圈"];
        
    }else{
        
        self.selectImageView.image = [UIImage imageNamed:@"照片认证实圈"];
    }
}

//更改某个字体的颜色
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
