//
//  PVTStickerMenuView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTStickerMenuView.h"

@implementation PVTStickerMenuView
{
    UICollectionView *_stickerCollectionView;
}


- (instancetype)init
{
    self = [super initWithTitle:@"贴图"];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 91.5) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        [self setupCollectionView:collectionView];
        _stickerCollectionView = collectionView;
        [self addSubview:collectionView];
        self.height = 91.5+49;
    }
    return self;
}


#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _stickerCollectionView) {
        return CGSizeMake(64, 66);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _stickerCollectionView) {
        return 12.5;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == _stickerCollectionView) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _stickerCollectionView) {
        return [PVTStickerStyle defaultStyles].count;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _stickerCollectionView) {
        if (self.preferredStyle) {
            self.preferredStyle([[PVTStickerStyle defaultStyles] objectAtIndex:indexPath.row]);
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (collectionView == _stickerCollectionView) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(0, 0, 64, 66);
        imageView.layer.cornerRadius = 1;
        imageView.image = [[[PVTStickerStyle defaultStyles] objectAtIndex:indexPath.row] icon];
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.bounds)-15, CGRectGetWidth(cell.bounds), 10)];
        label.text = @"";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = HexColor(0x87898b);
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:label];
        return cell;
    }
    return nil;
}

@end
