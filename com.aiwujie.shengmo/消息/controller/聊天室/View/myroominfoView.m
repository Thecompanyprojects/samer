//
//  myroominfoView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/8/20.
//  Copyright © 2019 a. All rights reserved.
//

#import "myroominfoView.h"
#import "ageView.h"
#import "wealthView.h"
#import "UIColor+IHGradientChange.h"

@interface myroominfoView()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *certificationImg;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) ageView *ageLab;
@property (nonatomic,strong) UILabel *sexView;
@property (nonatomic,strong) wealthView *wealView;
@property (nonatomic,strong) wealthView *charmView;
@end

@implementation myroominfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.headImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.certificationImg];
        [self addSubview:self.lineView];
        [self addSubview:self.ageLab];
        [self addSubview:self.sexView];
        [self addSubview:self.wealView];
        [self addSubview:self.charmView];
        [self addSubview:self.mikeBtn];
        [self addSubview:self.infoBtn];
        [self setuplayout];
        
    }
    return self;
}

-(void)getuserinfofromWeb
{
    NSString *url = [PICHEADURL stringByAppendingString:getUserInfoUrl];
    self.model = [[infoModel alloc] init];
    NSDictionary *parameters;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        parameters = @{@"uid":self.userId?:@"",@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }else{
        parameters = @{@"uid":self.userId?:@"",@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"retcode"] intValue]==2000) {
            NSDictionary *dict = [responseObj objectForKey:@"data"];
            
            self.model = [infoModel yy_modelWithDictionary:dict];
            [self changeViewsfrom:self.model];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)changeViewsfrom:(infoModel *)model
{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLab.text = model.nickname?:@"";
    
    __weak typeof (self) weakSelf = self;
    
    if ([model.realname intValue]==0) {
        
        if ([self.userId intValue]==[[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            self.certificationImg.image = [UIImage imageNamed:@"认证灰色"];
            [self.certificationImg setHidden:NO];
            [weakSelf.certificationImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.nameLab);
                make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(6);
                make.width.mas_offset(17);
                make.height.mas_offset(12);
            }];
            
            [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.nameLab);
                make.left.equalTo(weakSelf.certificationImg.mas_right).with.offset(6);
                make.width.mas_offset(6);
                make.height.mas_offset(6);
            }];
        }
        else
        {
            [self.certificationImg setHidden:YES];
            [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.nameLab);
                make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(6);
                make.width.mas_offset(6);
                make.height.mas_offset(6);
            }];
        }
        
    }
    else
    {
        [self.certificationImg setHidden:NO];
        [weakSelf.certificationImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.nameLab);
            make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(6);
            make.width.mas_offset(17);
            make.height.mas_offset(12);
        }];
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.nameLab);
            make.left.equalTo(weakSelf.certificationImg.mas_right).with.offset(6);
            make.width.mas_offset(6);
            make.height.mas_offset(6);
        }];
    }
    
    if ([model.role isEqualToString:@"S"]) {
        
        self.sexView.text = @"斯";
        self.sexView.backgroundColor = BOYCOLOR;
        
    }else if ([model.role isEqualToString:@"M"]){
        
        self.sexView.text = @"慕";
        self.sexView.backgroundColor = GIRLECOLOR;
    }else if ([model.role isEqualToString:@"SM"]){
        
        self.sexView.text = @"双";
        self.sexView.backgroundColor = DOUBLECOLOR;
    }else{
        
        self.sexView.text = @"~";
        self.sexView.backgroundColor = GREENCOLORS;
    }
    
    
    if ([model.sex intValue] == 1) {
        self.ageLab.backgroundColor = BOYCOLOR;
        self.ageLab.leftImg.image = [UIImage imageNamed:@"男"];
    }else if ([model.sex intValue] == 2){
        self.ageLab.backgroundColor = GIRLECOLOR;
        self.ageLab.leftImg.image = [UIImage imageNamed:@"女"];
    }else{
        self.ageLab.backgroundColor = DOUBLECOLOR;
        self.ageLab.leftImg.image = [UIImage imageNamed:@"双"];
    }
    self.ageLab.ageLab.text = [NSString stringWithFormat:@"%@",model.age];
    
    [weakSelf.sexView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(22);
        make.height.mas_offset(15);
        make.right.equalTo(weakSelf).with.offset(-WIDTH/2-6);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(8);
    }];
    
    [weakSelf.ageLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(36);
        make.height.mas_offset(15);
        make.right.equalTo(weakSelf.sexView.mas_left).with.offset(-4);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(8);
    }];
    
    NSString *str1 = model.wealth_val;
    NSString *str2 = model.charm_val;
    
    [weakSelf.wealView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(WIDTH/2);
        make.top.equalTo(weakSelf.ageLab);
        make.height.mas_offset(15);
        make.width.mas_offset([self clwidth:str1]+26);
    }];
    
    [weakSelf.charmView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.wealView.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.ageLab);
        make.height.mas_offset(15);
        make.width.mas_offset([self clwidth:str2]+26);
    }];
    
    self.wealView.numberLab.text = str1;
    self.charmView.numberLab.text = str2;
    
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(40);
    }];
    [weakSelf.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(80);
        make.height.mas_offset(80);
        make.top.equalTo(weakSelf);
    }];
    [weakSelf.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(80);
        make.height.mas_offset(80);
        make.top.equalTo(weakSelf);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.headImg.mas_bottom).with.offset(10);
        make.height.mas_offset(15);
    }];
    [weakSelf.mikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.charmView.mas_bottom).with.offset(12);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(100);
        make.height.mas_offset(28);
    }];
    [weakSelf.certificationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLab);
        make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(6);
        make.width.mas_offset(17);
        make.height.mas_offset(12);
    }];
    [weakSelf.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLab);
        make.left.equalTo(weakSelf.certificationImg.mas_right).with.offset(6);
        make.width.mas_offset(6);
        make.height.mas_offset(6);
    }];
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

