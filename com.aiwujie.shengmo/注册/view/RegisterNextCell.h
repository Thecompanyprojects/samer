//
//  RegisterNextCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterNextCellDelegate <NSObject>

-(void)buttonClickOnCell:(UIButton *)button;

-(void)buttonClickOnCell:(UIButton *)button changeSelection:(NSMutableArray *)selectionArray;

@end

@interface RegisterNextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (nonatomic,weak) id<RegisterNextCellDelegate>delegate;

-(void)addoptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andSelectionArray:(NSMutableArray *)selectionArray;

-(void)editAddoptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andOtherArray:(NSMutableArray *)otherArray andSelectionArray:(NSMutableArray *)selectionArray;

@end
