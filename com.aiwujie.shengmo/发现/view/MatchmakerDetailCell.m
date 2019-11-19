//
//  MatchmakerDetailCell.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "MatchmakerDetailCell.h"

@implementation MatchmakerDetailCell

-(void)matchmasterDic:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        [self changeLabel:self.oneLabel andName:[NSString stringWithFormat:@"  年龄: %@岁  ",dic[@"age"]] andDic:dic];
        [self changeLabel:self.twoLabel andName:[NSString stringWithFormat:@"  星座: %@  ",dic[@"starchar"]] andDic:dic];
        [self changeLabel:self.threeLabel andName:[NSString stringWithFormat:@"  身高: %@cm  ",dic[@"tall"]] andDic:dic];
        [self changeLabel:self.foureLabel andName:[NSString stringWithFormat:@"  体重: %@kg  ",dic[@"weight"]] andDic:dic];
        [self changeLabel:self.fiveLabel andName:[NSString stringWithFormat:@"  学历: %@  ",dic[@"culture"]] andDic:dic];
        [self changeLabel:self.sixLabel andName:[NSString stringWithFormat:@"  月薪: %@  ",dic[@"monthly"]] andDic:dic];
        
       
    }else if(indexPath.section == 1){
        
        NSString *role;
        
        if ([dic[@"role"] isEqualToString:@"S"]) {
            
           role = @"斯";
            
        }else if ([dic[@"role"] isEqualToString:@"M"]){
            
            role = @"慕";
            
        }else if([dic[@"role"] isEqualToString:@"SM"]){
            
            role = @"双";
            
        }else{
            
            role = @"~";
            
        }

    
        [self changeLabel:self.oneLabel andName:[NSString stringWithFormat:@"  角色: %@  ",role] andDic:dic];
        [self changeLabel:self.twoLabel andName:[NSString stringWithFormat:@"  接触: %@  ",dic[@"along"]] andDic:dic];
        [self changeLabel:self.threeLabel andName:[NSString stringWithFormat:@"  实践: %@  ",dic[@"experience"]] andDic:dic];
        [self changeLabel:self.foureLabel andName:[NSString stringWithFormat:@"  程度: %@  ",dic[@"level"]] andDic:dic];
        [self changeLabel:self.fiveLabel andName:[NSString stringWithFormat:@"  取向: %@  ",dic[@"sexual"]] andDic:dic];
        [self changeLabel:self.sixLabel andName:[NSString stringWithFormat:@"  想找: %@  ",dic[@"want"]] andDic:dic];
    
    }else if (indexPath.section == 2){
        
        if ([dic[@"match_introduce"] length] == 0) {
            
           self.introduceLabel.text = @"未填写";
            
            self.introduceH.constant = 16;
            
        }else{
            
            self.introduceH.constant = [self.introduceLabel heightForAttributedString:dic[@"match_introduce"] andFont:[UIFont systemFontOfSize:14] andLabel:self.introduceLabel andLabelWidth:WIDTH - 66 andLinespace:5];
            
        }
        
    }else if (indexPath.section == 3){
        
        if ([dic[@"match_makerintroduce"] length] == 0) {
            
            self.introduceLabel.text = @"未填写";
            
            self.introduceH.constant = 16;
            
        }else{
            
            self.introduceH.constant = [self.introduceLabel heightForAttributedString:dic[@"match_makerintroduce"] andFont:[UIFont systemFontOfSize:14] andLabel:self.introduceLabel andLabelWidth:WIDTH - 66 andLinespace:5];
        }
    }
}

-(void)changeLabel:(UILabel *)label andName:(NSString *)name andDic:(NSDictionary *)dic{

    label.text = name;
    
    if ([dic[@"sex"] intValue] == 1) {
        
        label.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"sex"] intValue] == 2){
        
        label.backgroundColor = GIRLECOLOR;
        
    }else{
        
        label.backgroundColor = DOUBLECOLOR;
    }
    
    label.layer.cornerRadius = 2;
    label.clipsToBounds = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
