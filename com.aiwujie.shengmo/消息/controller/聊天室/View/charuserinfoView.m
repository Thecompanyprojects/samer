//
//  charuserinfoView.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/31.
//  Copyright © 2019 a. All rights reserved.
//

#import "charuserinfoView.h"
#import "chatpersonCell.h"
#import "chatpersonViewModel.h"
#import "chatpersonModel.h"

@interface charuserinfoView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation charuserinfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20-50, 50) collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.collectionView registerClass:[chatpersonCell class] forCellWithReuseIdentifier:@"identifier"];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    chatpersonCell *cell = (chatpersonCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iconImg.backgroundColor = [UIColor whiteColor];
    if (self.dataSource.count!=0) {
        [cell setModel:self.dataSource[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count==0) {
        return;
    }
    chatpersonModel *model = self.dataSource[indexPath.item];
    if (self.delegate) {
        [self.delegate touserinfovc:model.uid];
    }
}

@end
