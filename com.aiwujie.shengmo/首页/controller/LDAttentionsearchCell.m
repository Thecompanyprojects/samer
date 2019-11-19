//
//  LDAttentionsearchCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDAttentionsearchCell.h"
#import "ageView.h"
#import "wealthView.h"
#import "LDAttentioninfoModel.h"


@interface LDAttentionsearchCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UIImageView *vipImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *cerImg;
@property (nonatomic,strong) UIView *onlineView;
@property (nonatomic,strong) ageView *age;
@property (nonatomic,strong) UILabel *sexLab;
@property (nonatomic,strong) wealthView *wealthView;//魅力
@property (nonatomic,strong) wealthView *charmView;//财富
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UILabel *marknameLab;
@property (nonatomic,strong) UILabel *addressLab;

@end

@implementation LDAttentionsearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.vipImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.cerImg];
        [self.contentView addSubview:self.onlineView];
        [self.contentView addSubview:self.age];
        [self.contentView addSubview:self.sexLab];
        [self.contentView addSubview:self.wealthView];
        [self.contentView addSubview:self.charmView];
        [self.contentView addSubview:self.messageLab];
        [self.contentView addSubview:self.addressLab];
        [self setuplayout];
    }
    return self;
}

- (void)setModel:(LDAttentionsearchModel *)model
{
    LDAttentioninfoModel *info = model.userInfo;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:info.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
    
    if (info.markname.length==0) {
        self.nameLab.text = info.nickname;
    }
    else
    {
        self.nameLab.text = info.markname;
    }
    
    if ([info.onlinestate intValue] == 0) {
        self.onlineView.hidden = YES;
    }else{
        self.onlineView.hidden = NO;
    }
    
    if ([info.is_admin intValue]==1) {
        self.vipImg.hidden = NO;
        self.vipImg.image = [UIImage imageNamed:@"官方认证"];
    }
    else if ([info.bkvip intValue]==1)
    {
        self.vipImg.hidden = NO;
        self.vipImg.image = [UIImage imageNamed:@"贵宾黑V"];
    }
    else if ([info.blvip intValue]==1)
    {
        self.vipImg.hidden = NO;
        self.vipImg.image = [UIImage imageNamed:@"蓝V"];
    }
    else if ([info.is_volunteer intValue] == 1)
    {
        self.vipImg.hidden = NO;
        self.vipImg.image = [UIImage imageNamed:@"志愿者标识"];
    }
    else
    {
        if ([info.svipannual intValue] == 1) {
            self.vipImg.hidden = NO;
            self.vipImg.image = [UIImage imageNamed:@"年svip标识"];
        }else if ([info.svip intValue] == 1){
            self.vipImg.hidden = NO;
            self.vipImg.image = [UIImage imageNamed:@"svip标识"];
        }else if ([info.vipannual intValue] == 1) {
            self.vipImg.hidden = NO;
            self.vipImg.image = [UIImage imageNamed:@"年费会员"];
        }else{
            
            if ([info.vip intValue] == 1) {
                
                self.vipImg.hidden = NO;
                
                self.vipImg.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                self.vipImg.hidden = YES;
            }
        }
    }
    
    if ([info.role isEqualToString:@"S"]) {

        self.sexLab.text = @"斯";
        self.sexLab.backgroundColor = BOYCOLOR;

    }else if ([info.role isEqualToString:@"M"]){

        self.sexLab.text = @"慕";
        self.sexLab.backgroundColor = GIRLECOLOR;

    }else if ([info.role isEqualToString:@"SM"]){

        self.sexLab.text = @"双";
        self.sexLab.backgroundColor = DOUBLECOLOR;

    }else{

        self.sexLab.text = @"~";
        self.sexLab.backgroundColor = GREENCOLORS;
    }
    
    if ([info.sex intValue] == 1) {
        self.age.leftImg.image = [UIImage imageNamed:@"男"];
        self.age.backgroundColor = BOYCOLOR;
    }else if ([info.sex intValue] == 2){
        self.age.leftImg.image = [UIImage imageNamed:@"女"];
        self.age.backgroundColor = GIRLECOLOR;
    }else{
        self.age.leftImg.image = [UIImage imageNamed:@"双性"];
        self.age.backgroundColor = DOUBLECOLOR;
    }
    
    self.age.ageLab.text = [NSString stringWithFormat:@"%@",info.age];
    __weak typeof (self) weakSelf = self;
    self.wealthView.numberLab.text = info.wealth_val;
    self.charmView.numberLab.text = info.charm_val;
    if ([info.wealth_val intValue]!=0&&[info.charm_val intValue]!=0) {
        
        [weakSelf.charmView setHidden:NO];
        [weakSelf.wealthView setHidden:NO];
        
        [weakSelf.wealthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.sexLab.mas_right).with.offset(5);
            make.top.equalTo(weakSelf.age);
            make.height.mas_offset(13);
            make.width.mas_offset([self clwidth:info.wealth_val]+26);
        }];
        
        [weakSelf.charmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.wealthView.mas_right).with.offset(5);
            make.top.equalTo(weakSelf.age);
            make.height.mas_offset(13);
            make.width.mas_offset([self clwidth:info.charm_val]+26);
        }];
    }
    if ([info.wealth_val intValue]==0&&[info.charm_val intValue]!=0) {
        
        [weakSelf.charmView setHidden:NO];
        [weakSelf.wealthView setHidden:YES];
        [weakSelf.charmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.sexLab.mas_right).with.offset(5);
            make.top.equalTo(weakSelf.age);
            make.height.mas_offset(13);
            make.width.mas_offset([self clwidth:info.charm_val]+26);
        }];
    }
    if ([info.wealth_val intValue]!=0&&[info.charm_val intValue]==0) {
        
        [weakSelf.charmView setHidden:YES];
        [weakSelf.wealthView setHidden:NO];
        
        [weakSelf.wealthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.sexLab.mas_right).with.offset(5);
            make.top.equalTo(weakSelf.age);
            make.height.mas_offset(13);
            make.width.mas_offset([self clwidth:info.wealth_val]+26);
        }];
       
    }
    if ([info.wealth_val intValue]==0&&[info.charm_val intValue]==0) {
        [weakSelf.charmView setHidden:YES];
        [weakSelf.wealthView setHidden:YES];
    }
    self.messageLab.text = info.lmarkname?:@"";
    if ([info.location_city_switch intValue]==1) {
        self.addressLab.text = @"隐身";
    }
    else
    {
        if ([info.province isEqualToString:info.city]) {
            self.addressLab.text = info.city?:@"";
        }
        else
        {
            self.addressLab.text = [NSString stringWithFormat:@"%@ %@",info.province?:@"",info.city?:@""];
        }
    }

    if (info.markname.length==0) {
        NSRange range;
        range = [model.userInfo.nickname rangeOfString:self.searchStr];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.userInfo.nickname]];
            [noteStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range];
            self.nameLab.attributedText = noteStr;
        }else{
            
        }
    }
    else
    {
      
        NSRange range;
        range = [model.userInfo.markname rangeOfString:self.searchStr];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.userInfo.markname]];
            [noteStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range];
            self.nameLab.attributedText = noteStr;
        }else{
            
        }
    }
    
    NSRange range2;
    range2 = [model.userInfo.lmarkname rangeOfString:self.searchStr];
    if (range2.location != NSNotFound) {
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.userInfo.lmarkname]];
        [noteStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range2];
        self.messageLab.attributedText = noteStr;
    }else{
        
    }
}

