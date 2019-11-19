//
//  RegisterNextCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import "RegisterNextCell.h"

@interface RegisterNextCell ()
@property (nonatomic,strong) NSMutableArray * selectionArray;
@property (nonatomic,strong) NSIndexPath * selectionIndexPath;
@end

@implementation RegisterNextCell



-(void)addoptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andSelectionArray:(NSMutableArray *)selectionArray{

    self.titleLabel.text = array[indexPath.row];
    
    [self.titleLabel sizeToFit];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *chooseArray = @[@[@"男",@"女",@"CDTS"],@[],@[],@[@"斯",@"慕",@"双",@"~"],@[@"男",@"女",@"CDTS"]];
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
        
        
        if (indexPath.row == 0) {
            //self.lineView.hidden = NO;
        }
        
        if (indexPath.row == 4) {
            
            _selectionArray = [NSMutableArray array];
            
            _selectionArray = selectionArray;
            
            _selectionIndexPath = indexPath;
            
        }
        
        if (indexPath.row == 3) {
            
            self.button1.hidden = NO;
            
            self.button2.hidden = NO;
            
            self.button3.hidden = NO;
      
            self.button4.hidden = NO;
            
            self.button1.tag = (indexPath.row + 1) *100;
            
            self.button2.tag = (indexPath.row + 1) *100 + 1;
            
            self.button3.tag = (indexPath.row + 1) *100 + 2;
            
            self.button4.tag = (indexPath.row + 1) *100 + 3;
            
            [self.button1 setTitle:chooseArray[indexPath.row][1] forState:UIControlStateNormal];
            
            [self.button2 setTitle:chooseArray[indexPath.row][2] forState:UIControlStateNormal];
            
            [self.button3 setTitle:chooseArray[indexPath.row][3] forState:UIControlStateNormal];
            
            [self.button4 setTitle:chooseArray[indexPath.row][0] forState:UIControlStateNormal];
            
            [self.button4 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else{
        
            self.button1.hidden = NO;
            
            self.button2.hidden = NO;
            
            self.button3.hidden = NO;
            
            self.button1.tag = (indexPath.row + 1) *100;
            
            self.button2.tag = (indexPath.row + 1) *100 + 1;
            
            self.button3.tag = (indexPath.row + 1) *100 + 2;
            
            [self.button1 setTitle:chooseArray[indexPath.row][0] forState:UIControlStateNormal];
            
            [self.button2 setTitle:chooseArray[indexPath.row][1] forState:UIControlStateNormal];
            
            [self.button3 setTitle:chooseArray[indexPath.row][2] forState:UIControlStateNormal];

        }
        
        
        [self.button1 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.button2 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.button3 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        

    }else{
        
        self.arrowView.hidden = NO;
    }

}


-(void)editAddoptionWithArray:(NSArray *)array andIndexpath:(NSIndexPath *)indexPath andOtherArray:(NSMutableArray *)otherArray andSelectionArray:selectionArray{
    
    self.titleLabel.text = array[indexPath.section][0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _selectionArray = [NSMutableArray array];
    
    _selectionIndexPath = indexPath;
    
    NSArray *chooseArray = @[@[],@[],@[],@[],@[@"男",@"女",@"CDTS"],@[@"斯",@"慕",@"双",@"~"],@[@"男",@"女",@"CDTS"]];
    
    if (indexPath.section == 0) {
        
        self.showLabel.text = otherArray[0];
        
        //self.lineView.hidden = NO;
            
        self.arrowView.hidden = NO;
        
    }else if (indexPath.section == 1){
    
        self.showLabel.text = otherArray[1];
        
        self.arrowView.hidden = NO;
        
    }else if (indexPath.section == 2){
    
        self.showLabel.text = otherArray[2];
        
        self.arrowView.hidden = NO;
        
    }else if (indexPath.section == 3){
    
        self.showLabel.text = otherArray[3];
        
        self.arrowView.hidden = NO;
        
    }else if (indexPath.section == 4) {
        
        self.button1.hidden = NO;
        
        self.button2.hidden = NO;
        
        self.button3.hidden = NO;
        
        self.button1.tag = (indexPath.section + 1) *100;
        
        self.button2.tag = (indexPath.section + 1) *100 + 1;
        
        self.button3.tag = (indexPath.section + 1) *100 + 2;
        
        for (int i = 0; i < [chooseArray[indexPath.section] count]; i++) {
            
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:(indexPath.section + 1) * 100 + i];
            
             [btn setTitle:chooseArray[indexPath.section][i] forState:UIControlStateNormal];
            
            if ([otherArray[indexPath.section] intValue] - 1 == i) {
                
                [btn setBackgroundColor:TextCOLOR];
                
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                 btn.layer.borderWidth = 0;
                
            }else{
            
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitleColor:TextCOLOR forState:normal];
                btn.layer.borderWidth = 1;
            }
            
            [self.button1 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button2 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button3 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }else if (indexPath.section == 5){
    
        self.button1.hidden = NO;
        
        self.button2.hidden = NO;
        
        self.button3.hidden = NO;
        
        self.button4.hidden = NO;
        
        self.button1.tag = (indexPath.section + 1) *100 + 1;
        
        self.button2.tag = (indexPath.section + 1) *100 + 2;
        
        self.button3.tag = (indexPath.section + 1) *100 + 3;
        
        self.button4.tag = (indexPath.section + 1) *100;
        
        for (int i = 0; i < [chooseArray[indexPath.section] count]; i++) {
            
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:(indexPath.section + 1) * 100 + i];
          
            NSString *role;
                
            if ([otherArray[indexPath.section] isEqualToString:@"S"]) {
                
                role = @"斯";
                
            }else if ([otherArray[indexPath.section] isEqualToString:@"M"]){
                
                role = @"慕";
                
                
            }else if ([otherArray[indexPath.section] isEqualToString:@"SM"]){
                
                role = @"双";
                
            }else{
                
                role = @"~";
                
            }

            [btn setTitle:chooseArray[indexPath.section][i] forState:UIControlStateNormal];
            
            if ([role isEqualToString:chooseArray[indexPath.section][i]]) {
                
                [btn setBackgroundColor:TextCOLOR];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.layer.borderWidth = 0;
                
            }else{
                
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitleColor:TextCOLOR forState:normal];
                btn.layer.borderWidth = 1;
            }
            
            [self.button1 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button2 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button3 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button4 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }

        
    }else if (indexPath.section == 6){
    
        self.button1.hidden = NO;
        
        self.button2.hidden = NO;
        
        self.button3.hidden = NO;
        
        self.button1.tag = (indexPath.section + 1) *100;
        
        self.button2.tag = (indexPath.section + 1) *100 + 1;
        
        self.button3.tag = (indexPath.section + 1) *100 + 2;
        
        _selectionArray = selectionArray;
        
        for (int i = 0; i < [chooseArray[indexPath.section] count]; i++) {
            
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:(indexPath.section + 1) * 100 + i];
            
            if ([selectionArray[i] isEqualToString:@"yes"]) {
                
                [btn setBackgroundColor:TextCOLOR];
                
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [btn setTitle:chooseArray[indexPath.section][i] forState:UIControlStateNormal];
                
                btn.layer.borderWidth = 0;
                
            }else{
                
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitleColor:TextCOLOR forState:normal];
                [btn setTitle:chooseArray[indexPath.section][i] forState:UIControlStateNormal];
                btn.layer.borderWidth = 1;
            }
            
            [self.button1 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button2 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button3 addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }
}

-(void)EditButtonClick:(UIButton *)button{

    if (_selectionArray.count == 0) {
        
        [self.delegate buttonClickOnCell:button];
        
    }else{
        
        if([_selectionArray[button.tag - (_selectionIndexPath.section + 1) *100] isEqualToString:@"no"]){
            
            [_selectionArray replaceObjectAtIndex:button.tag - (_selectionIndexPath.section + 1) *100 withObject:@"yes"];
            
        }else{
            
            [_selectionArray replaceObjectAtIndex:button.tag - (_selectionIndexPath.section + 1) *100 withObject:@"no"];
        }
        
        [self.delegate buttonClickOnCell:button changeSelection:_selectionArray];
    }

}

-(void)ButtonClick:(UIButton *)button{
    
    if (_selectionArray.count == 0) {
        
        [self.delegate buttonClickOnCell:button];
        
    }else{
        
        if([_selectionArray[button.tag - (_selectionIndexPath.row + 1) *100] isEqualToString:@"no"]){
        
            [_selectionArray replaceObjectAtIndex:button.tag - (_selectionIndexPath.row + 1) *100 withObject:@"yes"];
            
        }else{
        
            [_selectionArray replaceObjectAtIndex:button.tag - (_selectionIndexPath.row + 1) *100 withObject:@"no"];
        }
    
        [self.delegate buttonClickOnCell:button changeSelection:_selectionArray];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.button1.layer.borderWidth = 1;
    [self.button1 setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
    self.button1.layer.borderColor =[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
    self.button1.layer.cornerRadius = 15;
    self.button1.clipsToBounds = YES;
    
    self.button2.layer.borderWidth = 1;
    [self.button2 setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
    self.button2.layer.borderColor =[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
    self.button2.layer.cornerRadius = 15;
    self.button2.clipsToBounds = YES;
    
    self.button3.layer.borderWidth = 1;
    [self.button3 setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
    self.button3.layer.borderColor =[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
    self.button3.layer.cornerRadius = 15;
    self.button3.clipsToBounds = YES;
    
    self.button4.layer.borderWidth = 1;
    [self.button4 setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
    self.button4.layer.borderColor =[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
    self.button4.layer.cornerRadius = 15;
    self.button4.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
