//
//  ApplyMatchmakerCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyMatchmakerCell : UITableViewCell

-(void)cellwithDic:(NSDictionary *)dic;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIButton *mobileButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIView *picBackView;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

//显示红娘的名称
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

//提示按钮的改变
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editPicTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editPicWarnH;

//红娘的推荐编辑按钮
@property (weak, nonatomic) IBOutlet UIView *introduceView;
@property (weak, nonatomic) IBOutlet UIImageView *noIntrouceView;
@property (weak, nonatomic) IBOutlet UILabel *noIntroduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommendEditButton;

//展开介绍的编辑按钮
@property (weak, nonatomic) IBOutlet UITextView *matchObListTextView;
@property (weak, nonatomic) IBOutlet UIButton *matchObListEditButton;
@property (weak, nonatomic) IBOutlet UIView *matchObListView;
@property (weak, nonatomic) IBOutlet UIImageView *noMatchObListView;
@property (weak, nonatomic) IBOutlet UILabel *noMatchObListLabel;
@property (weak, nonatomic) IBOutlet UIView *matchObListLineView;

//step3头视图
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerCerView;
@property (weak, nonatomic) IBOutlet UILabel *headerServiceTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;

//提示上传图片的label
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

//城市的view
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityW;
@end