-(CGFloat)clwidth:(NSString*)string
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 9) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    weakSelf.iconImg.sd_layout
    .leftSpaceToView(weakSelf.contentView, 12)
    .topSpaceToView(weakSelf.contentView, 15)
    .widthIs(58)
    .heightIs(58);
    
    [weakSelf.vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImg);
        make.right.equalTo(weakSelf.iconImg);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(8);
        make.height.mas_offset(15);
    }];
    
    [weakSelf.cerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLab);
        make.width.mas_offset(14);
        make.height.mas_offset(11);
        make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(4);
    }];
    
    [weakSelf.onlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [weakSelf.age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(10);
        make.width.mas_offset(30);
        make.height.mas_offset(13);
    }];
    
    [weakSelf.sexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.age.mas_right).with.offset(4);
        make.top.equalTo(weakSelf.age);
        make.width.mas_offset(22);
        make.height.mas_offset(13);
    }];
    
    [weakSelf.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.bottom.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(14);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    
    [weakSelf.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(14);
        make.width.mas_offset(WIDTH/2);
    }];
    
    
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 58/2;
    }
    return _iconImg;
}

-(UIImageView *)vipImg
{
    if(!_vipImg)
    {
        _vipImg = [[UIImageView alloc] init];
        
    }
    return _vipImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = TextCOLOR;
        _nameLab.font = [UIFont systemFontOfSize:13];
    }
    return _nameLab;
}

