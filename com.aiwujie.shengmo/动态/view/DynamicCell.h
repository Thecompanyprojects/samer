//
//  DynamicCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"
#import "bottomView.h"


@protocol DynamicDelegate <NSObject,UITextViewDelegate>

@optional

-(void)tap:(UITapGestureRecognizer *)tap;

-(void)transmitClickModel:(DynamicModel *)model;

-(void)zanTabVClick:(UITableViewCell *)cell;
-(void)commentTabVClick:(UITableViewCell *)cell;
-(void)replyTabVClick:(UITableViewCell *)cell;
-(void)topTabVClick:(UITableViewCell *)cell;

-(void)labeltouchup:(UITableViewCell *)cell;

-(void)touserinfovc:(NSString *)userId;
@end

@interface DynamicCell : UITableViewCell<YBAttributeTapActionDelegate>

@property (nonatomic,strong) bottomView *bottom;
@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,weak) id <DynamicDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *handleView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIImageView *idView;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceY;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

//内容的高度
@property (weak, nonatomic) IBOutlet SMLabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentH;

//图片的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopH;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewW;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *recommendView;
@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;

@property (nonatomic,assign) BOOL isauditMark;
@end
