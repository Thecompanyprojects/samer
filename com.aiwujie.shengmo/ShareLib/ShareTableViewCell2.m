//
//  ShareTableViewCell2.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/29.
//  Copyright © 2019 a. All rights reserved.
//

#import "ShareTableViewCell2.h"

#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation ShareTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    //分享到
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"分享到站外";
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TextCOLOR;
    titleLabel.frame = CGRectMake(20, 6, SCREENWIDTH-20, 30);
    [self addSubview:titleLabel];


    NSArray *contentArray = @[
                              @{@"name":@"微博",@"icon":@"微博1"},
                              @{@"name":@"微信好友",@"icon":@"微信1"},
                              @{@"name":@"朋友圈",@"icon":@"朋友圈1"},
                              @{@"name":@"QQ好友",@"icon":@"qq1"},
                              @{@"name":@"QQ空间",@"icon":@"qq空间1"}
                              ];
    
    CGFloat btnW = 60;
    CGFloat btnH = 60;
    
    for (int i = 0; i < 5; i++)
    {
        
        NSDictionary *dic = [contentArray objectAtIndex:i];
        NSString *name = dic[@"name"];
        NSString *icon = dic[@"icon"];
        YSActionSheetButton *btn = [YSActionSheetButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i;
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        
        
        CGFloat marginX = (SCREENWIDTH-20 - 5 * btnW) / (5 + 1);
        int col = i % 5;
        
        CGFloat btnX = marginX + (marginX + btnW) * col;
        

        btn.frame = CGRectMake(btnX, 45, btnW, btnH);
        
        btn.transform = CGAffineTransformMakeTranslation(0, 100);
        
        switch (i) {
            case 0:
            {
                self.shareBtn1=btn;
                
            }
                break;
            case 1:
            {
                
                self.shareBtn2=btn;
            }
                break;
            case 2:
            {
                self.shareBtn3=btn;
            }
                break;
            case 3:
            {
                self.shareBtn4=btn;
            }
                break;
            case 4:
            {
                self.shareBtn5=btn;
            }
                break;
            default:
                break;
        }
        
        [self addSubview:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
