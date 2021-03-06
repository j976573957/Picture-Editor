//
//  PVTBaseElementView.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVTBaseElementView : UIView <UIGestureRecognizerDelegate, NSCoding>
{
    @public
    UIView *_contentView;//内容
    UIButton *_btnDelete;//删除按钮
    UIButton *_btnTransition;//
    BOOL _isActive;//是否可编辑
    NSData *_preData;//上一次的数据
}

@property (nonatomic) CGFloat scale;//缩放比例
@property (nonatomic) CGFloat arg;//
@property (nonatomic) CGPoint initialPoint;//位置
@property (nonatomic) CGFloat initialArg;
@property (nonatomic) CGFloat initialScale;
@property (nonatomic, weak) UIView *preView;//记录上一个可编辑的 view

+ (void)setActiveElementView:(PVTBaseElementView*)view;
- (void)setActive:(BOOL)active;
- (BOOL)isActive;
- (void)setScale:(CGFloat)scale;
- (void)setArg:(CGFloat)arg;
- (BOOL)isEnabled:(UIView *)view;
- (void)deleteBtnClicked:(UIButton *)btn;
- (void)tapGestureEvent:(UITapGestureRecognizer *)tap;
- (void)prepareToSaveStatus;
- (void)saveStatus;
- (void)restoreState:(id)x superView:(UIView *)superView;

@end
