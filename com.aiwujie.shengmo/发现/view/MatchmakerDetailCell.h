//
//  MatchmakerDetailCell.h
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchmakerDetailCell : UITableViewCell

-(void)matchmasterDic:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath;


@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceH;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *foureLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;

@end
