//
//  CommentedCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "CommentedCell.h"

@implementation CommentedCell

-(void)setModel:(CommentedModel *)model{

    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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

    
    self.nameLabel.text = model.nickname;
    
    self.timeLabel.text = model.addtime;
    
    if ([self.type intValue] == 1) {
        
        self.contentLabel.isCopyable = YES;
        
        if ([model.otheruid intValue] == 0) {
            
            self.contentLabel.text = [NSString stringWithFormat:@"%@",model.ccontent];
        }else{
            
            self.contentLabel.text = [NSString stringWithFormat:@"回复 %@:%@",model.othernickname,model.ccontent];
        }

    }else if ([self.type intValue] == 2){
        
        self.contentLabel.isCopyable = NO;
    
        self.contentLabel.text = [NSString stringWithFormat:@"%@赞了你的动态",model.nickname];
        
    }else if ([self.type intValue] == 3){
        
        self.contentLabel.isCopyable = NO;
    
        self.contentLabel.text = [NSString stringWithFormat:@"%@打赏了你",model.nickname];
    }else if ([self.type intValue] == 4){
        
        self.contentLabel.isCopyable = NO;
        self.timeLabel.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:model.addtime];
        self.contentLabel.text = [NSString stringWithFormat:@"%@推顶了你",model.nickname];
    }

    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentLabel sizeToFit];
    self.contentView.frame = CGRectMake(0, 0, WIDTH, self.contentView.frame.size.height + self.contentLabel.frame.size.height - 21);
    if (model.content.length != 0) {
        self.ccomentLabel.text = model.content;
        
    }else{
    
        [self.ccomentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.pic]] placeholderImage:nil];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = 20;
    self.headView.clipsToBounds = YES;
    
    self.ccomentView.layer.cornerRadius = 2;
    self.ccomentView.clipsToBounds = YES;
    
    self.ccomentLabel.layer.cornerRadius = 2;
    self.ccomentLabel.clipsToBounds = YES;
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
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
