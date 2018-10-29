//
//  PVTMosicMenuView.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/12.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTMosicMenuView.h"
#import "PVTEqualSpaceFlowLayout.h"
#import "UICollectionViewCell+PVTExtra.h"

@implementation PVTMosicMenuView
{
    UICollectionView *mosaicTypeCollectionView;
    UICollectionView *mosaicStyleCollectionView;
    UICollectionView *mosaicEaraserCollectionView;
    PVTMosicStyle *mosaicStyle;
}

- (instancetype)init
{
    self = [super initWithTitle:nil];
    if (self) {
        
        mosaicStyle = [PVTMosicStyle new];
        
        [self setItems:[self items]];
        PVTEqualSpaceFlowLayout *layout = [[PVTEqualSpaceFlowLayout alloc] initWthType:PVTAlignTypeNatural];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        collectionView.hidden = YES;
        [self setupCollectionView:collectionView];
        mosaicTypeCollectionView = collectionView;
        [self addSubview:collectionView];
        self.height = 60+49;
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        collectionView.hidden = YES;
        [self setupCollectionView:collectionView];
        mosaicStyleCollectionView = collectionView;
        [self addSubview:collectionView];
        
        layout = [[PVTEqualSpaceFlowLayout alloc] initWthType:PVTAlignTypeNatural];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 70) collectionViewLayout:layout];
        collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        collectionView.hidden = YES;
        [self setupCollectionView:collectionView];
        mosaicEaraserCollectionView = collectionView;
        [self addSubview:collectionView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mosaicStyleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
            [self collectionView:mosaicStyleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            
            [mosaicTypeCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
            [self collectionView:self->mosaicTypeCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
        [self.items[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (NSArray *)items {
    UIButton *shapeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [shapeBtn setSelected:YES];
    [shapeBtn setImage:[UIImage imageNamed:@"masaike_tumo_p_icon"] forState:UIControlStateSelected];
    [shapeBtn setImage:[UIImage imageNamed:@"masaike_tumo_icon"] forState:UIControlStateNormal];
    [shapeBtn setTitle:@"涂抹" forState:UIControlStateNormal];
    shapeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [shapeBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [shapeBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    [shapeBtn addTarget:self action:@selector(changeMosaicType:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [colorBtn setImage:[UIImage imageNamed:@"masaike_yangshi_p_icon"] forState:UIControlStateSelected];
    [colorBtn setImage:[UIImage imageNamed:@"masaike_yangshi_icon"] forState:UIControlStateNormal];
    [colorBtn setTitle:@"样式" forState:UIControlStateNormal];
    colorBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [colorBtn addTarget:self action:@selector(changeMosaicStyle:) forControlEvents:UIControlEventTouchUpInside];
    [colorBtn setTitleColor:RedColor forState:UIControlStateSelected];
    [colorBtn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    //    mosaicStyleBtn = colorBtn;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"gj_pic_masaike_xiangpica_p"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"gj_pic_masaike_xiangpica"] forState:UIControlStateNormal];
    [btn setTitle:@"橡皮檫" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:9];
    [btn addTarget:self action:@selector(changeMosaicEraser:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:RedColor forState:UIControlStateSelected];
    [btn setTitleColor:HexColor(0x515151) forState:UIControlStateNormal];
    self.items = @[shapeBtn, colorBtn, btn];
    return @[shapeBtn, colorBtn, btn];
}

- (void)changeMosaicType:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    mosaicStyle.eraser = NO;
    mosaicTypeCollectionView.hidden = NO;
    mosaicStyleCollectionView.hidden = YES;
    mosaicEaraserCollectionView.hidden = YES;
    
    self.height = 70+49;
    self.origin = CGPointMake(0, ScreenHeight - self.height);
}

- (void)changeMosaicStyle:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    mosaicStyle.eraser = NO;
    mosaicStyleCollectionView.hidden = NO;
    mosaicTypeCollectionView.hidden = YES;
    mosaicEaraserCollectionView.hidden = YES;
    self.height = 70+49;
    self.origin = CGPointMake(0, ScreenHeight - self.height);
}

- (void)changeMosaicEraser:(UIButton *)sender {
    for (UIButton *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
        }
    }
    sender.selected = YES;
    mosaicStyle.eraser = YES;
    mosaicStyleCollectionView.hidden = YES;
    mosaicTypeCollectionView.hidden = YES;
    mosaicEaraserCollectionView.hidden = NO;
    self.height = 70+49;
    self.origin = CGPointMake(0, ScreenHeight - self.height);
}


#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == mosaicStyleCollectionView) {
        return CGSizeMake(58, 58);
    } else if (collectionView == mosaicTypeCollectionView) {
        return CGSizeMake(58, 58);
    }
    return CGSizeMake(58, 58);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == mosaicStyleCollectionView) {
        return 6;
    }
    return 0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == mosaicStyleCollectionView) {
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == mosaicTypeCollectionView) {
        return [PVTMosicStyle defaultTypes].count+2;
    } else if (collectionView == mosaicStyleCollectionView) {
        return [PVTMosicStyle defaultStyles].count;
    }
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == mosaicStyleCollectionView) {
        mosaicStyle.image = [[PVTMosicStyle defaultStyles] objectAtIndex:indexPath.row].image;
        if (self.preferredStyle) {
            self.preferredStyle(mosaicStyle);
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
            mosaicStyle.mosaicType = [[PVTMosicStyle defaultTypes] objectAtIndex:indexPath.row-1].mosaicType;
            if (self.preferredStyle) {
                self.preferredStyle(mosaicStyle);
            }
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (collectionView == mosaicStyleCollectionView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(0, 0, 58, 58);
        imageView.backgroundColor = HexColor(0x87898b);
        imageView.layer.cornerRadius = 1;
        imageView.image = [[[PVTMosicStyle defaultStyles] objectAtIndex:indexPath.row] icon];
        [cell.contentView addSubview:imageView];
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
            PVTMosicStyle *style = [[PVTMosicStyle defaultTypes] objectAtIndex:indexPath.row - 1];
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

@end
