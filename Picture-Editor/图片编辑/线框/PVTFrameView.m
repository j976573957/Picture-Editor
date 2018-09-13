//
//  PVTFrameView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTFrameView.h"

@interface FrameDrawingView : UIView

@property (nonatomic) PVTFrameType frameType;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGPoint startPoint;

@end

@interface PVTFrameView ()
{
    FrameDrawingView *_drawingView;
    UIImageView *_lt;
    UIImageView *_rt;
    UIImageView *_lb;
    UIImageView *_rb;
    
}


@end

@implementation PVTFrameView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [_btnTransition removeFromSuperview];
        //线框
        _drawingView = [[FrameDrawingView alloc] initWithFrame:_contentView.bounds];
        _drawingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _drawingView.backgroundColor = [UIColor clearColor];
        [self addSubview:_drawingView];

        //四角图片
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            iv.image = [UIImage imageNamed:@"jig_move"];
            [self addSubview:iv];
            [iv addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
            iv.userInteractionEnabled = YES;
            [imageViews addObject:iv];
        }
        _lt = imageViews[0];
        _rt = imageViews[1];
        _lb = imageViews[2];
        _rb = imageViews[3];
    
        _lt.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _rt.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        _lb.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _rb.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        _lt.center = CGPointZero;
        _rt.center = CGPointMake(self.width, 0);
        _lb.center = CGPointMake(0, self.height);
        _rb.center = CGPointMake(self.width, self.height);
        
        [_lt removeFromSuperview];
        [_rb removeFromSuperview];
        
    }
    return self;
}

- (void)setAvtive:(BOOL)active
{
    [super setAvtive:active];
    if (active) {
        _lt.hidden = _rt.hidden = _lb.hidden = _rb.hidden = NO;
    }else{
        _lt.hidden = _rt.hidden = _lb.hidden = _rb.hidden = YES;
    }
}

#pragma mark - 事件
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint p = [pan locationInView:self.superview];
    UIView *av = pan.view;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self prepareToSaveStatus];
        CGPoint point = CGPointZero;
        if (_lt == av) {
            point = [self convertPoint:_rb.center toView:self.superview];
        }else if (_rt == av) {
            point = [self convertPoint:_lb.center toView:self.superview];
        }else if (_lb == av) {
            point = [self convertPoint:_rt.center toView:self.superview];
        }else if (_rb == av) {
            point = [self convertPoint:_lt.center toView:self.superview];
        }
        self.startPoint = point;
    }else {
        CGRect rect = [self rectWithPoint:self.startPoint p2:p];
        [self setRect:rect];
        if (pan.state == UIGestureRecognizerStateEnded) {
            [self saveStatus];
        }
    }
}

- (CGRect)rectWithPoint:(CGPoint)p1 p2:(CGPoint)p2
{
    CGRect rect = CGRectZero;
    CGFloat w = ABS(p2.x - p1.x);
    CGFloat h = ABS(p2.y - p1.y);
    rect = CGRectMake(MIN(p1.x, p2.x), MIN(p1.y, p2.y), w, h);
    return rect;
}


#pragma mark - 归档解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.rect = [aDecoder decodeCGRectForKey:@"rect"];
        self.startPoint = [aDecoder decodeCGPointForKey:@"startPoint"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeCGRect:self.rect forKey:@"rect"];
    [aCoder encodeCGPoint:self.startPoint forKey:@"startPoint"];
}


@end

#pragma mark - FrameDrawingView
@implementation FrameDrawingView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
