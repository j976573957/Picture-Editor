//
//  PVTToolsBaseView.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"

@interface PVTToolsBaseView ()
{
    NSString *_titleStr;
}

@property (nonatomic, strong) UILabel *lbTitle;

@end

@implementation PVTToolsBaseView

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    if (self) {
        if (title.length) {
            _titleStr = title;
        }
        self.backgroundColor = [UIColor whiteColor];
        [self addAllSubviews];
        [self layoutAllSubviews];
        
    }
    return self;
}

#pragma mark - 初始化UI
- (void)addAllSubviews
{
    [self addSubview:self.lbTitle];
    [self addSubview:self.btnClose];
    [self addSubview:self.btnOk];
}

- (void)layoutAllSubviews
{
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.bottom.mas_equalTo(safaAreaBottom);
        make.left.mas_equalTo(0);
    }];
    
    [self.btnOk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.bottom.mas_equalTo(safaAreaBottom);
        make.right.mas_equalTo(0);
    }];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(safaAreaBottom);
        make.left.mas_equalTo(self.btnClose.mas_right);
        make.right.mas_equalTo(self.btnOk.mas_left);
    }];
}

- (void)setupCollectionView:(UICollectionView *)collectionView
{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = collectionView.bounds;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
}

#pragma mark - setter & getter
- (void)setItems:(NSArray<UIButton *> *)items
{
    if (_items) return;
    _items = items.mutableCopy;
    for (UIButton *item in items) {
        [item removeFromSuperview];
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        item.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        NSInteger count = items.count;
        CGFloat gap = (self.width - 20*2 - count*40)/(count+1);
        for (NSInteger i = 0; i < count; i++) {
            UIButton *item = items[i];
            item.origin = CGPointMake(20+gap+(40+gap)*i, 79);
        }
        
        [self addSubview:item];
    }
}

- (UILabel *)lbTitle
{
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.text = _titleStr;
    }
    return _lbTitle;
}

- (UIButton *)btnOk
{
    if (!_btnOk) {
        _btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnOk setImage:[UIImage imageNamed:@"gj_pic_xuanze"] forState:UIControlStateNormal];
        [_btnOk addTarget:self action:@selector(handleOK:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnOk;
}

- (UIButton *)btnClose
{
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose setImage:[UIImage imageNamed:@"gj_pic_guanbi"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(handleClose:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnClose;
}

#pragma mark - 事件
- (void)handleClose:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cancel:)]) {
        [_delegate cancel:self];
    }
}

- (void)handleOK:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(confirm:)]) {
        [_delegate confirm:self];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
