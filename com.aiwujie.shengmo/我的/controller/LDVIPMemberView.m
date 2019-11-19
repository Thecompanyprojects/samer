//
//  LDVIPMemberView.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/11/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDVIPMemberView.h"

@implementation LDVIPMemberView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(instancetype)initWithVIPtype:(NSString *)type{
    
    if (self = [super init]) {
        
        [self setUpUI:type];
    }
    
    return self;
}

-(void)setUpUI:(NSString *)type{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5" alpha:1];
    [self addSubview:sectionView];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, (CGRectGetHeight(sectionView.frame) - 30)/2, WIDTH - 28, 30)];
    sectionLabel.font = [UIFont systemFontOfSize:15];
    [sectionView addSubview:sectionLabel];
    
//    UILabel *newLab = [UILabel new];
//    newLab.text = @"new";
//    newLab.font = [UIFont italicSystemFontOfSize:13];//设置字体为斜体
//    newLab.textColor = [UIColor redColor];
//    [sectionView addSubview:newLab];
    
    UIView *privilegeView = [[UIView alloc] init];
    [self addSubview:privilegeView];
    
    NSArray *array;
    
    if ([type intValue] == 0) {
//        newLab.frame = CGRectMake(WIDTH-280*W_SCREEN+10,13, 30, 13);
        sectionLabel.text = @"VIP会员特权";
        
        array = @[@"[专属]-尊贵V标识身份",@"[专属]-可备注所有人昵称",@"[专属]-可看到Ta的最后登陆时间",@"[专属]-可查看所有人相册、动态、评论",@"[专属]-可使用地图找人特权，穿越地球去找你",@"[专属]-可使用高级搜索功能",@"[专属]-可出现在附近-推荐中（年会员更靠前)",@"[专属]-可访问身边隐身者的个人主页",@"[专属]-每月可修改3次昵称",@"[专属]-聊天对话页显示紫色昵称",@"[专属]-可使用相册的加密功能，照片由6张升级为15张",@"[专属]-个人主页语音介绍由10秒增至30秒",@"[专属]-可在个人主页置顶一篇动态",@"[专属]-每日关注人数不受限制"];
        
    }else{
//        newLab.frame = CGRectMake(WIDTH-270*W_SCREEN+10,13, 30, 13);
        sectionLabel.text = @"SVIP会员特权";
        
        array = @[@"[专属]-包含普通VIP会员所有特权",@"[专属]-发消息无需邮票，无限畅聊",@"[专属]-可设置所有人无需邮票直接给我发消息",@"[专属]-年费SVIP将在“身边”推顶一个月",@"[专属]-可查看所有人历史昵称",@"[专属]-可对所有人进行“分组”",@"[专属]-可对所有人进行“详细描述”",@"[专属]-修改昵称不限次数",@"[专属]-签名由256字升级为500字",@"[专属]-发布的动态将自动被推荐",@"[专属]-聊天对话页显示红色昵称",@"[专属]-可编辑已发布动态",@"[专属]-可使用悄悄关注",@"[专属]-各列表排名最前",@"[专属]-豪华金V标识"];
    }
    
    CGFloat lineSpace = 6;
    
    CGFloat wordFont;
    
    if (WIDTH == 320) {
        
        wordFont = 12;
        
    }else{
        
        wordFont = 13;
    }
    
    for (int i = 0; i < array.count; i++) {
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 15 * i + lineSpace * i, 20, 15)];
        numLabel.text = [NSString stringWithFormat:@"%d.",i + 1];
        numLabel.font = [UIFont systemFontOfSize:wordFont];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [privilegeView addSubview:numLabel];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:wordFont];
        [label sizeToFit];
        label.frame = CGRectMake(CGRectGetMaxX(numLabel.frame), 10 + 15 * i + lineSpace * i, CGRectGetWidth(label.frame), 15);
        [privilegeView addSubview:label];
        
        if ([type intValue] != 0) {
            
            if (i==4||i==3||i==5||i==6||i==8) {
                
                UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 5, CGRectGetMinY(label.frame), 50, 15)];
                newLabel.text = @"new";
                newLabel.font = [UIFont italicSystemFontOfSize:wordFont];//设置字体为斜体
                newLabel.textColor = [UIColor redColor];
                [privilegeView addSubview:newLabel];
                
            }
        }
        if ([type intValue]==0) {
            if (i == 1||i==7) {
                
                UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 5, CGRectGetMinY(label.frame), 50, 15)];
                newLabel.text = @"new";
                newLabel.font = [UIFont italicSystemFontOfSize:wordFont];//设置字体为斜体
                newLabel.textColor = [UIColor redColor];
                [privilegeView addSubview:newLabel];
            }
        }

        //更改[专属]的颜色
        [self changeWordColorTitle:label.text andTitleColor:MainColor  andLoc:0 andLen:4 andLabel:label];
        
        if (i == array.count - 1) {
                
            privilegeView.frame = CGRectMake(0, CGRectGetMaxY(sectionView.frame), WIDTH, CGRectGetMaxY(label.frame));
        }
    }
    
    if ([type intValue] == 0) {
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(privilegeView.frame) + 30, WIDTH - 20, 15)];
        
    }else{
        
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, lineSpace + CGRectGetMaxY(privilegeView.frame), WIDTH - 24, 0)];
        warnLabel.text = @"升级无忧:已是VIP会员的用户,开通SVIP会员后VIP会暂停计时,待SVIP到期后VIP恢复计时,从而不给您造成任何损失,让您无后顾之忧!";
        warnLabel.font = [UIFont systemFontOfSize:wordFont];
        //更改升级无忧颜色
        [self changeWordColorTitle:warnLabel.text andTitleColor:MainColor andLoc:0 andLen:5 andLabel:warnLabel];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:warnLabel.text];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0,5)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(5,warnLabel.text.length - 5)];
        warnLabel.attributedText = attributedStr;
        
        warnLabel.numberOfLines = 0;
        [warnLabel sizeToFit];
        warnLabel.frame = CGRectMake(12, lineSpace + CGRectGetMaxY(privilegeView.frame) + 10, WIDTH - 24, warnLabel.frame.size.height);
        [self addSubview:warnLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(warnLabel.frame) + 30, WIDTH - 20, 15)];
    }

    if ([type intValue] == 0){
        
        _moneyLabel.text = @"金额 30 元";
        
        //更改钱数的颜色
        [self changeWordColorTitle:_moneyLabel.text andTitleColor:MainColor  andLoc:3 andLen:2 andLabel:_moneyLabel];
        
    }else{
        
        _moneyLabel.text = @"金额 128 元";
        
        //更改钱数的颜色
        [self changeWordColorTitle:_moneyLabel.text andTitleColor:MainColor  andLoc:3 andLen:3 andLabel:_moneyLabel];
    }
    
    _moneyLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_moneyLabel];
    
    UILabel *protcolLabel = [[UILabel alloc] init];
    protcolLabel.font = [UIFont systemFontOfSize:13];
    protcolLabel.text = @"成为会员即表示已阅读并同意 圣魔会员协议";
    protcolLabel.userInteractionEnabled = YES;
    [protcolLabel sizeToFit];
    protcolLabel.frame = CGRectMake(15, CGRectGetMaxY(_moneyLabel.frame) + 10, CGRectGetWidth(protcolLabel.frame), 15);
    protcolLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:protcolLabel];
    
    [self changeWordColorTitle:protcolLabel.text andTitleColor:MainColor andLoc:protcolLabel.text.length - 6 andLen:6 andLabel:protcolLabel];
    
    UIButton *protcolButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(protcolLabel.frame) - 150, 0, 150, 15)];
    [protcolButton addTarget:self action:@selector(protcolButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [protcolLabel addSubview:protcolButton];
    
    self.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(protcolLabel.frame) + 10);
}

-(void)protcolButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(vipMemberProtcolDidSelect)]) {
        
        [self.delegate vipMemberProtcolDidSelect];
    }
}

//更改某个字体的颜色
-(void)changeWordColorTitle:(NSString *)str andTitleColor:(UIColor *)color andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}

@end