-(UIImageView *)headImg
{
    if(!_headImg)
    {
        _headImg = [[UIImageView alloc] init];
        _headImg.backgroundColor = [UIColor whiteColor];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 40;
    }
    return _headImg;
}
-(UIButton *)infoBtn
{
    if(!_infoBtn)
    {
        _infoBtn = [[UIButton alloc] init];
        
    }
    return _infoBtn;
}
-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = TextCOLOR;
        _nameLab.font = [UIFont systemFontOfSize:14];
    }
    return _nameLab;
}

-(UIImageView *)certificationImg
{
    if(!_certificationImg)
    {
        _certificationImg = [[UIImageView alloc] init];
        _certificationImg.image = [UIImage imageNamed:@"认证"];
    }
    return _certificationImg;
}

-(UIView *)lineView
{
    if(!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor greenColor];
        _lineView.layer.masksToBounds = YES;
        _lineView.layer.cornerRadius = 3;
    }
    return _lineView;
}

-(ageView *)ageLab
{
    if(!_ageLab)
    {
        _ageLab = [[ageView alloc] init];
        _ageLab.ageLab.font = [UIFont systemFontOfSize:10];
        _ageLab.ageLab.textColor = [UIColor whiteColor];
        _ageLab.ageLab.textAlignment = NSTextAlignmentCenter;
        _ageLab.layer.masksToBounds = YES;
        _ageLab.layer.cornerRadius = 2;
    }
    return _ageLab;
}

-(UILabel *)sexView
{
    if(!_sexView)
    {
        _sexView = [[UILabel alloc] init];
        _sexView.layer.masksToBounds = YES;
        _sexView.layer.cornerRadius = 2;
        _sexView.font = [UIFont systemFontOfSize:10];
        _sexView.textColor = [UIColor whiteColor];
        _sexView.textAlignment = NSTextAlignmentCenter;
    }
    return _sexView;
}

-(wealthView *)wealView
{
    if(!_wealView)
    {
        _wealView = [[wealthView alloc] init];
        _wealView.numberLab.font = [UIFont systemFontOfSize:9];
        _wealView.numberLab.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
        _wealView.layer.masksToBounds = YES;
        _wealView.layer.borderWidth = 0.8;
        _wealView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
        _wealView.layer.cornerRadius = 2;
    }
    return _wealView;
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


-(UIButton *)mikeBtn
{
    if(!_mikeBtn)
    {
        _mikeBtn = [[UIButton alloc] init];
        [_mikeBtn setTitle:@"上麦" forState:normal];
        _mikeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_mikeBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _mikeBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(100, 34) direction:IHGradientChangeDirectionUpwardDiagonalLine startColor:[UIColor colorWithHexString:@"#FC83F5" alpha:1] endColor:[UIColor colorWithHexString:@"#DB5DE2" alpha:1]];
        _mikeBtn.layer.masksToBounds = YES;
        _mikeBtn.layer.cornerRadius = 14;
        
    }
    return _mikeBtn;
}


-(CGFloat)clwidth:(NSString*)string
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 9) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

@end
