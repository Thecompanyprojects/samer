//
//  TableCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/24.
//  Copyright © 2016年 a. All rights reserved.
//

#import "TableCell.h"
#import <Accelerate/Accelerate.h>

@interface TableCell()
@property (nonatomic,strong) UIVisualEffectView * blurEffectView;
@end

@implementation TableCell

-(void)setModel:(TableModel *)model{
    
    _model = model;
    if ([self.type intValue] == 2) {
        [self createFriendUI];
    }else{
        [self createUI];
    }
}

-(void)createFriendUI{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userInfo[@"head_pic"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([_model.userInfo[@"onlinestate"] intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }

    NSString *markname = _model.userInfo[@"markname"];
    if (markname.length==0) {
         self.nameLabel.text = _model.userInfo[@"nickname"];
    }
    else
    {
         self.nameLabel.text = markname;
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
     if (self.integer == 2001){
        self.distanceLabel.hidden = YES;
     }else{
         
         if ([_model.userInfo[@"lat"] floatValue] == 0 || [_model.userInfo[@"lng"] floatValue] == 0) {
             if (self.isfromguanzhu)
             {
                self.distanceLabel.text = @"隐身";
                self.distanceLabel.hidden = NO;
             }
             else
             {
                self.distanceLabel.hidden = YES;
             }
         }else{
             if (self.isfromguanzhu) {
                 if ([_model.userInfo[@"province"] isEqualToString:_model.userInfo[@"city"]]) {
                     self.distanceLabel.text = [NSString stringWithFormat:@"%@",_model.userInfo[@"city"]?:@""];
                 }
                 else
                 {
                     self.distanceLabel.text = [NSString stringWithFormat:@"%@%@",_model.userInfo[@"province"]?:@"",_model.userInfo[@"city"]?:@""];
                 }
                 self.distanceLabel.hidden = NO;
             }
             else
             {
                 self.distanceLabel.text = [NSString stringWithFormat:@"%@km",_model.userInfo[@"distance"]];
                 self.distanceLabel.hidden = NO;
             }
         }
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
    self.timeLabel.text = @"";
    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.timeLabel sizeToFit];
    
    if (self.isfromguanzhu) {
        self.introduceLabel.text = _model.userInfo[@"lmarkname"]?:@"";
    }
    else
    {
        if ([_model.userInfo[@"introduce"] length] != 0) {
            self.introduceLabel.text = _model.userInfo[@"introduce"];
        }else{
            self.introduceLabel.text = @"(用户未设置个性签名)";
        }
    }
    


    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:_model.userInfo[@"wealth_val"] andNSLayoutConstraint:_wealthW andType:@"财富"];
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:_model.userInfo[@"charm_val"]andNSLayoutConstraint:_charmW andType:@"魅力"];
    
}

-(void)createUI{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([_model.onlinestate intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }
    
    if (_model.markname.length==0) {
        self.nameLabel.text = _model.nickname;
    }
    else
    {
        self.nameLabel.text = _model.markname;
    }

    if ([self.typeStr intValue]==1||[self.typeStr intValue]==10) {
   
//        if ([_model.location_switch intValue]==1||[_model.location_city_switch intValue]==1) {
//            self.nameLabel.text = @"【昵称保密】";
//            self.blurEffectView.hidden = YES;
//            self.nameLabel.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
//        }
//        else
//        {
            self.blurEffectView.hidden = YES;
            self.nameLabel.text = _model.nickname;
            self.nameLabel.textColor = TextCOLOR;
//        }
    }
    
    if ([self.typeStr intValue]==7) {
        
//        if ([_model.login_time_switch intValue]==1) {
//            self.nameLabel.text = @"【昵称保密】";
//            self.nameLabel.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
//            self.blurEffectView.hidden = YES;
//        }
//        else
//        {
            self.nameLabel.textColor = TextCOLOR;
            self.blurEffectView.hidden = YES;
            self.nameLabel.text = _model.nickname;
//        }
    }

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
    
    /*if ([_model.is_volunteer intValue] == 1) {
        
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
    
    if (self.integer == 2001){
        
        self.distanceLabel.hidden = YES;
        
    }else if(self.integer == 2500){
    
        self.distanceLabel.hidden = NO;
        
        self.distanceLabel.text = @"拉黑时间";
        
    }else{
        
        if ([_model.lat floatValue] == 0 || [_model.lng floatValue] == 0) {
            
            self.distanceLabel.hidden = YES;
            
        }else{
            
            self.distanceLabel.text = [NSString stringWithFormat:@"%@",_model.distance];
            
            self.distanceLabel.hidden = NO;
            
        }
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
    
    if ([self.typeStr intValue]==7&&[_model.login_time_switch intValue]==1) {
        self.timeLabel.text = @"隐身";
        self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.timeLabel sizeToFit];
    }
    else
    {
        if (_model.black_time.length != 0) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@",_model.black_time];
        }else{
            if (self.content.length != 0) {
                if ([_model.last_login_time isKindOfClass:[NSNull class]]) {
                    self.timeLabel.text = @"";
                }else{
                    self.timeLabel.text = [NSString stringWithFormat:@"%@",_model.last_login_time];
                }
            }else{
                self.timeLabel.text = @"";
            }
        }
        self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.timeLabel sizeToFit];
    }
    
    if (_model.visit_time.length != 0) {
        
        self.introduceLabel.text = _model.visit_time;
        
    }else{
    
        if ([_model.location_city_switch intValue]==1) {
            self.introduceLabel.text = @"隐身";
        }
        else
        {
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
            }
        }
    }
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
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
    
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.blurEffectView.frame = self.headImageView.frame;
    self.blurEffectView.layer.cornerRadius = 29;
    self.blurEffectView.layer.masksToBounds = YES;
    self.blurEffectView.alpha = 0.9;
    [self.contentView addSubview:self.blurEffectView];
    self.blurEffectView.hidden = YES;
    [self.contentView addSubview:self.vipView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
