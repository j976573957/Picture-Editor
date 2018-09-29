//
//  PVTArrowView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTArrowView.h"
#import "PocketSVG.h"
#import "SvgEngine.h"

@interface PVTArrowDrawingView : UIView
{
    CAShapeLayer *_svgLayer;
}
@property (nonatomic, strong) PVTArrowStyle *arrowStyle;
@property (nonatomic) CGFloat h;
@end

@implementation PVTArrowView
{
    PVTArrowDrawingView *_drawingView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        [_btnDelete setHidden:YES];
        [_btnTransition removeFromSuperview];
        _btnTransition = nil;
        [_contentView removeFromSuperview];
        
        _drawingView = [[PVTArrowDrawingView alloc] initWithFrame:self.bounds];
        _drawingView.backgroundColor = [UIColor clearColor];
        [self addSubview:_drawingView];
        
        self.arrowStyle = [[PVTArrowStyle defaultStyles] firstObject];
    }
    return self;
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (void)setH:(CGFloat)h {
    _h = h;
    _drawingView.h = h;
}

- (void)setArrowStyle:(PVTArrowStyle *)arrowStyle {
    _arrowStyle = arrowStyle;
    _drawingView.arrowStyle = arrowStyle;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    if (view == nil) {
        if (!self.userInteractionEnabled || self.isHidden || self.alpha < 0.01) {
            return nil;
        }
        if (CGRectContainsPoint(_btnDelete.frame, point) && [self isEnabled:_btnDelete]) {
            return _btnDelete;
        } else if (CGRectContainsPoint(_btnTransition.frame, point) && [self isEnabled:_btnTransition]) {
            return _btnTransition;
        } else if (CGRectContainsPoint(_drawingView.frame, point) && [self isEnabled:_drawingView]) {
            return self;
        }
    }
    return view;
}

- (void)restoreState:(PVTArrowView*)view superView:(UIView *)superView {
    [super restoreState:view superView:superView];
    self.angle = view.angle;
}


#pragma mark - 归档解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.angle = [aDecoder decodeDoubleForKey:@"angle"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:self.angle forKey:@"angle"];
}


@end


#pragma mark - PVTArrowDrawingView
@implementation PVTArrowDrawingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.allowsEdgeAntialiasing = YES;
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}

- (void)setArrowStyle:(PVTArrowStyle *)arrowStyle {
    _arrowStyle = arrowStyle;
    if (_svgLayer) {
        [_svgLayer removeFromSuperlayer];
    }
    
    NSArray *paths = [SVGBezierPath pathsFromSVGString:arrowStyle.headSvg];
    SVGBezierPath *path = [paths firstObject];
    _svgLayer = [[CAShapeLayer alloc] init];
    _svgLayer.allowsEdgeAntialiasing = YES;
    _svgLayer.contentsScale = [UIScreen mainScreen].scale;
    _svgLayer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    _svgLayer.fillColor = arrowStyle.color.CGColor;
    _svgLayer.strokeColor = arrowStyle.color.CGColor;
    _svgLayer.path = path.CGPath;
    _svgLayer.lineWidth = arrowStyle.lineWidth;
    _svgLayer.lineCap = arrowStyle.lineCap;
    _svgLayer.lineJoin = arrowStyle.lineJoin;
    [self.layer addSublayer:_svgLayer];
}

- (void)setH:(CGFloat)h
{
    _h = h;
    self.height = h;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGRect bounds = CGRectZero;
    bounds = CGRectUnion(bounds, CGPathGetBoundingBox(_svgLayer.path));
    _svgLayer.position = CGPointMake(bounds.size.width+1+_arrowStyle.offset, _h + bounds.size.height-_arrowStyle.inOffset);
    _svgLayer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    [CATransaction commit];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat maxHeight = CGRectGetHeight(rect);
    CGFloat topWidth = _arrowStyle.head;
    CGFloat bottomWidth = _arrowStyle.tail;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetWidth(rect)/2-topWidth/2., 0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2+topWidth/2., 0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2+bottomWidth/2., maxHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2-bottomWidth/2., maxHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2-topWidth/2., 0)];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [_arrowStyle.color setFill];
    [path fill];
}


@end
