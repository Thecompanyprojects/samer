//
//  InvitationMemberCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "InvitationMemberCell.h"

@implementation InvitationMemberCell

-(void)setModel:(TableModel *)model{
    
    _model = model;
    
    if ([self.content integerValue] == 1 || [self.content integerValue] == 2) {
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        if ([_model.onlinestate intValue] == 0) {
            
            self.onlineLabel.hidden = YES;
            
        }else{
            
            self.onlineLabel.hidden = NO;
        }
        
        self.nameLabel.text = _model.nickname;

        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.nameLabel sizeToFit];
        
        self.nameW.constant = self.nameLabel.frame.size.width;
        
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
        
        
       /* if ([_model.is_volunteer intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
            
        }else if ([_model.is_admin intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"官方认证"];
            
        }else{
            
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
        }*/
        
        if ([_model.realname intValue] == 0) {
            
            self.idImageView.hidden = YES;
            
            self.idViewW.constant = 0;
            
        }else{
            
            self.idImageView.hidden = NO;
            
            self.idViewW.constant = 16;
        }
        
        //    NSLog(@"jjjjjjjjjjjjj%ld",_integer);
        
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
            
            self.sexLabel.image = [UIImage imageNamed:@"男"];
            
            self.aSexView.backgroundColor = BOYCOLOR;
            
        }else if ([_model.sex intValue] == 2){
            
            self.sexLabel.image = [UIImage imageNamed:@"女"];
            
            self.aSexView.backgroundColor = GIRLECOLOR;
            
        }else{
            
            self.sexLabel.image = [UIImage imageNamed:@"双性"];
            
            self.aSexView.backgroundColor = DOUBLECOLOR;
        }
        
        self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
        
//        if (_model.introduce.length != 0) {
//
//            self.introduceLabel.text = _model.introduce;
//
//        }else{
        if (_model.visit_time != 0) {
            
            self.introduceLabel.text = [NSString stringWithFormat:@"%@",_model.visit_time];
            
        }else{
            
            if (![_model.city isEqual:[NSNull null]] && ![_model.province isEqual:[NSNull null]]) {
                
                if(_model.city.length != 0){
                    
                    if ([_model.city isEqualToString:_model.province]) {
                        
                        self.introduceLabel.text = _model.city;
                        
                    }else{
                        
                        if (_model.province.length != 0) {
                            
                            self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@",_model.province,_model.city];
                            
                        }else{
                            
                            self.introduceLabel.text = [NSString stringWithFormat:@"%@",_model.city];
                        }
                    }
                    
                }else{
                    
                    self.introduceLabel.text = @"隐身";
                    
                }
            }else{
                
                self.introduceLabel.text = @"隐身";
            }
            
        }
        
//        }

    }else if ([self.content integerValue] == 3){
    
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userInfo[@"head_pic"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        if ([_model.userInfo[@"onlinestate"] intValue] == 0) {
            
            self.onlineLabel.hidden = YES;
            
        }else{
            
            self.onlineLabel.hidden = NO;
        }
        
        self.nameLabel.text = _model.userInfo[@"nickname"];
        
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.nameLabel sizeToFit];
        
        self.nameW.constant = self.nameLabel.frame.size.width;
        
        if ([_model.userInfo[@"is_volunteer"] intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
            
        }else if ([_model.userInfo[@"is_admin"] intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"官方认证"];
            
        }else{
            
            if ([_model.userInfo[@"svipannual"] intValue] == 1) {
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"年svip标识"];
                
            }else if ([_model.userInfo[@"svip"] intValue] == 1){
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"svip标识"];
                
            }else if ([_model.userInfo[@"vipannual"] intValue] == 1) {
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"年费会员"];
                
            }else{
                
                if ([_model.userInfo[@"vip"] intValue] == 1) {
                    
                    self.vipView.hidden = NO;
                    
                    self.vipView.image = [UIImage imageNamed:@"高级紫"];
                    
                }else{
                    
                    self.vipView.hidden = YES;
                }
            }
        }

        if ([_model.userInfo[@"realname"] intValue] == 0) {
            
            self.idImageView.hidden = YES;
            
            self.idViewW.constant = 0;
            
        }else{
            
            self.idImageView.hidden = NO;
            
            self.idViewW.constant = 16;
        }
        
        //    NSLog(@"jjjjjjjjjjjjj%ld",_integer);
        
        if ([_model.userInfo[@"role"] isEqualToString:@"S"]) {
            
            self.sexualLabel.text = @"斯";
            
            self.sexualLabel.backgroundColor = BOYCOLOR;
            
        }else if ([_model.userInfo[@"role"] isEqualToString:@"M"]){
            
            self.sexualLabel.text = @"慕";
            
            self.sexualLabel.backgroundColor = GIRLECOLOR;
            
        }else if([_model.userInfo[@"role"] isEqualToString:@"SM"]){
            
            self.sexualLabel.text = @"双";
            
            self.sexualLabel.backgroundColor = DOUBLECOLOR;
            
        }else{
            
            self.sexualLabel.text = @"~";
            self.sexualLabel.backgroundColor = GREENCOLORS;
        }
        
        if ([_model.userInfo[@"sex"] intValue] == 1) {
            
            self.sexLabel.image = [UIImage imageNamed:@"男"];
            
            self.aSexView.backgroundColor = BOYCOLOR;
            
        }else if ([_model.userInfo[@"sex"] intValue] == 2){
            
            self.sexLabel.image = [UIImage imageNamed:@"女"];
            
            self.aSexView.backgroundColor = GIRLECOLOR;
            
        }else{
            
            self.sexLabel.image = [UIImage imageNamed:@"双性"];
            
            self.aSexView.backgroundColor = DOUBLECOLOR;
        }
        
        self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.userInfo[@"age"]];
        
        if (_model.userInfo[@"introduce"] != nil) {
            
            if ([_model.userInfo[@"introduce"] length] != 0) {
                
                self.introduceLabel.text = _model.userInfo[@"introduce"];
                
            }else{
                
                self.introduceLabel.text = @"(用户未设置个性签名)";
            }
            
        }
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImageView.layer.cornerRadius = 29;
    self.headImageView.clipsToBounds = YES;
    
    self.chatHeadView.layer.cornerRadius = 25;
    self.chatHeadView.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
