//
//  CommentCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()<SMLabelDelegate>
@property (nonatomic,strong) NSArray *atnameArray;
@property (nonatomic,strong) NSArray *atuidArray;
@end

@implementation CommentCell

-(void)setModel:(commentModel *)model{

    _model = model;
   
    self.atnameArray = [NSArray array];
    self.atuidArray = [NSArray array];
    
    self.atnameArray = [model.atuname componentsSeparatedByString:@","];
    self.atuidArray = [model.atuid componentsSeparatedByString:@","];

    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLabel.text = model.nickname;
    self.timeLabel.text = model.sendtime;
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

    if ([model.is_hand intValue] == 1) {
        self.handleView.hidden = NO;
    }else{
        self.handleView.hidden = YES;
    }
    
    if ([model.otheruid intValue] == 0) {
        model.content = [model.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        self.contentLabel.text = model.content;
        NSMutableAttributedString *attributedString = [self.contentLabel.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
        self.contentLabel.attributedText = attributedString;
        
    }else{
        model.content = [model.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复 %@: %@",model.othernickname,model.content]];
        [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(3,[model.othernickname length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        self.contentLabel.attributedText = str;
    }
    self.contentLabel.linespace = 6;
    self.contentLabel.delegate = self;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(WIDTH - 84, 0)];
    self.contentH.constant = size.height;
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 65 + self.contentH.constant);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = 29;
    self.headView.clipsToBounds = YES;
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

// 检索文本的正则表达式的字符串
-(NSString * _Nonnull)sm_regexStringHyperlinkOfLabel:(SMLabel * _Nonnull)label {
    NSString *regex3 = @" \\S+:";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)",kATRegular,regex3];
    return regex;
}

-(void)sm_label:(SMLabel * _Nonnull)label didTouche:(UITouch * _Nonnull)touche
{
    //[self labeltouchup];
}

- (void)sm_label:(SMLabel * _Nonnull)label willToucheHyperlinkText:(NSString * _Nonnull)text
{
    NSLog(@"text---%@",text);
    if ([self.model.otheruid intValue]!=0) {
        [self.delegate touserinfovc:self.model.otheruid];
        return;
    }
    if (self.model.atuname.length!=0) {
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
    else
    {
        [AlertTool alertWithViewController:[self getCurrentVC] andTitle:@"提示" andMessage:@"无此人"];
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

-(void)sm_label:(SMLabel * _Nonnull)label didToucheHyperlinkText:(NSString * _Nonnull)text
{
    NSLog(@"text---%@",text);
//    if (self.model.atuname.length!=0) {
//        if ([self.atnameArray containsObject:text]) {
//            NSInteger indexs = [self.atnameArray indexOfObject:text];
//            NSString *useridstr = [self.atuidArray objectAtIndex:indexs];
//            [self.delegate touserinfovc:useridstr];
//        }
//    }
}

// 长按显示UIMenuController视图
- (NSMutableArray<UIMenuItem *> * _Nonnull)sm_menuItemsOfLabel:(SMLabel * _Nonnull)label {
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")];
    [menuItems addObject:copyItem];
    return menuItems;
}

// 点击UIMenuItem的点击事件
- (void)sm_label:(SMLabel * _Nonnull)label menuItemsAction:(SEL _Nonnull)action sender:(id _Nonnull)sender {
    if (action == NSSelectorFromString(@"copyText:")) {
        NSLog(@"复制%@",sender);
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
    return MainColor;
}

- (IBAction)headButton:(id)sender {
    
}

@end
