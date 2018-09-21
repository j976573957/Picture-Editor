//
//  PVTFrameMenuView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTFrameMenuView.h"
#import "PVTEqualSpaceFlowLayout.h"
#import "UICollectionViewCell+PVTExtra.h"
#import "UIColor+WTHexColor.h"

@implementation PVTFrameMenuView
{
    UICollectionView *frameTypeCollectionView;
    UICollectionView *frameColorCollectionView;
    UICollectionView *frameLineWidthCollectionView;
    NSArray *_items;
}

- (instancetype)init
{
    self = [super initWithTitle:nil];
    if (self) {
        self.height = 70+49;
        [self setItems:[self items]];
        frameStyle = [[PVTFrameStyle alloc] init];
        frameStyle.frameType = PVTFrameTypeRect;
        frameStyle.color = [UIColor redColor];
        frameStyle.lineWidth = 10;
        
        PVTEqualSpaceFlowLayout *layout = [[PVTEqualSpaceFlowLayout alloc] init];
        layout.cellType = PVTAlignTypeCenter;
        layout.itemSpace = 26;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self setupCollectionView:collectionView];
        frameTypeCollectionView = collectionView;
        [self addSubview:collectionView];
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self setupCollectionView:collectionView];
        frameColorCollectionView = collectionView;
        [self addSubview:collectionView];
        
        layout = [[PVTEqualSpaceFlowLayout alloc] init];
        layout.cellType = PVTAlignTypeCenter;
        layout.itemSpace = 26;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self setupCollectionView:collectionView];
        frameLineWidthCollectionView = collectionView;
        [self addSubview:collectionView];
        
        [self.items[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [frameTypeCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [frameColorCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [frameLineWidthCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:frameTypeCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self collectionView:frameColorCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self collectionView:frameLineWidthCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [self changeFrameShape:nil];
    }
    return self;
}

- (NSArray *)items {
    UIButton *shapeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shapeBtn.frame = CGRectMake(0, 69, 44, 40);
    [shapeBtn setImage:[[UIImage imageNamed:@"xiankuang_zhijiao_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [shapeBtn setTitle:@"形状" forState:UIControlStateNormal];
    shapeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [shapeBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [shapeBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    [shapeBtn addTarget:self action:@selector(changeFrameShape:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colorBtn.frame = CGRectMake(0, 69, 44, 40);
    [colorBtn setImage:[[UIImage imageNamed:@"xiankuang_yanse_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
    colorBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [colorBtn addTarget:self action:@selector(changeFrameColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [colorBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    
    UIButton *widthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    widthBtn.frame = CGRectMake(0, 69, 44, 40);
    [widthBtn setImage:[[UIImage imageNamed:@"xiankuang_cuxi_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [widthBtn setTitle:@"粗细" forState:UIControlStateNormal];
    widthBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [widthBtn addTarget:self action:@selector(changeFrameLineWidth:) forControlEvents:UIControlEventTouchUpInside];
    [widthBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [widthBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    widthBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _items = @[shapeBtn, colorBtn, widthBtn];
    self.items = _items;
    return _items;
}

- (void)changeFrameShape:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    frameTypeCollectionView.hidden = NO;
    frameColorCollectionView.hidden = YES;
    frameLineWidthCollectionView.hidden = YES;
}

- (void)changeFrameColor:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    frameTypeCollectionView.hidden = YES;
    frameColorCollectionView.hidden = NO;
    frameLineWidthCollectionView.hidden = YES;
}

- (void)changeFrameLineWidth:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    frameTypeCollectionView.hidden = YES;
    frameColorCollectionView.hidden = YES;
    frameLineWidthCollectionView.hidden = NO;
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == frameTypeCollectionView) {
        return CGSizeMake(30, 70);
    } else if (collectionView == frameColorCollectionView) {
        return CGSizeMake(34, 70);
    } else if (collectionView == frameLineWidthCollectionView) {
        return CGSizeMake(30, 70);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == frameTypeCollectionView) {
        return 5;
    } else if (collectionView == frameColorCollectionView) {
        return [UIColor availableColors].count;
    } else if (collectionView == frameLineWidthCollectionView) {
        return 3;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == frameColorCollectionView) {
        frameStyle.color = [UIColor colorWithHexString:[UIColor availableColors][indexPath.row]];
    } else if (collectionView == frameLineWidthCollectionView) {
        frameStyle.lineWidth = 5 * (indexPath.row+1);
        frameStyle.lineLevel = indexPath.row;
    } else if (collectionView == frameTypeCollectionView) {
        frameStyle.frameType = indexPath.row;
    }
    [self preferredStyle:frameStyle];
    if (self.preferredStyle) {
        self.preferredStyle(frameStyle);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (collectionView == frameTypeCollectionView) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(7, 0, 16, 16);
        imageView.center = CGPointMake(cell.width/2., cell.height/2.);
        //        imageView.layer.cornerRadius = 1;
        NSArray *imageNames = [self.class shapeImages];
        imageView.image = [[UIImage imageNamed:imageNames[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.contentView addSubview:imageView];
        [cell setSelectedCallBack:^(BOOL selected){
            if (selected) {
                imageView.tintColor = RedColor;
            } else {
                imageView.tintColor = HexColor(0x515151);
            }
        }];
        cell.selected = cell.isSelected;
        return cell;
    } else if (collectionView == frameColorCollectionView) {
        cell.backgroundColor = [UIColor colorWithHexString:[UIColor availableColors][indexPath.row]];
        
        UIImageView *borderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dqwd"]];
        cell.selectedBackgroundView = borderView;
        cell.selected = cell.isSelected;
        return cell;
    } else if (collectionView == frameLineWidthCollectionView) {
        NSArray *imageNames = [self.class widthImages];
        NSArray *titles = @[@"细",@"普通",@"粗"];

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectInset(cell.bounds, 0, 10)];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:HexColor(0x87898b) forState:UIControlStateNormal];
        [btn setTitleColor:RedColor forState:UIControlStateSelected];
        [cell.contentView addSubview:btn];
        [btn setImage:[[UIImage imageNamed:imageNames[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btn setTitle:titles[indexPath.row] forState:UIControlStateNormal];
        
        [cell setSelectedCallBack:^(BOOL selected){
            btn.selected = selected;
        }];
        btn.userInteractionEnabled = NO;
        return cell;
    }
    return nil;
}

+ (NSArray *)shapeImages {
    static NSArray *imageNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageNames = @[@"xiankuang_zhijiao_icon",@"xiankuang_yuanjiao_icon",@"xiankuang_yuan_icon",@"xiankuang_xian_icon",@"xiankuang_shixin_icon"];
    });
    return imageNames;
}


+ (NSArray *)widthImages {
    static NSArray *imageNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageNames = @[@"xiankuang_xi_icon",@"xiankuang_zhong_icon",@"xiankuang_cu_icon"];
    });
    return imageNames;
}



- (void)preferredStyle:(PVTFrameStyle *)style {
    UIButton *shapeBtn = (id)self.items[0];
    UIButton *colorBtn = (id)self.items[1];
    UIButton *widthBtn = (id)self.items[2];
    NSArray *imageNames = [self.class shapeImages];
    [shapeBtn setImage:[[UIImage imageNamed:imageNames[style.frameType]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    imageNames = [self.class widthImages];
    [widthBtn setImage:[[UIImage imageNamed:imageNames[style.lineLevel]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

@end
