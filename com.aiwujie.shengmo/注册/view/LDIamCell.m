//
//  LDIamCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDIamCell.h"

@interface LDIamCell ()
@property (nonatomic,strong) NSMutableArray * selectionArray;
@property (nonatomic,strong) NSIndexPath * selectionIndexPath;
@end

@implementation LDIamCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.introduceLabel sizeToFit];
    
    self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
  }

-(void)textViewText:(NSMutableArray *)array{
    
    if ([array[array.count - 1] length] != 0) {
        
        self.textView.text = array[array.count - 1];
        
        self.introduceLabel.hidden = YES;
    }
}

-(void)addoptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andOtherArray:(NSMutableArray *)otherArray andSelectionArray:(NSMutableArray *)selectionArray{
    
    if (indexPath.section == 2 || indexPath.section == 3) {
        
        _selectionArray = [NSMutableArray array];
        
        _selectionArray = selectionArray;
        
        _selectionIndexPath = indexPath;
        
        for (int i = 0; i < array.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + i%3 * (WIDTH - 60)/3 + i%3 * 5, 13 + i/3 * 25 + i/3 * 15, (WIDTH - 60)/3, 30)];
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
            button.layer.cornerRadius = 15;
            button.clipsToBounds = YES;
            
            if ([selectionArray[i] isEqualToString:@"yes"]) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
            }else{
                
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 1;
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.tag = 100 * indexPath.section + i;
            
            [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            
        }

        
    }else{
    
        for (int i = 0; i < array.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + i%3 * (WIDTH - 60)/3 + i%3 * 5, 14 + i/3 * 25 + i/3 * 15, (WIDTH - 60)/3, 30)];
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
            button.layer.cornerRadius = 15;
            button.clipsToBounds = YES;
            
            if ([array[i] isEqualToString:otherArray[indexPath.section]]) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:otherArray[indexPath.section] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
            }else{
                
                button.layer.borderWidth = 1;
                
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
            }

            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.tag = 100 * indexPath.section + i;
            
            [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];

        }
   }
}

-(void)ButtonClick:(UIButton *)button{
    
    if (_selectionIndexPath.section == 2 || _selectionIndexPath.section == 3) {
        
        if([_selectionArray[button.tag - _selectionIndexPath.section *100] isEqualToString:@"no"]){
            
            [_selectionArray replaceObjectAtIndex:button.tag - 100 * _selectionIndexPath.section withObject:@"yes"];
            
        }else{
            
            [_selectionArray replaceObjectAtIndex:button.tag - 100 * _selectionIndexPath.section withObject:@"no"];
        }

        
        [self.delegate buttonClickOnCell:button changeSelection:_selectionArray];
    }else{
    
        [self.delegate buttonClickOnCell:button];
    }
   
}

#pragma mark  textView的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.textView.text.length == 0) {
        
        [self.introduceLabel setHidden:NO];
        
    }else{
        
        [self.introduceLabel setHidden:YES];
    
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if(textView.text.length >= 256){
            
            textView.text = [textView.text substringToIndex:256];
            
            [textView endEditing:YES];
            
        }
        
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
   return  [self.delegate buttonClickTextView:textView andText:text];

}

- (void)textViewDidEndEditing:(UITextView *)textView{

    [self.delegate sendText:textView];
}

-(void)editOptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andOtherArray:(NSMutableArray *)otherArray andSelectionArray:(NSMutableArray *)selectionArray{
    
    if (indexPath.section - 7 == 2 || indexPath.section - 7 == 3) {
        
        _selectionArray = [NSMutableArray array];
        
        _selectionArray = selectionArray;
        
        _selectionIndexPath = indexPath;
        
        for (int i = 0; i < array.count; i++) {
            
           UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + i%3 * (WIDTH - 60)/3 + i%3 * 5, 13 + i/3 * 25 + i/3 * 15, (WIDTH - 60)/3, 30)];
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
            button.layer.cornerRadius =  15;
            button.clipsToBounds = YES;
            
            if ([selectionArray[i] isEqualToString:@"yes"]) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
            }else{
                
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 1;
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.tag = 1000 * indexPath.section + i;
            
            [button addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            
        }
        
        
    }else{
        
        for (int i = 0; i < array.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + i%3 * (WIDTH - 60)/3 + i%3 * 5, 14 + i/3 * 25 + i/3 * 15, (WIDTH - 60)/3, 30)];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
            button.layer.cornerRadius = 15;
            button.clipsToBounds = YES;
            
            if (i + 1 == [otherArray[indexPath.section - 7] intValue]) {
                
                [button setBackgroundColor:TextCOLOR];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
            }else{
                
                button.layer.borderWidth = 1;
                
                [button setTitle:array[i] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.tag = 1000 * indexPath.section + i;
            
            [button addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            
        }
    }
}

-(void)EditButtonClick:(UIButton *)button{

    if (_selectionIndexPath.section - 7 == 2 || _selectionIndexPath.section - 7 == 3) {
        
        if([_selectionArray[button.tag - _selectionIndexPath.section *1000] isEqualToString:@"no"]){
            
            [_selectionArray replaceObjectAtIndex:button.tag - 1000 * _selectionIndexPath.section withObject:@"yes"];
            
        }else{
            
            [_selectionArray replaceObjectAtIndex:button.tag - 1000 * _selectionIndexPath.section withObject:@"no"];
        }
        
        
        [self.delegate buttonClickOnCell:button changeSelection:_selectionArray];
    }else{
        
        [self.delegate buttonClickOnCell:button];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
