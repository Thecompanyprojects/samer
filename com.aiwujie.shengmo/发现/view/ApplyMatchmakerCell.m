//
//  ApplyMatchmakerCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "ApplyMatchmakerCell.h"

@implementation ApplyMatchmakerCell

-(void)cellwithDic:(NSDictionary *)dic{
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"head_pic"]] placeholderImage:[UIImage imageNamed:@"红娘未知图片"]];
    
    self.headerNameLabel.text = dic[@"nickname"];
    
    if ([dic[@"realname"] intValue] == 1) {
        
        self.headerCerView.hidden = NO;
        
    }else{
        
        self.headerCerView.hidden = YES;
    }
    
        
    self.headerServiceTimeLabel.text = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
    
    if ([dic[@"remarks"] length] == 0) {
        
        self.matchObListView.hidden = YES;
        self.noMatchObListView.hidden = NO;
        self.noMatchObListLabel.hidden = NO;
        
        self.matchObListTextView.text = @"";
        
    }else{
        
        self.matchObListView.hidden = NO;
        self.noMatchObListView.hidden = YES;
        self.noMatchObListLabel.hidden = YES;
        
        self.matchObListTextView.text = [NSString stringWithFormat:@"%@",dic[@"remarks"]];
    }
    
    if ([dic[@"role"] isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if([dic[@"role"] isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        
        self.sexualLabel.backgroundColor = DOUBLECOLOR;
        
    }else{
        
        self.sexualLabel.text = @"~";
        self.sexualLabel.backgroundColor = GREENCOLORS;
    }
    
    if ([dic[@"sex"] intValue] == 1) {
        
        self.sexLabel.image = [UIImage imageNamed:@"男"];
        
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"sex"] intValue] == 2){
        
        self.sexLabel.image = [UIImage imageNamed:@"女"];
        
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        self.sexLabel.image = [UIImage imageNamed:@"双性"];
        
        self.aSexView.backgroundColor = DOUBLECOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",dic[@"age"]];
    
    self.cityView.layer.cornerRadius = 2;
    self.cityView.layer.masksToBounds = YES;
    
    if (![dic[@"city"] isEqual:[NSNull null]] && ![dic[@"province"] isEqual:[NSNull null]]) {
        
        if([dic[@"city"] length] != 0){
            
            if ([dic[@"city"] isEqualToString:dic[@"province"]]) {
                
                self.cityLabel.text = dic[@"city"];
                
            }else{
                
                if ([dic[@"province"] length] != 0) {
                    
                    self.cityLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"province"],dic[@"city"]];
                    
                }else{
                    
                    self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"city"]];
                }
            }
            
        }else{
            
            self.cityLabel.text = @"隐身";
            
        }
    }else{
        
        self.cityLabel.text = @"隐身";
    }
    
    [self.cityLabel sizeToFit];
    
    self.cityW.constant = 18 + CGRectGetWidth(self.cityLabel.frame);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.phoneView.layer.cornerRadius = 2;
    
    for (int i = 10 ; i < 13; i++) {
        
        UIButton *button = [self viewWithTag:i];
        
        button.layer.cornerRadius = 35;
    }
    
    self.headerImageView.layer.cornerRadius = 30;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.layer.masksToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mobileButtonClick:(id)sender {
}
@end
