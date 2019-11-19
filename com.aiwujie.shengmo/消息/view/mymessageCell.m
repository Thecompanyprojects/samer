//
//  mymessageCell.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/27.
//  Copyright © 2019 a. All rights reserved.
//

#import "mymessageCell.h"
#import "mymessageContent.h"


@implementation mymessageCell

- (void)initialize
{
    
}

//当应用自定义消息时，必须实现该方法来返回cell的Size
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    //这里我们设定的高度是120，所以加上extraHeight
    return CGSizeMake(WIDTH , 120 + extraHeight);
}
//model 的 set 方法
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout:model];
}
//布局我们可以写在这个里边
- (void)setAutoLayout:(RCMessageModel *)model{
    //接收到的消息我们需要拿到需要的数据，赋值到自定义 cell 的控件上
    mymessageContent *shopingDetailContent = (mymessageContent *)self.model.content;
    
    if (shopingDetailContent) {
        NSData *jsonData = [shopingDetailContent.content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                             
                                                            options:NSJSONReadingMutableContainers
                             
                                                              error:&err];
        NSLog(@"dic == %@",dic);
        /******************自定义消息 cell 的布局和赋值************/
    }
    
}

@end
