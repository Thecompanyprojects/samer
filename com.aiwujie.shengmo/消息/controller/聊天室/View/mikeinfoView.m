//
//  mikeinfoView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/9/15.
//  Copyright © 2019 a. All rights reserved.
//

#import "mikeinfoView.h"
#import "mikeinfoCell.h"
#import "chatpersonViewModel.h"
#import "chatmikeModel.h"

@interface mikeinfoView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation mikeinfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 50) collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.collectionView registerClass:[mikeinfoCell class] forCellWithReuseIdentifier:@"identifier2"];
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    mikeinfoCell *cell = (mikeinfoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"identifier2" forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.dataSource.count!=0) {
        [cell setModel:self.dataSource[indexPath.row]];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    if (self.talkArray.count!=0) {
        cell.talkArray = self.talkArray;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count==0) {
        return;
    }
    chatmikeModel *model = self.dataSource[indexPath.item];
    if (self.delegate) {
        if (model.uid.length!=0) {
            [self.delegate mikeinfovc:model.uid];
        }
    }
}

@end
