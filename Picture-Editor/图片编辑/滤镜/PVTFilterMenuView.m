//
//  PVTFilterMenuView.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTFilterMenuView.h"
#import "UICollectionViewCell+PVTExtra.h"
#import "UIImage+PVTFilter.h"

@implementation PVTFilterMenuView
{
    UICollectionView *filterCollectionView;
    NSArray *filterTitles;
}

- (instancetype)init
{
    self = [super initWithTitle:@"滤镜"];
    if (self) {
        filterTitles = @[@"原图",@"美颜",@"晕影",@"流年",@"冷调",@"碧波",@"怀旧",@"蒙暗",@"HDR",@"日出",@"曝光",@"素描",@"油画"];
        
        //布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //collectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 100) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        [self setupCollectionView:collectionView];
        filterCollectionView = collectionView;
        [self addSubview:collectionView];
        
        //默认选中
        [filterCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:filterCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        //
        self.height = 100+49;
    }
    return self;
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == filterCollectionView ) {
        return CGSizeMake(64, 100);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == filterCollectionView) {
        return 12.5;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == filterCollectionView) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == filterCollectionView) {
        return filterTitles.count;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == filterCollectionView) {
        if (self.preferredFilterID) {
            self.preferredFilterID(indexPath.row - 1);
        }
    }
}

- (void)setImage:(UIImage *)image {
    _image = [image thumbWithWidth:100];
    [filterCollectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(0, 8.5, 64, 66);
    imageView.backgroundColor = HexColor(0x87898b);
    imageView.layer.cornerRadius = 1;
    
    [_image filter:indexPath.row-1 completion:^(UIImage *image) {
        imageView.image = image;
    }];
    
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.bounds)-15, CGRectGetWidth(cell.bounds), 10)];
    label.text = filterTitles[indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = HexColor(0x87898b);
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:label];
    
    [cell setSelectedCallBack:^(BOOL selected) {
        if (selected) {
            label.textColor = RedColor;
        } else {
            label.textColor = HexColor(0x87898b);
        }
    }];
    
    return cell;
}

@end
