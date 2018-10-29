//
//  PVTBrushMenu.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/29.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBrushMenuView.h"
#import "PVTEqualSpaceFlowLayout.h"
#import "UIColor+WTHexColor.h"



@implementation PVTBrushMenuView
{
    UICollectionView *_brushColorCollectionView;
    UICollectionView *_brushStyleCollectionView;
    UICollectionView *_brushEaraserCollectionView;
    
    PVTBrushStyle *_brushStyle;
}

- (instancetype)init
{
    self = [super initWithTitle:nil];
    if (self) {
        [self setItems:[self items]];
        
        self.height = 70+49;
        _brushStyle = [PVTBrushStyle new];
        
        PVTEqualSpaceFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        collectionView.hidden = YES;
        [self setupCollectionView:collectionView];
        _brushColorCollectionView = collectionView;
        [self addSubview:collectionView];
        
        
        layout = [[PVTEqualSpaceFlowLayout alloc] initWthType:PVTAlignTypeNatural];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        collectionView.hidden = YES;
        [self setupCollectionView:collectionView];
        _brushStyleCollectionView = collectionView;
        [self addSubview:collectionView];
        
        layout = [[PVTEqualSpaceFlowLayout alloc] initWthType:PVTAlignTypeNatural];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        collectionView.hidden = YES;
        [self setupCollectionView:collectionView];
        _brushEaraserCollectionView = collectionView;
        [self addSubview:collectionView];
        
        [_brushEaraserCollectionView reloadData];
        [_brushColorCollectionView reloadData];
        
        [self.items[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [_brushStyleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:_brushStyleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        [_brushColorCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:_brushColorCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];    }
    return self;
}

- (NSArray *)items {
    UIButton *shapeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 69, 40, 40)];
    [shapeBtn setSelected:YES];
    [shapeBtn setImage:[[UIImage imageNamed:@"gj_pic_huabi_yangse_p"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [shapeBtn setImage:[[UIImage imageNamed:@"gj_pic_huabi_yangse"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [shapeBtn setTitle:@"颜色" forState:UIControlStateNormal];
    shapeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [shapeBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [shapeBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    [shapeBtn addTarget:self action:@selector(changeBrushColor:) forControlEvents:UIControlEventTouchUpInside];
    //    brushColorBtn = shapeBtn;
    
    UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 69, 40, 40)];
    [colorBtn setImage:[UIImage imageNamed:@"gj_pic_huabi_yangshi_p"] forState:UIControlStateSelected];
    [colorBtn setImage:[UIImage imageNamed:@"gj_pic_huabi_yangshi"] forState:UIControlStateNormal];
    [colorBtn setTitle:@"样式" forState:UIControlStateNormal];
    colorBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [colorBtn addTarget:self action:@selector(changeBrushStyle:) forControlEvents:UIControlEventTouchUpInside];
    [colorBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [colorBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    //    brushStyleBtn = colorBtn;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 69, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"gj_pic_masaike_xiangpica_p"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"gj_pic_masaike_xiangpica"] forState:UIControlStateNormal];
    [btn setTitle:@"橡皮檫" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:9];
    [btn addTarget:self action:@selector(changeBrushEraser:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:RedColor forState:UIControlStateSelected];
    [btn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    self.items = @[shapeBtn, colorBtn, btn];
    return @[shapeBtn, colorBtn, btn];
}

- (void)changeBrushColor:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    _brushStyle.eraser = NO;
    _brushStyleCollectionView.hidden = YES;
    _brushColorCollectionView.hidden = NO;
    _brushEaraserCollectionView.hidden = YES;
}

- (void)changeBrushStyle:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    _brushStyle.eraser = NO;
    _brushStyleCollectionView.hidden = NO;
    _brushColorCollectionView.hidden = YES;
    _brushEaraserCollectionView.hidden = YES;
}

- (void)changeBrushEraser:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    _brushStyle.eraser = YES;
    _brushStyleCollectionView.hidden = YES;
    _brushColorCollectionView.hidden = YES;
    _brushEaraserCollectionView.hidden = NO;
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _brushColorCollectionView) {
        return CGSizeMake(34, 70);
    }
    return CGSizeMake(40*ScreenWidth/375., 70);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _brushColorCollectionView) {
        return [UIColor availableColors].count;
    } else if (collectionView == _brushStyleCollectionView) {
        return [PVTBrushStyle defaultTypes].count+2;
    }
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _brushColorCollectionView) {
        _brushStyle.strokeColor = [UIColor colorWithHexString:[UIColor availableColors][indexPath.row]];
        [self preferredStyle:_brushStyle];
        if (self.preferredStyle) {
            self.preferredStyle(_brushStyle);
        }
    } else {
        if (indexPath.row == 0) {
            if (self.preStep) {
                self.preStep();
            }
        } else if (indexPath.row == [self collectionView:collectionView numberOfItemsInSection:indexPath.section] - 1) {
            if (self.nextStep) {
                self.nextStep();
            }
        } else {
            _brushStyle.lineStyle = [[PVTBrushStyle defaultTypes] objectAtIndex:indexPath.row-1].lineStyle;
            [self preferredStyle:_brushStyle];
            if (self.preferredStyle) {
                self.preferredStyle(_brushStyle);
            }
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (collectionView == _brushColorCollectionView) {
        cell.backgroundColor = [UIColor colorWithHexString:[UIColor availableColors][indexPath.row]];
        
        UIImageView *borderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dqwd"]];
        cell.selectedBackgroundView = borderView;
        cell.selected = cell.isSelected;
        return cell;
    } else {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectInset(cell.bounds, 0, 10)];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:HexColor(0x87898b) forState:UIControlStateNormal];
        [btn setTitleColor:RedColor forState:UIControlStateSelected];
        [cell.contentView addSubview:btn];
        if (indexPath.row == 0) {
            [btn setImage:[UIImage imageNamed:@"gj_bianji_huabi_houtui"] forState:UIControlStateNormal];
            [btn setTitle:@"前一步" forState:UIControlStateNormal];
        } else if (indexPath.row == [self collectionView:collectionView numberOfItemsInSection:indexPath.section]-1) {
            [btn setImage:[UIImage imageNamed:@"gj_bianji_huabi_qianjin"] forState:UIControlStateNormal];
            [btn setTitle:@"后一步" forState:UIControlStateNormal];
        } else {
            PVTBrushStyle *style = [[PVTBrushStyle defaultTypes] objectAtIndex:indexPath.row - 1];
            [btn setImage:[style.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [btn setTitle:style.name forState:UIControlStateNormal];
            [cell setSelectedCallBack:^(BOOL selected) {
                btn.selected = selected;
            }];
        }
        btn.userInteractionEnabled = NO;
        return cell;
    }
    return nil;
}

- (void)preferredStyle:(PVTBrushStyle *)style {
    UIButton *colorBtn = (id)self.items[0];
    UIButton *styleBtn = (id)self.items[1];
    
    [styleBtn setImage:[style.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [styleBtn setImage:[style.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
}


@end
