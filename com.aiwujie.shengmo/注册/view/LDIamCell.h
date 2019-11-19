//
//  LDIamCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDIamCellDelegate <NSObject>

@optional

-(void)buttonClickOnCell:(UIButton *)button;

-(BOOL)buttonClickTextView:(UITextView *)textView andText:(NSString *)text;

-(void)buttonClickOnCell:(UIButton *)button changeSelection:(NSMutableArray *)selectionArray;

-(void)sendText:(UITextView *)textView;

@end

@interface LDIamCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray *array;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (nonatomic,weak) id<LDIamCellDelegate>delegate;


-(void)addoptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andOtherArray:(NSMutableArray *)otherArray andSelectionArray:(NSMutableArray *)selectionArray;

-(void)editOptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andOtherArray:(NSMutableArray *)otherArray andSelectionArray:(NSMutableArray *)selectionArray;

-(void)textViewText:(NSMutableArray *)array;

@end
