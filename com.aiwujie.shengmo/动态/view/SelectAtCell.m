//
//  SelectAtCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/5/3.
//  Copyright © 2017年 a. All rights reserved.
//

#import "SelectAtCell.h"

@implementation SelectAtCell

-(void)setModel:(TableModel *)model{
    _model = model;
    [self createUI];
}

-(void)createUI{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userInfo[@"head_pic"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([_model.userInfo[@"onlinestate"] intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }
    
    NSString *markname = _model.userInfo[@"markname"];
    if (markname.length!=0) {
        self.nameLabel.text = markname?:@"";
    }
    else
    {
        self.nameLabel.text = _model.userInfo[@"nickname"];
    }
    
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.nameLabel sizeToFit];
    
    self.nameW.constant = self.nameLabel.frame.size.width;
    
    
    if ([_model.userInfo[@"is_admin"] intValue]==1) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
    }
    else if ([_model.userInfo[@"bkvip"] intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"贵宾黑V"];
    }
    else if ([_model.userInfo[@"blvip"] intValue]==1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"蓝V"];
    }
    else if ([_model.userInfo[@"is_volunteer"] intValue] == 1)
    {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
    }
    else
    {
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
    
    if ([_model.userInfo[@"role"] isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.userInfo[@"role"] isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if ([_model.userInfo[@"role"] isEqualToString:@"SM"]){
        
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
    if ([_model.userInfo[@"location_city_switch"] intValue]==1) {
        self.introduceLabel.text = @"隐身";
    }
    else
    {
        self.introduceLabel.text = _model.userInfo[@"city"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = 29;
    self.headImageView.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
    
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.contentView);
        make.height.mas_offset(1);
        make.right.equalTo(self.contentView);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
