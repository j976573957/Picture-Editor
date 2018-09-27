//
//  PVTArrowMenuView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTArrowMenuView.h"
#import "UIColor+WTHexColor.h"

@implementation PVTArrowMenuView
{
    UICollectionView *_arrowStyleCollectionView;
    UICollectionView *_arrowColorCollectionView;
}

- (instancetype)init
{
    self = [super initWithTitle:nil];
    if (self) {
        
        [self setItems:[self items]];
        arrowStyle = [[PVTArrowStyle defaultStyles] firstObject];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        [self setupCollectionView:collectionView];
        _arrowStyleCollectionView = collectionView;
        [self addSubview:collectionView];
        self.height = 70+49;
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        [self setupCollectionView:collectionView];
        _arrowColorCollectionView = collectionView;
        [self addSubview:collectionView];
        
        [self.items[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [_arrowStyleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [_arrowColorCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:_arrowStyleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self collectionView:_arrowColorCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }
    return self;
}

- (NSArray<UIButton *> *)items
{
    UIButton *shapeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 69, 40, 40)];
    [shapeBtn setSelected:YES];
    [shapeBtn setImage:[UIImage imageNamed:@"jiantou_yangshi_p_icon"] forState:UIControlStateSelected];
    [shapeBtn setImage:[UIImage imageNamed:@"jiantou_yangshi_icon"] forState:UIControlStateNormal];
    [shapeBtn setTitle:@"样式" forState:UIControlStateNormal];
    shapeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [shapeBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [shapeBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    [shapeBtn addTarget:self action:@selector(changeArrowStyle:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 69, 40, 40)];
    [colorBtn setImage:[UIImage imageNamed:@"jiantou_yanse_p_icon"] forState:UIControlStateSelected];
    [colorBtn setImage:[UIImage imageNamed:@"jiantou_yanse_icon"] forState:UIControlStateNormal];
    [colorBtn setTitle:@"箭头颜色" forState:UIControlStateNormal];
    colorBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [colorBtn addTarget:self action:@selector(changeArrowColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [colorBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    
    self.items = @[shapeBtn, colorBtn];
    return @[shapeBtn, colorBtn];
}

#pragma mark - 按钮点击事件
- (void)changeArrowStyle:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    _arrowStyleCollectionView.hidden = NO;
    _arrowColorCollectionView.hidden = YES;
}

- (void)changeArrowColor:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    _arrowStyleCollectionView.hidden = YES;
    _arrowColorCollectionView.hidden = NO;
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _arrowColorCollectionView) {
        return CGSizeMake(34, 70);
    } else if (collectionView == _arrowStyleCollectionView) {
        return CGSizeMake(44, 44);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _arrowStyleCollectionView) {
        return (ScreenWidth - 6*44)/7.;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == _arrowStyleCollectionView){
        CGFloat x = (ScreenWidth - 6*44)/7.;
        return UIEdgeInsetsMake(8, x, 8, x);
    }
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _arrowColorCollectionView){
        return [UIColor availableColors].count;
    } else if (collectionView == _arrowStyleCollectionView) {
        return [PVTArrowStyle defaultStyles].count;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _arrowStyleCollectionView) {
        UIColor *color = arrowStyle.color;
        arrowStyle = [[PVTArrowStyle defaultStyles] objectAtIndex:indexPath.row];
        arrowStyle.color = color;
    } else if (collectionView == _arrowColorCollectionView) {
        arrowStyle.color = [UIColor colorWithHexString:[UIColor availableColors][indexPath.row]];
    }
    if (self.preferredStyle) {
        self.preferredStyle(arrowStyle);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (collectionView == _arrowStyleCollectionView) {
        NSString *imageName = [NSString stringWithFormat:@"gj_bianji_jiantou_%zd",indexPath.row+1];
        NSString *selectedImageName = [NSString stringWithFormat:@"gj_bianji_jiantouxuanzhong_%zd",indexPath.row+1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, cell.width, cell.height);
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        btn.backgroundColor = HexColor(0xf4f4f4);
        [cell.contentView addSubview:btn];
        cell.selected = cell.isSelected;
        return cell;
    } else if (collectionView == _arrowColorCollectionView) {
        cell.backgroundColor = [UIColor colorWithHexString:[UIColor availableColors][indexPath.row]];
        
        UIImageView *borderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dqwd"]];
        cell.selectedBackgroundView = borderView;
        cell.selected = cell.isSelected;
        return cell;
    }
    return nil;
}

@end
