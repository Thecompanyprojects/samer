//
//  CollectCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 a. All rights reserved.
//

#import "CollectCell.h"

@interface CollectCell()
@property (nonatomic,strong) UIVisualEffectView * blurEffectView;
@end

@implementation CollectCell

-(void)setModel:(CollectModel *)model{

    _model = model;
    
    [self createUI];
}

-(void)createUI{

    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([self.typeStr intValue]==1) {
        
        if ([_model.location_switch intValue]==1||[_model.location_city_switch intValue]==1) {
           
            self.blurEffectView.hidden = YES;
        }
        else
        {
            self.blurEffectView.hidden = YES;
            
        }
        
    }
    if ([self.typeStr intValue]==7) {
        
        if ([_model.login_time_switch intValue]==1) {
            self.blurEffectView.hidden = YES;
        }
        else
        {
            self.blurEffectView.hidden = YES;
            
        }
    }
    
    if ([_model.onlinestate intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
    
        self.onlineLabel.hidden = NO;
    }
    
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
        
    }else{
    
        self.idImageView.hidden = NO;
    }
    
     if (self.integer == 2001){
    
        self.distanceLabel.hidden = YES;
         
     }else{
         
         if ([_model.lat floatValue] == 0 || [_model.lng floatValue] == 0) {
             
             self.distanceLabel.hidden = YES;
             
         }else{
             
             self.distanceLabel.text = [NSString stringWithFormat:@"%@",_model.distance];
             
             self.distanceLabel.hidden = NO;
         }
     }
    
    
    if ([_model.sex intValue] == 1) {
        
        self.sexImageView.image = [UIImage imageNamed:@"男"];
        
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([_model.sex intValue] == 2){
    
        self.sexImageView.image = [UIImage imageNamed:@"女"];
        
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
    
        self.sexImageView.image = [UIImage imageNamed:@"双性"];
        
        self.aSexView.backgroundColor = DOUBLECOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.bounds = _layerView.bounds;
    gradientLayer.borderWidth = 0;
    
    gradientLayer.frame = _layerView.bounds;
    
   
    gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0, 0.1);
    
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设定颜色分割点
//    gradientLayer.locations = @[@(0.5f) ,@(0.5f)];
    
    [_layerView.layer addSublayer:gradientLayer];
    
    [_backImageView addSubview:_layerView];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.blurEffectView.frame = self.backImageView.frame;
    self.blurEffectView.layer.masksToBounds = YES;
    self.blurEffectView.alpha = 0.95;
    [self.contentView addSubview:self.blurEffectView];
    self.blurEffectView.hidden = YES;
    [self.contentView addSubview:self.vipView];
    
}

@end
