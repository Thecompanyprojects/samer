//
//  DynamicCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "DynamicCell.h"
#import "LDOwnInformationViewController.h"
#import "UIImage+Cut.h"
#import "NSString+QT.h"

@interface DynamicCell()<SMLabelDelegate>
@property (nonatomic,strong) NSArray *atnameArray;
@property (nonatomic,strong) NSArray *atuidArray;
@property (nonatomic,copy)   NSString *touid;
@end

@implementation DynamicCell

-(void)setModel:(DynamicModel *)model{
    
    _model = model;
    
    if (self.isauditMark&&[model.auditMark intValue]==1) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"c450d6" alpha:0.2];
        self.bottom.backgroundColor = [UIColor colorWithHexString:@"c450d6" alpha:0.2];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.bottom.backgroundColor = [UIColor whiteColor];
    }
    
    self.atnameArray = [NSMutableArray array];
    self.atuidArray = [NSMutableArray array];
    
    self.atnameArray = [model.atuname componentsSeparatedByString:@","];
    self.atuidArray = [model.atuid componentsSeparatedByString:@","];
    
    for (UIView *view in self.picView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] && view.frame.origin.y > self.headButton.frame.origin.y && view.frame.origin.y < self.picView.frame.origin.y) {
            [view removeFromSuperview];
        }
    }
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLabel.text = model.nickname;
    [self.nameLabel sizeToFit];
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
    
    if (model.stickstate.length != 0) {
        if ([model.uid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            if ([model.stickstate intValue] == 1) {
                self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                self.recommendView.hidden = NO;
            }else if([model.is_hidden intValue] == 1){
                self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
                self.recommendView.hidden = NO;
            }else if([model.recommend intValue] != 0){
                self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                self.recommendView.hidden = NO;
            }else{
                self.recommendView.hidden = YES;
            }
        }else{
            if([model.is_hidden intValue] == 1){
                self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
                self.recommendView.hidden = NO;
            }else{
                if([model.recommend intValue] != 0){
                    self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                    self.recommendView.hidden = NO;
                }else{
                    self.recommendView.hidden = YES;
                }
            }
        }
        if ([model.recommend intValue] == 0) {
            self.scanLabel.text = @"";
            self.distanceY.constant = 20;
        }else{

            NSString *readtimes = [NSString stringWithFormat:@"%@",model.readtimes];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"浏览 ",readtimes]];
            if ([readtimes intValue]>=10000) {
                [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,3)];
                [noteStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,readtimes.length)];
                
            }
            else
            {
                [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,readtimes.length+3)];
            }
            self.scanLabel.attributedText = noteStr;
            
            self.distanceY.constant = 38;
        }
    }else{
        if([model.is_hidden intValue] == 1){
            self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
            self.recommendView.hidden = NO;
            if ([model.recommend intValue] == 0) {
                self.scanLabel.text = @"";
                self.distanceY.constant = 20;
            }else{

                NSString *readtimes = [NSString stringWithFormat:@"%@",model.readtimes];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"浏览 ",readtimes]];
                if ([readtimes intValue]>=10000) {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,3)];
                    [noteStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,readtimes.length)];
                    
                }
                else
                {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,readtimes.length+3)];
                }
                self.scanLabel.attributedText = noteStr;
                self.distanceY.constant = 38;
            }
        }else{
            if ([model.recommend intValue] == 0) {
                self.recommendView.hidden = YES;
                self.scanLabel.text = @"";
                self.distanceY.constant = 20;
            }else{

                NSString *readtimes = [NSString stringWithFormat:@"%@",model.readtimes];
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@"浏览 ",readtimes]];
                if ([readtimes intValue]>=10000) {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,3)];
                    [noteStr addAttribute:NSForegroundColorAttributeName value:MYORANGE range:NSMakeRange(3,readtimes.length)];
                    
                }
                else
                {
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"555555" alpha:1] range:NSMakeRange(0,readtimes.length+3)];
                }
                self.scanLabel.attributedText = noteStr;
                self.distanceY.constant = 38;
                self.recommendView.hidden = NO;
                if (model.recommendall.length != 0) {
                    if ([model.recommendall intValue] > 0) {
                        self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                    }else{
                        self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                    }
                }else{
                    self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                }
            }
        }
    }
    
    if ([model.is_hand intValue] == 1) {
        
        self.handleView.hidden = NO;
        
    }else{
    
        self.handleView.hidden = YES;
    }
    
    if ([model.onlinestate intValue] == 1) {
        
        self.onlineLabel.hidden = NO;
        
    }else{
    
        self.onlineLabel.hidden = YES;
    }
    if ([model.realname intValue] == 1) {
        self.idView.hidden = NO;
        self.idViewW.constant = 17;
    }else{
        self.idView.hidden = YES;
        self.idViewW.constant = 0;
    }
    if (self.integer == 2001){
        if (model.commenttime.length != 0) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%@回复",model.addtime];
        }else{
            self.distanceLabel.text = [NSString stringWithFormat:@"%@",model.addtime];
        }
    }else{
        if (model.commenttime.length != 0) {
            if ([model.location_switch intValue]==1) {
                self.distanceLabel.text = [NSString stringWithFormat:@"%@ %@回复",@"隐身",model.addtime];
            }else
            {
                self.distanceLabel.text = [NSString stringWithFormat:@"%@km %@回复",model.distance,model.addtime];
            }
            
        }else{
            if ([model.location_switch intValue]==1) {
                self.distanceLabel.text = [NSString stringWithFormat:@"%@ %@",@"隐身",model.addtime];
            }
            else
            {
                self.distanceLabel.text = [NSString stringWithFormat:@"%@km %@",model.distance,model.addtime];
            }
        }
    }
    
    NSString *content;
    self.commentLabel.font = [UIFont systemFontOfSize:16];
    if (model.topictitle.length == 0) {
        content = model.content;
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [self setAttributedString:content andIsHaveTopic:NO];
    }else{
        content = [NSString stringWithFormat:@"#%@# %@",model.topictitle,model.content];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [self setAttributedString:content andIsHaveTopic:YES];
        
    }
    self.commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (content.length==0) {
        self.commentTopH.constant = 0;
        self.commentH.constant = 0;
    }
    else
    {
        if (![content isMoreThanOneLineWithSize:CGSizeMake(WIDTH-16, MAXFLOAT) font:[UIFont systemFontOfSize:16] lineSpaceing:6]) {
            self.commentLabel.linespace = 0;
            self.commentTopH.constant = 18;
            self.commentH.constant = 20;
        }
        else
        {
            self.commentLabel.linespace = 6;
            CGFloat boundingRectHeight = [content boundingRectWithSize:CGSizeMake(WIDTH-16, MAXFLOAT) font:[UIFont systemFontOfSize:16] lineSpacing:6].height;
            self.commentH.constant = boundingRectHeight;
            self.commentTopH.constant = 18;
            
            if (boundingRectHeight == 0) {
                self.commentH.constant = 0;
                self.commentTopH.constant = 0;
            }
            else{
                if (boundingRectHeight>=16*6+8*5) {
                    self.commentTopH.constant = 18;
                    self.commentH.constant = 16*6+8*5;
                }
                else
                {
                    self.commentTopH.constant = 18;
                    self.commentH.constant = boundingRectHeight;
                }
            }
        }
    }
    
    self.zanLabel.text = [NSString stringWithFormat:@"%@",model.laudnum];
    [self.bottom.zanBtn setTitle:[NSString stringWithFormat:@"%@",model.laudnum] forState:normal];
    if ([model.laudnum intValue]>=100) {
        [self.bottom.zanBtn setTitleColor:MYORANGE forState:normal];
    }
    else
    {
        [self.bottom.zanBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
    }
    
    if (model.pic.count != 0) {
        if (model.content.length==0) {
            self.picTopH.constant = 16;
        }
        else
        {
            self.picTopH.constant = 12;
        }
        if (_model.pic.count == 1) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.pic[0]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            imageV.userInteractionEnabled = YES;
            imageV.tag = self.indexPath.section * 100;
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            self.picH.constant = 240;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageV addGestureRecognizer:tap];
            [_picView addSubview:imageV];
        }else if (_model.pic.count > 1){
            
            CGFloat imageH = (WIDTH - 24 - 8)/3;
            
            for (int i = 0; i < _model.pic.count; i++) {
                
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * imageH + i%3 * 4, i/3 * imageH + i/3 * 4, imageH, imageH)];
                [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.pic[i]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                imageV.clipsToBounds = YES;
                imageV.userInteractionEnabled = YES;
                imageV.tag = self.indexPath.section * 100 + i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                [imageV addGestureRecognizer:tap];
                [_picView addSubview:imageV];

            }
            
            if (_model.pic.count <= 3 && _model.pic.count > 1) {
                
                self.picH.constant = imageH;
                
            }else if(_model.pic.count > 3 && _model.pic.count <= 6){
                
                self.picH.constant = 2 * imageH + 4;
                
            }else{
                
                self.picH.constant = 3 * imageH + 8;
            }
            
        }
        
    }else{
        self.picH.constant = 0;
        self.picTopH.constant = 0;
    }
    if ([model.laudstate intValue] == 0) {
        self.zanImageView.image = [UIImage imageNamed:@"赞灰"];
        [self.bottom.zanBtn setImage:[UIImage imageNamed:@"赞灰"] forState:normal];
    }else{
        self.zanImageView.image = [UIImage imageNamed:@"赞紫"];
        [self.bottom.zanBtn setImage:[UIImage imageNamed:@"赞紫"] forState:normal];
    }
    if ([_model.role isEqualToString:@"S"]) {
        self.sexualLabel.text = @"斯";
        self.sexualLabel.backgroundColor = BOYCOLOR;
    }else if ([_model.role isEqualToString:@"M"]){
        self.sexualLabel.text = @"慕";
        self.sexualLabel.backgroundColor = GIRLECOLOR;
    }else if ([_model.role isEqualToString:@"SM"]){
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
    self.contentLabel.text = [NSString stringWithFormat:@"%@",_model.comnum];
    [self.bottom.commentBtn setTitle:[NSString stringWithFormat:@"%@",_model.comnum] forState:normal];
    if ([_model.comnum intValue]>=100) {
        [self.bottom.commentBtn setTitleColor:MYORANGE forState:normal];
    }
    else
    {
        [self.bottom.commentBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
    }
    self.rewardLabel.text = [NSString stringWithFormat:@"%@",_model.rewardnum];
    [self.bottom.replyBtn setTitle:[NSString stringWithFormat:@"%@",_model.rewardnum] forState:normal];
    if ([_model.rewardnum intValue]>=10000) {
        [self.bottom.replyBtn setTitleColor:MYORANGE forState:normal];
    }
    else
    {
        [self.bottom.replyBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
    }
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andNSLayoutConstraint:_wealthW andType:@"财富"];
    [self getWealthAndCharmState:_charmLabel andView:_charmView andNSLayoutConstraint:_charmW andType:@"魅力"];

    if ([model.alltopnums intValue]==0) {
        [self.bottom.topBtn setTitle:model.alltopnums?:@"0" forState:normal];
    }else
    {
        if ([model.usetopnums intValue]==[model.alltopnums intValue]) {
            [self.bottom.topBtn setTitle:model.alltopnums?:@"0" forState:normal];
        }
        else
        {
            [self.bottom.topBtn setTitle:[NSString stringWithFormat:@"%@%@%@",model.usetopnums,@"/",model.alltopnums] forState:normal];
        }
    }
    if ([model.alltopnums intValue]>=100) {
        [self.bottom.topBtn setTitleColor:MYORANGE forState:normal];
    }
    else
    {
        [self.bottom.topBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA" alpha:1] forState:normal];
    }
}

/**
 * 富文本文字设置
 */
-(void)setAttributedString:(NSString *)content andIsHaveTopic:(BOOL)haveTopic{
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    if (haveTopic) {
        CGSize size = [[NSString stringWithFormat:@"#%@#",_model.topictitle] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.commentLabel.frame.origin.x, self.commentLabel.frame.origin.y, size.width, size.height)];
        [button addTarget:self action:@selector(topicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    self.commentLabel.attributedText = attributedString;
}

// 检索文本的正则表达式的字符串
-(NSString * _Nonnull)sm_regexStringHyperlinkOfLabel:(SMLabel * _Nonnull)label {
    NSString *regex3 = @"#\\S+# ";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)",kATRegular,regex3];
    return regex;
}

-(void)sm_label:(SMLabel * _Nonnull)label didTouche:(UITouch * _Nonnull)touche
{
    [self labeltouchup];
}

-(void)sm_label:(SMLabel * _Nonnull)label didToucheHyperlinkText:(NSString * _Nonnull)text
{
    NSLog(@"text---%@",text);
    if (self.model.atuname.length!=0) {
        if (self.model.topictitle.length!=0) {
            if ([self.atnameArray containsObject:text]) {
                int index = (int)[self.atnameArray indexOfObject:text];
                NSString *useridstr = [self.atuidArray objectAtIndex:index];
                [self.delegate touserinfovc:useridstr];
            }
            else
            {
                [AlertTool alertWithViewController:[self getCurrentVC] andTitle:@"提示" andMessage:@"无此人"];
            }
        }
        else
        {
            if ([self.atnameArray containsObject:text]) {
                NSInteger indexs = [self.atnameArray indexOfObject:text];
                NSString *useridstr = [self.atuidArray objectAtIndex:indexs];
                [self.delegate touserinfovc:useridstr];
            }
            else
            {
                [AlertTool alertWithViewController:[self getCurrentVC] andTitle:@"提示" andMessage:@"无此人"];
            }
        }
    }
    else
    {
        [AlertTool alertWithViewController:[self getCurrentVC] andTitle:@"提示" andMessage:@"无此人"];
    }
}

- (UIColor * _Nonnull)sm_menuControllerDidShowColorOfLabel:(SMLabel * _Nonnull)label;
{
    return [UIColor clearColor];
}

// 设置当前链接文本的颜色
- (UIColor * _Nonnull)sm_linkColorOfLabel:(SMLabel * _Nonnull)label {
    return MainColor;
}

- (UIColor * _Nonnull)sm_passColorOfLabel:(SMLabel * _Nonnull)label
{
    return [UIColor lightGrayColor];
}

/**
 * 获取并创建财富榜和魅力榜
 */
-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    if ([type isEqualToString:@"财富"]) {
        if ([_model.wealth_val intValue] == 0) {
            self.wealthSpace.constant = 0;
            backView.hidden = YES;
            constraint.constant = 0;
        }else{
            self.wealthSpace.constant = 5;
            backView.hidden = NO;
            label.text = [NSString stringWithFormat:@"%@",_model.wealth_val];
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }else{
        if ([_model.charm_val intValue] == 0) {
            backView.hidden = YES;
        }else{
            backView.hidden = NO;
            label.text = [NSString stringWithFormat:@"%@",_model.charm_val];
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

/**
 * 文字自适应宽度
 */
-(CGSize)fitLabelWidth:(NSString *)string{
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return labelSize;
}

#pragma 点击图片调用代理方法
-(void)tap:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tap:)]) {
         [_delegate tap:tap];
    }
}

#pragma 点击话题调用代理方法
-(void)topicButtonClick{
    if (_model.topictitle.length != 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(transmitClickModel:)]) {
            [self.delegate transmitClickModel:_model];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    
    self.headView.layer.cornerRadius = 20;
    self.headView.clipsToBounds = YES;

    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.bottom = [bottomView new];
    self.bottom.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview: self.bottom];
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_offset(42);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    [self.bottom.zanBtn addTarget:self action:@selector(zanbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom.commentBtn addTarget:self action:@selector(commentbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom.replyBtn addTarget:self action:@selector(replybtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom.topBtn addTarget:self action:@selector(topbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.commentLabel.delegate = self;
    
    self.commentButton.hidden = YES;
    self.rewardButton.hidden = YES;
    self.zanImageView.hidden = YES;
    self.zanImageView.hidden = YES;
    self.contentLabel.hidden = YES;
    self.rewardLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - delegate

-(void)zanbtnClick
{
    [self.delegate zanTabVClick:self];
}

-(void)commentbtnClick
{
    [self.delegate commentTabVClick:self];
}

-(void)replybtnClick
{
    [self.delegate replyTabVClick:self];
}

-(void)topbtnClick
{
    [self.delegate topTabVClick:self];
}

-(void)labeltouchup
{
    if (self.delegate) {
        [self.delegate labeltouchup:self];
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
