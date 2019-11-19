//
//  BillCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "BillCell.h"

@interface BillCell()
@property (nonatomic,strong) UILabel *ccomentLabel;
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *newtimeLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *vipView;
@end

@implementation BillCell

-(void)setModel:(BillModel *)model{
    
    _model = model;
    
    NSArray *giftArray = @[@"握手",@"黄瓜",@"玫瑰",@"送吻",@"红酒",@"对戒",@"蛋糕",@"跑车",@"游轮",@"棒棒糖",@"狗粮",@"雪糕",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
    
    if ([self.type isEqualToString:@"收到的礼物"]) {
        
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
        
            self.beanLabel.text = [NSString stringWithFormat:@"系统礼物"];
            
        }else{
        
            self.beanLabel.text = [NSString stringWithFormat:@"+%@魔豆",model.beans];
        }
        
        if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
        
            if (giftArray.count >= [model.type intValue]) {
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[%@]×%@",model.nickname,giftArray[[model.type intValue] - 1],model.num];
                
            }else{
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[新版系统礼物]×%@",model.nickname,model.num];
            }

        }else{
        
            if (giftArray.count >= [model.type intValue]) {
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[%@]×%@[%@元]",model.nickname,giftArray[[model.type intValue] - 1],model.num,model.amount];
                
            }else{
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[新版礼物]×%@[%@元]",model.nickname,model.num,model.amount];
            }

        }
        
    }else if([self.type isEqualToString:@"礼物系统赠送"]){
        
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
            
        self.beanLabel.text = [NSString stringWithFormat:@"系统礼物"];
        
        if (giftArray.count >= [model.type intValue]) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"系统赠[%@]×%@",giftArray[[model.type intValue] - 1],model.num];
            
        }else{
            
            self.moneyLabel.text = [NSString stringWithFormat:@"系统赠[新版系统礼物]×%@",model.num];
        }

    }else if ([self.type isEqualToString:@"礼物赠送记录"]){
        
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        
        NSString *vip;
        
        if ([model.type intValue] == 1) {
            vip = @"VIP1个月";
        }else if ([model.type intValue] == 2){
            vip = @"VIP3个月";
        }else if ([model.type intValue] == 3){
            vip = @"VIP6个月";
        }else if ([model.type intValue] == 4){
            vip = @"VIP12个月";
        }else{
            vip = @"VIP";
        }
        self.beanLabel.text = [NSString stringWithFormat:@"-%@魔豆",model.beans];
        self.moneyLabel.text = [NSString stringWithFormat:@"赠%@%@[%@元]",model.nickname,vip,model.amount];
    }
    else if ([self.type isEqualToString:@"礼物提现记录"]){
        self.timeLabel.text = model.success_time_format;
        self.weekLabel.text = model.week;
        self.beanLabel.text = [NSString stringWithFormat:@"-%@魔豆",model.beans];
        self.moneyLabel.text = [NSString stringWithFormat:@"提现[%@元]",model.money];
    }
    else if([self.type isEqualToString:@"充值记录"]){
        self.timeLabel.text = model.date;
        self.weekLabel.text = model.week;
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.amount];
        self.beanLabel.text = [NSString stringWithFormat:@"%@金魔豆",model.beans];
    }
    else if([self.type isEqualToString:@"充值赠送记录"]){
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
            self.beanLabel.text = [NSString stringWithFormat:@"系统礼物"];
        }else{
            self.beanLabel.text = [NSString stringWithFormat:@"-%@金魔豆",model.beans];
        }
        if ([model.state intValue] == 1) {
            if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
                if (giftArray.count >= [model.type intValue]) {
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[%@]×%@",model.nickname?:@"",giftArray[[model.type intValue] - 1],model.num];
                }else{
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[新版系统礼物]×%@",model.nickname?:@"",model.num];
                }
            }else{
                if (giftArray.count >= [model.type intValue]) {
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[%@]×%@[%@元]",model.nickname?:@"",giftArray[[model.type intValue] - 1],model.num,model.amount];
                }else{
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[新版礼物]×%@[%@元]",model.nickname?:@"",model.num,model.amount];
                }
            }
        }
        if ([model.state intValue] == 2){
            NSString *vip;
            if ([model.type intValue] == 1) {
                vip = @"VIP1个月";
            }else if ([model.type intValue] == 2){
                vip = @"VIP3个月";
            }else if ([model.type intValue] == 3){
                vip = @"VIP6个月";
            }else if ([model.type intValue] == 4){
                vip = @"VIP12个月";
            }else{
                vip = @"VIP";
            }
            self.moneyLabel.text = [NSString stringWithFormat:@"赠%@%@%@",vip,model.amount,@"个月"];
        }
        //3:svip 4
        if ([model.state intValue] == 3){
            NSString *vip;
            if ([model.type intValue] == 1) {
                vip = @"SVIP1个月";
            }else if ([model.type intValue] == 2){
                vip = @"SVIP3个月";
            }else if ([model.type intValue] == 3){
                vip = @"SVIP6个月";
            }else if ([model.type intValue] == 4){
                vip = @"SVIP12个月";
            }else{
                vip = @"SVIP";
            }
             self.moneyLabel.text = [NSString stringWithFormat:@"赠%@%@%@",vip,model.amount,@"个月"];
        }
        //4 推顶卡
        if ([model.state intValue] == 4){
            self.moneyLabel.text = [NSString stringWithFormat:@"赠推顶卡%@张",model.num];
        }
        //充值魔豆
        if ([model.state intValue] == 5){
            self.moneyLabel.text = [NSString stringWithFormat:@"赠%@金魔豆%@个",model.fnickname,model.num];
        }
    }
    else if([self.type isEqualToString:@"充值兑换记录"] ){
        
        self.timeLabel.text =model.addtime_format;
        self.weekLabel.text = model.week;
        if ([model.type intValue]==1) {
            self.beanLabel.text = [NSString stringWithFormat:@"-%@银魔豆",model.beans];
        }
        else
        {
             self.beanLabel.text = [NSString stringWithFormat:@"-%@金魔豆",model.beans];
        }
       
        //state:(1:vip 2:邮票 3:svip 4:推顶卡  5:充值魔豆)
        if ([model.state intValue] == 1) {
            NSString *vip;
            if ([model.type intValue] == 1) {
                vip = @"VIP1个月";
            }else if ([model.type intValue] == 2){
                vip = @"VIP3个月";
            }else if ([model.type intValue] == 3){
                vip = @"VIP6个月";
            }else if ([model.type intValue] == 4){
                vip = @"VIP12个月";
            }else{
                vip = @"VIP";
            }
            self.moneyLabel.text = [NSString stringWithFormat:@"兑换%@",vip];
        }
        //邮票
        if ([model.state intValue] == 2){
            self.moneyLabel.text = [NSString stringWithFormat:@"兑换斯慕邮票%@张",model.num];
        }
        //3:svip 4
        if ([model.state intValue] == 3){
            NSString *vip;
            if ([model.type intValue] == 1) {
                vip = @"SVIP1个月";
            }else if ([model.type intValue] == 2){
                vip = @"SVIP3个月";
            }else if ([model.type intValue] == 3){
                vip = @"SVIP6个月";
            }else if ([model.type intValue] == 4){
                vip = @"SVIP12个月";
            }else{
                vip = @"SVIP";
            }
            self.moneyLabel.text = [NSString stringWithFormat:@"兑换%@",vip];
        }
        //4 推顶卡
        if ([model.state intValue] == 4){
            self.moneyLabel.text = [NSString stringWithFormat:@"兑换推顶卡%@张",model.num];
        }
        //充值魔豆
        if ([model.state intValue] == 5){
           self.moneyLabel.text = [NSString stringWithFormat:@"兑换金魔豆%@个",model.num];
        }
    }
    else if ([self.type isEqualToString:@"礼物兑换记录"])
    {
        self.timeLabel.text =model.date;
        self.weekLabel.text = model.week;
        self.beanLabel.text = [NSString stringWithFormat:@"%@金魔豆",model.beans];
    }
    else if([self.type isEqualToString:@"邮票购买记录"]){
        
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        self.beanLabel.text = [NSString stringWithFormat:@"+%@张邮票",model.num];
        if ([model.amount intValue] == 0) {
            self.moneyLabel.text = [NSString stringWithFormat:@"用%@金魔豆兑换",model.beans];
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"充值%@元",model.amount];
        }
    }else if ([self.type isEqualToString:@"邮票系统赠送记录"]){
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        self.beanLabel.text = [NSString stringWithFormat:@"+%d张邮票",[model.num intValue] * 3];
        self.moneyLabel.text = [NSString stringWithFormat:@"[%@]赠男/女/CDTS票各%@张",model.type,model.num];
    }else if([self.type isEqualToString:@"邮票使用记录"]){
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        self.moneyLabel.text = [NSString stringWithFormat:@"给%@发消息",model.nickname];
        if ([model.type intValue] == 1) {
            self.beanLabel.text = [NSString stringWithFormat:@"-1张男票"];
        }else if ([model.type intValue] == 2){
            self.beanLabel.text = [NSString stringWithFormat:@"-1张女票"];
        }else if([model.type intValue] == 3){
            self.beanLabel.text = [NSString stringWithFormat:@"-1张CDTS票"];
        }else if ([model.type intValue] == 4){
            self.beanLabel.text = [NSString stringWithFormat:@"-1张通用邮票"];
        }
    }
    else if ([self.type isEqualToString:@"推顶购买记录"])
    {
        self.timeLabel.text = model.addtime_format;
        self.beanLabel.text = [NSString stringWithFormat:@"+%@张推顶卡",model.num];
        self.weekLabel.text = @"";
        if ([model.amount intValue] == 0) {
            self.moneyLabel.text = [NSString stringWithFormat:@"用%@金魔豆兑换",model.beans];
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"充值%@元",model.amount];
        }
    }
    else if ([self.type isEqualToString:@"推顶使用记录"])
    {
        self.timeLabel.text = [[TimeManager defaultTool]getDateFormatStrFromTimeStampWithSeconds:model.addtime];
        self.weekLabel.text = @"";
        if (model.content.length != 0) {
            [self.ccomentLabel setHidden:NO];
            self.ccomentLabel.text = model.content;
        }
        
        if (model.interval.length==0||[model.interval intValue]==0) {
             self.weekLabel.text = @"";
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",model.use_sum,@"次/",model.sum,@"卡/",model.interval];
            self.weekLabel.text = str;
        }
    }
    else if ([self.type isEqualToString:@"他人推顶记录"])
    {

        self.timeLabel.text = @"";
        self.weekLabel.text = @"";
        
        [self.iconImg setHidden:NO];
        [self.nameLab setHidden:NO];
        [self.ccomentLabel setHidden:NO];
        [self.contentLab setHidden:NO];
        [self.newtimeLab setHidden:NO];
        
        self.nameLab.text = model.nickname;
        self.ccomentLabel.text = model.content;
        self.contentLab.text = model.content;
        self.newtimeLab.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStamp:model.addtime];
        
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        if ([model.is_volunteer intValue] == 1) {

            self.vipView.hidden = NO;

            self.vipView.image = [UIImage imageNamed:@"志愿者标识"];

        }else if ([_model.is_admin intValue] == 1) {

            self.vipView.hidden = NO;

            self.vipView.image = [UIImage imageNamed:@"官方认证"];

        }else{

            if ([model.svipannual intValue] == 1) {

                self.vipView.hidden = NO;

                self.vipView.image = [UIImage imageNamed:@"年svip标识"];

            }else if ([model.svip intValue] == 1){

                self.vipView.hidden = NO;

                self.vipView.image = [UIImage imageNamed:@"svip标识"];

            }else if ([model.vipannual intValue] == 1) {

                self.vipView.hidden = NO;

                self.vipView.image = [UIImage imageNamed:@"年费会员"];

            }else{

                if ([model.vip intValue] == 1) {

                    self.vipView.hidden = NO;

                    self.vipView.image = [UIImage imageNamed:@"高级紫"];

                }else{

                    self.vipView.hidden = YES;
                }

            }

        }
    }
    else if ([self.type isEqualToString:@"会员购买记录"])
    {
        
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        
//        于（addtime_format）用（beans魔豆兑换|amount人民币购买）（long天）（pay_type 会员）（赠送给了fnickname用户）
        BOOL isbeans = false;
        
        if (![model.beans isEqualToString:@"0"]) {
            isbeans = YES;
        }

        BOOL isfonk = false;
        if (model.nickname.length!=0) {
            isfonk = YES;
        }
        NSString *str1 = @"";
        if (isbeans) {
            self.beanLabel.text = [NSString stringWithFormat:@"%@%@",model.beans,@"金魔豆"];
        }
        else
        {
            self.beanLabel.text = [NSString stringWithFormat:@"%@%@",model.amount,@"元"];
        }
        
        if (isfonk) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",@"赠",model.nickname,model.pay_type,model.days,@"天"];
            self.moneyLabel.text = str;
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",@"购买",str1,model.pay_type,model.days,@"天"];
            self.moneyLabel.text = str;
        }

    }
    else if ([self.type isEqualToString:@"会员获赠记录"])
    {
        self.timeLabel.text = model.addtime_format;
        self.weekLabel.text = model.week;
        BOOL isbeans = false;
        
        if (![model.beans isEqualToString:@"0"]) {
            isbeans = YES;
        }
        
        BOOL isfonk = false;
        if (model.nickname.length!=0) {
            isfonk = YES;
        }
        if (isbeans) {
            self.beanLabel.text = [NSString stringWithFormat:@"%@%@",model.beans,@"金魔豆"];
        }
        else
        {
            
            self.beanLabel.text = [NSString stringWithFormat:@"%@%@",model.beans,@"元"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",model.nickname,@"赠",@"我",model.pay_type,model.days,@"天"];
        self.moneyLabel.text = str;

    }
}

-(UILabel *)ccomentLabel
{
    if(!_ccomentLabel)
    {
        _ccomentLabel = [[UILabel alloc] init];
        _ccomentLabel.font = [UIFont systemFontOfSize:12];
        _ccomentLabel.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
        _ccomentLabel.textAlignment = NSTextAlignmentCenter;
        _ccomentLabel.textColor = TextCOLOR;
        _ccomentLabel.numberOfLines = 0;
        [_ccomentLabel setHidden:YES];
    }
    return _ccomentLabel;
}


-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = MainColor;
        _nameLab.font = [UIFont systemFontOfSize:14];
        [_nameLab setHidden:YES];
    }
    return _nameLab;
}



