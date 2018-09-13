//
//  PVTBaseElementView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTBaseElementView.h"

@implementation PVTBaseElementView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{   self = [super initWithFrame:frame];
    if (self) {
        self.layer.allowsEdgeAntialiasing = YES;//抗锯齿
        
        [self initUI];
        [self awakeFromNib];
        [self initGestures];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _scale = 1.0;
    _arg = 0;
}

- (void)initUI
{
    //内容
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.layer.borderColor = [[UIColor blackColor] CGColor];
    _contentView.layer.cornerRadius = 3;
    _contentView.center = self.center;
    [self addSubview:_contentView];
    
    //删除按钮
    _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnDelete setImage:[UIImage imageNamed:@"gj_bianji_guanbi_icon"] forState:UIControlStateNormal];
    _btnDelete.frame = CGRectMake(-17*sqrt(2), -17*sqrt(2), 34, 34);
    [_btnDelete addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnDelete];
    
    //
    _btnTransition = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTransition.frame = CGRectMake(self.width-10, self.height-10, 34, 34);
    [_btnTransition setImage:[UIImage imageNamed:@"gj_bianji_xuanzhuan_icon"] forState:UIControlStateNormal];
    _btnTransition.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_btnTransition];
}

- (void)initGestures
{
    _contentView.userInteractionEnabled = YES;
    
    //tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEvent:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
    //
    [_btnTransition addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

#pragma mark - 事件
- (void)deleteBtnClicked:(UIButton *)btn
{
    [self prepareToSaveStatus];
}

- (void)tapGestureEvent:(UITapGestureRecognizer *)tap
{
    [[self class] setActiveElementView:self];
}

- (void)panGestureEvent:(UIPanGestureRecognizer *)pan
{
    [[self class] setActiveElementView:self];
    
    CGPoint p = [pan translationInView:self.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    }
}

- (void)circleViewDidPan:(UIPanGestureRecognizer *)pan
{
    
}

+ (void)setActiveElementView:(PVTBaseElementView*)view
{
    static PVTBaseElementView *activeView = nil;
    if ([view isKindOfClass:NSClassFromString(@"PVTTextView")]) {
        activeView = view;
        [activeView setAvtive:YES];
    } else {
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
    }
    [activeView.superview bringSubviewToFront:activeView];
}

- (void)prepareToSaveStatus
{
    _preData = [NSKeyedArchiver archivedDataWithRootObject:self];
    self.preView = self.superview;
}

- (void)saveStatus
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ElementViewDidSavedNotification" object:@[self,_preData,self.preView]];
}

#pragma mark - getter & setter
- (void)setActive:(BOOL)active
{
    _isActive = active;
    _btnDelete.hidden = !active;
    _btnTransition.hidden = !active;
}

- (BOOL)isActive
{
    return _isActive;
}

- (BOOL)isEnabled:(UIView *)view {
    if (!view.userInteractionEnabled || view.isHidden || view.alpha < 0.01) {
        return NO;
    }
    return YES;
}

- (CGFloat)getScale {
    return _scale;
}

- (void)setArg:(CGFloat)arg {
    _arg = arg;
    [self setScale:[self getScale]];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.transform = CGAffineTransformIdentity;
    _contentView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_contentView.width)) / 2;
    rct.origin.y += (rct.size.height - (_contentView.height)) / 2;
    rct.size.width  = _contentView.width;
    rct.size.height = _contentView.height;
    self.frame = rct;
    
    _contentView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (!self.isActive) {
            return YES;
        }
        return NO;
    }else {
        return _isActive;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL b = [super pointInside:point withEvent:event];
    if (!b) {
        for (UIView *view in self.subviews) {
            b |= CGRectContainsPoint(view.frame, point);
        }
    }
    return b;
}

#pragma mark - 归档解档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:_scale forKey:@"scale"];
    [aCoder encodeFloat:_arg forKey:@"arg"];
    [aCoder encodeFloat:_initialArg forKey:@"initialArg"];
    [aCoder encodeFloat:_initialScale forKey:@"initialScale"];
    //    [aCoder encodeObject:_preView forKey:@"preView"];
    [aCoder encodeCGPoint:_initialPoint forKey:@"initialPoint"];
    [aCoder encodeCGRect:self.frame forKey:@"frame"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scale = [aDecoder decodeFloatForKey:@"scale"];
        self.arg = [aDecoder decodeFloatForKey:@"arg"];
        self.initialArg = [aDecoder decodeFloatForKey:@"initialArg"];
        self.initialScale = [aDecoder decodeFloatForKey:@"initialScale"];
//        self.preView = [aDecoder decodeObjectForKey:@"preView"];
        self.initialPoint = [aDecoder decodeCGPointForKey:@"initialPoint"];
        self.frame = [aDecoder decodeCGRectForKey:@"frame"];
    }
    return self;
}

@end
