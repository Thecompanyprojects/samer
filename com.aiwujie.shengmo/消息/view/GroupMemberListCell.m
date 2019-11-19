//
//  GroupMemberListCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "GroupMemberListCell.h"

@implementation GroupMemberListCell

-(void)setModel:(GroupMemberListModel *)model{

    _model = model;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([_model.is_admin intValue]==1) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
    }
    else if ([_model.bkvip intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"贵宾黑V"];
        
    }
    else if ([_model.blvip intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"蓝V"];
        
    }
    else if ([_model.is_volunteer intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
    }
    else
    {
        if ([_model.svipannual intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
        }else if ([_model.svip intValue] == 1){
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
        }else if ([_model.vipannual intValue] == 1) {
            self.vipView.hidden = NO;
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
        }else{
            if ([_model.vip intValue] == 1) {
                self.vipView.hidden = NO;
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
            }else{
                self.vipView.hidden = YES;
            }
        }
    }

    if ([_model.realname intValue] == 0) {
        
        self.idView.hidden = YES;
        
        self.idW.constant = 0;
        
    }else{
        
        self.idView.hidden = NO;
        
        self.idW.constant = 16;
    }
    
    if ([_model.onlinestate intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }
    
    if ([model.state intValue] == 1) {
        
        self.stateW.constant = 0;
        
        self.nameSpace.constant = -2;
        
        if (model.cardname.length!=0) {
            self.otherNameLabel.text = model.cardname;
        }
        else
        {
            if (model.markname.length!=0) {
                self.otherNameLabel.text = model.markname;
            }
            else
            {
                self.otherNameLabel.text = model.nickname;
            }
        }
    }else if ([model.state intValue] == 2){
        
        self.stateW.constant = 33;
        
        self.nameSpace.constant = 2;
        
        self.stateLabel.text = @"管理员";
        
        self.stateLabel.backgroundColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:240/255.0 alpha:1];
        
        if (model.cardname.length!=0) {
            self.otherNameLabel.text = model.cardname;
        }
        else
        {
            if (model.markname.length!=0) {
                self.otherNameLabel.text = model.markname;
            }
            else
            {
                self.otherNameLabel.text = model.nickname;
            }
        }
    
    }else if ([model.state intValue] == 3){
        
        self.stateW.constant = 33;
        self.nameSpace.constant = 2;
        self.stateLabel.text = @"群主";
        self.stateLabel.backgroundColor = MainColor;
        if (model.cardname.length!=0) {
            self.otherNameLabel.text = model.cardname;
        }
        else
        {
            if (model.markname.length!=0) {
                self.otherNameLabel.text = model.markname;
            }
            else
            {
                self.otherNameLabel.text = model.nickname;
            }
        }
    }
    if ([model.gagstate intValue] == 0) {
        self.gagImageView.hidden = YES;
    }else{
        self.gagImageView.hidden = NO;
    }
    if ([self.integer intValue] == 2001){
        self.distanceLabel.hidden = YES;
    }else{
        if ([model.lng floatValue] == 0 || [model.lat floatValue] == 0) {
            self.distanceLabel.hidden = YES;
        }else{
            self.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.distance];
            self.distanceLabel.hidden = NO;
        }
    }
    
//    if (model.introduce.length == 0) {
//        
//        self.lastTimeLabel.text = @"(用户未设置签名)";
//        
//    }else{
//    
//        self.lastTimeLabel.text = model.introduce;
//    }
    
    if (![_model.city isEqual:[NSNull null]] && ![_model.province isEqual:[NSNull null]]) {
    
        if (model.city.length == 0) {
            
            self.lastTimeLabel.text = @"隐身";
            
        }else{
            
            if ([model.province isEqualToString:model.city]) {
                
                self.lastTimeLabel.text = [NSString stringWithFormat:@"%@",model.city];
                
            }else{
                
                if (_model.province.length != 0) {
                    
                    self.lastTimeLabel.text = [NSString stringWithFormat:@"%@ %@",model.province,model.city];
                    
                }else{
                    
                    self.lastTimeLabel.text = [NSString stringWithFormat:@"%@",model.city];
                }
            }
        }

    }else{
    
         self.lastTimeLabel.text = @"隐身";
    }

    if ([_model.role isEqualToString:@"S"]) {
        
        self.roleLabel.text = @"斯";
        
        self.roleLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.role isEqualToString:@"M"]){
        
        self.roleLabel.text = @"慕";
        
        self.roleLabel.backgroundColor = GIRLECOLOR;
        
    }else if([_model.role isEqualToString:@"SM"]){
        
        self.roleLabel.text = @"双";
        
        self.roleLabel.backgroundColor = DOUBLECOLOR;
        
    }else{
        
        self.roleLabel.text = @"~";
        self.roleLabel.backgroundColor = GREENCOLORS;
    }
    
    
    if ([_model.sex intValue] == 1) {
        
        self.sexView.image = [UIImage imageNamed:@"男"];
        
        self.backView.backgroundColor = BOYCOLOR;
        
    }else if ([_model.sex intValue] == 2){
        
        self.sexView.image = [UIImage imageNamed:@"女"];
        
        self.backView.backgroundColor = GIRLECOLOR;
        
    }
    else{
        
        self.sexView.image = [UIImage imageNamed:@"双性"];
        
        self.backView.backgroundColor = DOUBLECOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
    
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:_model.wealth_val andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:_model.charm_val andNSLayoutConstraint:_charmW andType:@"魅力"];
    
}

-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView andText:(NSString *)text andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([text intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            
            backView.hidden = YES;
            
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([text intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

-(CGSize)fitLabelWidth:(NSString *)string{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.stateLabel.layer.cornerRadius = 2;
    self.stateLabel.clipsToBounds = YES;
    
    self.backView.layer.cornerRadius = 2;
    self.backView.clipsToBounds = YES;
    
    self.roleLabel.layer.cornerRadius = 2;
    self.roleLabel.clipsToBounds = YES;
    
    self.headView.layer.cornerRadius = 30;
    self.headView.clipsToBounds = YES;
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateLabel.mas_left);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
