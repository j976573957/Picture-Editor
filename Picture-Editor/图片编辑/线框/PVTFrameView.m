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

#pragma mark - getter & setter

- (void)setActive:(BOOL)active
{
    [super setActive:active];
    if (active) {
        _lt.hidden = _rt.hidden = _lb.hidden = _rb.hidden = NO;
    }else{
        _lt.hidden = _rt.hidden = _lb.hidden = _rb.hidden = YES;
    }
}

- (void)setFrameStyle:(PVTFrameStyle *)frameStyle {
    _frameStyle = frameStyle;
    _drawingView.color = _frameStyle.color;
    _drawingView.lineWidth = _frameStyle.lineWidth;
    _drawingView.frameType = _frameStyle.frameType;
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    _drawingView.startPoint = startPoint;
}

- (void)setRect:(CGRect)rect
{
    rect.size.height = MAX(_frameStyle.lineWidth * 2, rect.size.height);
    rect.size.width = MAX(_frameStyle.lineWidth * 2, rect.size.width);
    _rect = rect;
    self.frame = rect;
    
    //如果是画线，得调整一下角标的位置
    [self adjustLineCornerPosition];
    
    _drawingView.size = rect.size;
    _drawingView.center = CGPointMake(_rect.size.width/2., _rect.size.height/2.);
    [_drawingView setNeedsDisplay];
}

//如果是画线，得调整一下角标的位置
- (void)adjustLineCornerPosition
{
    if (_frameStyle.frameType != PVTFrameTypeLine) {
        return;
    }
    CGFloat lineWidth = _frameStyle.lineWidth;
    CGFloat x = lineWidth;
    CGFloat y = lineWidth;
    CGRect rect = [self convertRect:self.bounds toView:self.superview];
    CGFloat w = rect.size.width - lineWidth;
    CGFloat h = rect.size.height - lineWidth;
    if (CGRectGetMaxX(rect) > _startPoint.x + lineWidth) {
        x = w;
        w = lineWidth;
    }
    if (CGRectGetMaxY(rect) > _startPoint.y + lineWidth) {
        y = h;
        h = lineWidth;
    }
    _rt.center = CGPointMake(x, y);
    _lb.center = CGPointMake(w, h);
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
    CGFloat lineWidth = _lineWidth;
    UIColor *color = _color;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    if (_frameType == PVTFrameTypeEllipse) {
        CGPathAddEllipseInRect(path, NULL, CGRectInset(rect, lineWidth * .5, lineWidth * .5));
    }else if (_frameType == PVTFrameTypeRect) {
        CGPathAddRect(path, NULL, CGRectInset(rect, lineWidth * .5, lineWidth * .5));
    }else if (_frameType == PVTFrameTypeRoundRect) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, lineWidth * .5, lineWidth * .5) cornerRadius:0];
        bezierPath.lineWidth = lineWidth;
        bezierPath.lineCapStyle = kCGLineCapRound;
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        CGPathAddPath(path, NULL, bezierPath.CGPath);
    }else if (_frameType == PVTFrameTypeLine) {
        CGFloat x = lineWidth;
        CGFloat y = lineWidth;
        rect = [self convertRect:rect toView:self.superview.superview];
        CGFloat w = rect.size.width - lineWidth;
        CGFloat h = rect.size.height - lineWidth;
        NSLog(@"pre_rect = (%f, %f, %f, %f) ", x, y, w, h);
        if (CGRectGetMaxX(rect) > (_startPoint.x + lineWidth)) {
            x = w;
            w = lineWidth;
        }
        if (CGRectGetMaxY(rect) > (_startPoint.y + lineWidth)) {
            y = h;
            h = lineWidth;
        }
        NSLog(@"_startPoint = (%f, %f) ", _startPoint.x, _startPoint.y);

        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, w, h);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
    }else if (_frameType == PVTFrameTypeFillRect) {
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        return;
    }
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
}

@end