-(UIImageView *)cerImg
{
    if(!_cerImg)
    {
        _cerImg = [[UIImageView alloc] init];
        _cerImg.image = [UIImage imageNamed:@"认证"];
    }
    return _cerImg;
}

-(UIView *)onlineView
{
    if(!_onlineView)
    {
        _onlineView = [[UIView alloc] init];
        
    }
    return _onlineView;
}

-(ageView *)age
{
    if(!_age)
    {
        _age = [[ageView alloc] init];
        _age.ageLab.font = [UIFont systemFontOfSize:10];
        _age.layer.masksToBounds = YES;
        _age.layer.cornerRadius = 2;
    }
    return _age;
}

-(UILabel *)sexLab
{
    if(!_sexLab)
    {
        _sexLab = [[UILabel alloc] init];
        _sexLab.textAlignment = NSTextAlignmentCenter;
        _sexLab.font = [UIFont systemFontOfSize:10];
        _sexLab.textColor = [UIColor whiteColor];
        _sexLab.layer.masksToBounds = YES;
        _sexLab.layer.cornerRadius = 2;
    }
    return _sexLab;
}

-(wealthView *)wealthView
{
    if(!_wealthView)
    {
        _wealthView = [[wealthView alloc] init];
        _wealthView.leftImg.image = [UIImage imageNamed:@"财"];
        _wealthView.numberLab.font = [UIFont systemFontOfSize:10];
        _wealthView.numberLab.textColor = TextCOLOR;
        _wealthView.numberLab.font = [UIFont systemFontOfSize:9];
        _wealthView.numberLab.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
        _wealthView.layer.masksToBounds = YES;
        _wealthView.layer.borderWidth = 0.8;
        _wealthView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
        _wealthView.layer.cornerRadius = 2;
    }
    return _wealthView;
}

-(wealthView *)charmView
{
    if(!_charmView)
    {
        _charmView = [[wealthView alloc] init];
        _charmView.leftImg.image = [UIImage imageNamed:@"魅"];
        _charmView.numberLab.font = [UIFont systemFontOfSize:9];
        _charmView.numberLab.textColor =[UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
        _charmView.layer.masksToBounds = YES;
        _charmView.layer.borderWidth = 0.8;
        _charmView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
        _charmView.layer.cornerRadius = 2;
    }
    return _charmView;
}

-(UILabel *)messageLab
{
    if(!_messageLab)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
        _messageLab.font = [UIFont systemFontOfSize:13];
    }
    return _messageLab;
}

-(UILabel *)addressLab
{
    if(!_addressLab)
    {
        _addressLab = [[UILabel alloc] init];
        _addressLab.textColor = [UIColor colorWithHexString:@"A7A7A7" alpha:1];
        _addressLab.font = [UIFont systemFontOfSize:12];
        _addressLab.textAlignment = NSTextAlignmentRight;
    }
    return _addressLab;
}


@end
