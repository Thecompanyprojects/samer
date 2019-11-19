//
//  LDHistorynameCell.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/8.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDHistorynameCell.h"
#import "LDhistoryViewModel.h"

@implementation LDHistorynameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
    }
    return self;
}

-(void)bindViewModel:(LDhistoryViewModel *)viewModel
{
    self.textLabel.text = viewModel.nickname?:@"";
    self.detailTextLabel.text = [[TimeManager defaultTool] getDateFormatStrFromTimeStampWithMin:viewModel.addtime];
}

@end
