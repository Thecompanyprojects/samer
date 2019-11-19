//
//  ApplyGroupCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "ApplyGroupCell.h"

@interface ApplyGroupCell()
@property (nonatomic,strong) UILabel *timeLab;

@end

@implementation ApplyGroupCell

+(instancetype)cellWithApplyCell:(UITableView *)tableView{
    ApplyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyGroup"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyGroupCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setModel:(ApplyGroupModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    if ([model.state intValue] == 1) {
        self.agreeButton.hidden = NO;
        self.refuseButton.hidden = NO;
        self.completeButton.hidden = YES;
        self.contentLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.msgLabel.hidden = NO;
        self.nameLabel.text = model.content;
        if (model.msg.length == 0) {
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:未填写"];
        }else{
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:%@",model.msg];
        }
    }else if ([model.state intValue] == 2) {
        self.agreeButton.hidden = YES;
        self.refuseButton.hidden = YES;
        self.completeButton.hidden = NO;
        [self.completeButton setTitle:@"已同意" forState:normal];
        self.contentLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.msgLabel.hidden = NO;
        self.nameLabel.text = model.content;
        if (model.msg.length == 0) {
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:未填写"];
        }else{
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:%@",model.msg];
        }
    }else if ([model.state intValue]==3)
    {
        self.agreeButton.hidden = YES;
        self.refuseButton.hidden = YES;
        self.completeButton.hidden = NO;
        [self.completeButton setTitle:@"已拒绝" forState:normal];
        self.contentLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.msgLabel.hidden = NO;
        self.nameLabel.text = model.content;
        if (model.msg.length == 0) {
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:未填写"];
        }else{
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:%@",model.msg];
        }
    }
    else if([model.state intValue] == 0){
    
        self.agreeButton.hidden = YES;
        self.refuseButton.hidden = YES;
        self.completeButton.hidden = YES;
        self.nameLabel.hidden = YES;
        self.msgLabel.hidden = YES;
        self.contentLabel.hidden = NO;
        self.contentLabel.text = model.content;
    }
    self.timeLab.text = model.operatortime?:@"";
    self.chooseLab.text = model.nickname?:@"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = 25;
    self.headView.clipsToBounds = YES;
    
    self.refuseButton.layer.cornerRadius = 2;
    self.refuseButton.clipsToBounds = YES;
    
    self.agreeButton.layer.cornerRadius = 2;
    self.agreeButton.clipsToBounds = YES;
    
    self.completeButton.layer.cornerRadius = 2;
    self.completeButton.clipsToBounds = YES;
    
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.chooseLab];
    [self setuplayout];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.msgLabel.mas_bottom).with.offset(-2);
        make.height.mas_offset(13);
    }];
    [weakSelf.chooseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-20);
        make.height.mas_offset(14);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-10);
    }];
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
        _timeLab.font = [UIFont systemFontOfSize:12];
    }
    return _timeLab;
}

-(UILabel *)chooseLab
{
    if(!_chooseLab)
    {
        _chooseLab = [[UILabel alloc] init];
        _chooseLab.textAlignment = NSTextAlignmentRight;
        _chooseLab.font = [UIFont systemFontOfSize:13];
        _chooseLab.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
    }
    return _chooseLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
