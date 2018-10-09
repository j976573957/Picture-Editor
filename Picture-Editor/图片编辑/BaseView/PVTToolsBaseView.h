//
//  PVTToolsBaseView.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewCell+PVTExtra.h"

@protocol PVTToolsBaseViewDelegate <NSObject>

- (void)cancel:(id)sender;
- (void)confirm:(id)sender;

@end

@interface PVTToolsBaseView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id <PVTToolsBaseViewDelegate> delegate;
@property (nonatomic, strong) NSArray<UIButton *> *items;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnOk;

- (id)initWithTitle:(NSString *)title;
- (void)setupCollectionView:(UICollectionView *)collectionView;
- (void)relayoutSubViews;

@end
