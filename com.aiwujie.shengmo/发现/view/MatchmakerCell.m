//
//  MatchmakerCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/16.
//  Copyright © 2017年 a. All rights reserved.
//

#import "MatchmakerCell.h"

@implementation MatchmakerCell

-(void)setModel:(MatchmakerModel *)model{

    _model = model;
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICHEADURL,model.match_photo]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.picView.contentMode =  UIViewContentModeScaleAspectFill;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] != 1) {
        
        for (UIView *view in self.picView.subviews) {
            
            if ([view isKindOfClass:[UIVisualEffectView class]]) {
                
                [view removeFromSuperview];
            }
        }
        
        if ([_model.match_photo_lock intValue] == 1) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"match_state"] intValue] == 0) {
                
                [self createBlurEffect];
                
            }
            
        }else if ([_model.match_photo_lock intValue] == 2) {
            
            [self createBlurEffect];
        }
    }

    self.nameLabel.text = model.match_num;
    
    if ([model.realname intValue] == 1) {
        
        self.idImageView.hidden = NO;
        
    }else{
    
        self.idImageView.hidden = YES;
    }
    
    if ([_model.role isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.role isEqualToString:@"M"]){
        self.sexualLabel.text = @"慕";
        self.sexualLabel.backgroundColor = GIRLECOLOR;
    }else if([_model.role isEqualToString:@"SM"]){
        self.sexualLabel.text = @"双";
        self.sexualLabel.backgroundColor = DOUBLECOLOR;
    }else{
        
        self.sexualLabel.text = @"~";
        self.sexualLabel.backgroundColor = GREENCOLORS;
    }
    if ([_model.sex intValue] == 1) {
        
        self.sexImageView.image = [UIImage imageNamed:@"男"];
        self.ageSexView.backgroundColor = BOYCOLOR;
        
    }else if ([_model.sex intValue] == 2){
        self.sexImageView.image = [UIImage imageNamed:@"女"];
        self.ageSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        self.sexImageView.image = [UIImage imageNamed:@"双性"];
        self.ageSexView.backgroundColor = DOUBLECOLOR;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
    if (model.province.length != 0) {
        
        self.cityLabel.text = [NSString stringWithFormat:@"%@",model.province];
        
    }else{
        
        self.cityLabel.text = [NSString stringWithFormat:@"%@",@"隐身"];
    }

    self.cityW.constant = 18 + [self fitLabelWidth:self.cityLabel.text].width - 4;

}

-(void)createBlurEffect{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    [self.picView addSubview:effectView];
    effectView.alpha = .92f;
}

//label的宽度自适应
-(CGSize)fitLabelWidth:(NSString *)string{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ageSexView.layer.cornerRadius = 2;
    self.ageSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.cityView.layer.cornerRadius = 2;
    self.cityView.clipsToBounds = YES;
}

@end