-(UILabel *)newtimeLab
{
    if(!_newtimeLab)
    {
        _newtimeLab = [[UILabel alloc] init];
        _newtimeLab.textColor = [UIColor colorWithHexString:@"686868" alpha:1];
        _newtimeLab.font = [UIFont systemFontOfSize:11];
        [_newtimeLab setHidden:YES];
    }
    return _newtimeLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = TextCOLOR;
        _contentLab.font = [UIFont systemFontOfSize:12];
        [_contentLab setHidden:YES];
    }
    return _contentLab;
}

-(UIImageView *)vipView
{
    if(!_vipView)
    {
        _vipView = [UIImageView new];
        [_vipView setHidden:YES];
    }
    return _vipView;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.ccomentLabel];
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.vipView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.newtimeLab];
    [self setuplayout];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.ccomentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-12);
        make.width.mas_offset(56);
        make.height.mas_offset(56);
    }];
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(40);
        make.height.mas_offset(40);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(15);
        
    }];
    [weakSelf.newtimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(7);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(15);
        make.right.equalTo(weakSelf.ccomentLabel.mas_left).with.offset(-8);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.newtimeLab.mas_bottom).with.offset(7);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(15);
        make.right.equalTo(weakSelf.ccomentLabel.mas_left).with.offset(-8);
    }];
    [weakSelf.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.iconImg);
        make.bottom.equalTo(weakSelf.iconImg);
        make.width.mas_offset(19);
        make.height.mas_offset(19);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
