//
//  PVTBrushView.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/26.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBrushView.h"

@interface BrushPathModel : NSObject
{
@public
    CGMutablePathRef path;
    CGFloat linewidth;
    UIColor *strokeColor;
    CGBlendMode blendMode;
    BOOL highlighter;
    PVTBrushLineStyle lineStyle;
}

- (instancetype)initWithLineStyle:(PVTBrushLineStyle)style strokeColor:(UIColor *)color blendMode:(CGBlendMode)mode startPoint:(CGPoint)point;
- (void)moveTo:(CGPoint)point;

@end


@implementation PVTBrushView
{
    BrushPathModel *currentModel;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //    self.multipleTouchEnabled = NO;
    
    self.paths = [NSMutableArray array];
    self.revokePaths = [NSMutableArray array];
}

- (void)setBrushStyle:(PVTBrushStyle *)brushStyle {
    _brushStyle = brushStyle;
}

#pragma mark - touch event
//触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch=[touches anyObject];
    CGPoint point =  [touch locationInView:touch.view];
    UIColor *color = self.brushStyle.isEraser ? [UIColor clearColor] : self.brushStyle.strokeColor;
    CGBlendMode mode = self.brushStyle.isEraser ? kCGBlendModeClear : kCGBlendModeNormal;
    PVTBrushLineStyle lineStyle = self.brushStyle.isEraser ? PVTBrushLineStyleNormal : self.brushStyle.lineStyle;
    currentModel = [[BrushPathModel alloc] initWithLineStyle:lineStyle strokeColor:color blendMode:mode startPoint:point];
    currentModel->highlighter = self.brushStyle.isHighlighter;
}
//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    [currentModel moveTo:point];
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self mutableArrayValueForKey:@"paths"] addObject:currentModel];
    [[self mutableArrayValueForKey:@"revokePaths"] removeAllObjects];
    [self setNeedsDisplay];
    currentModel = nil;
}


- (void)revoke {
    id path = self.paths.lastObject;
    if (path) {
        [[self mutableArrayValueForKey:@"revokePaths"] addObject:path];
        [[self mutableArrayValueForKey:@"paths"] removeLastObject];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    for (BrushPathModel *BrushPathModel in self.paths) {
        if (BrushPathModel->highlighter) {
            CGContextSetShadowWithColor(c, CGSizeZero, 5, BrushPathModel->strokeColor.CGColor);
            CGContextSetStrokeColorWithColor(c, [UIColor whiteColor].CGColor);
        } else {
            CGContextSetShadow(c, CGSizeZero, 0);
            CGContextSetStrokeColorWithColor(c, BrushPathModel->strokeColor.CGColor);
        }
        CGFloat w = BrushPathModel->linewidth;
        if (BrushPathModel->lineStyle == PVTBrushLineStyleDashed) {
            CGFloat lengths[] = {w,w};
            CGContextSetLineDash(c, 0, lengths, 2);
        } else if (BrushPathModel->lineStyle == PVTBrushLineStyleSplit) {
            CGFloat lengths[] = {5*w,w,w*2,w};
            CGContextSetLineDash(c, 0, lengths, 4);
        } else {
            CGContextSetLineDash(c, 0, 0, 0);
        }
        CGContextSetBlendMode(c, BrushPathModel->blendMode);
        CGContextAddPath(c, BrushPathModel->path);
        
        CGContextSetLineWidth(c, BrushPathModel->linewidth);
        CGContextDrawPath(c, kCGPathStroke);
    }
    if (currentModel) {
        if (currentModel->highlighter) {
            CGContextSetShadowWithColor(c, CGSizeZero, 5, currentModel->strokeColor.CGColor);
            CGContextSetStrokeColorWithColor(c, [UIColor whiteColor].CGColor);
        } else {
            CGContextSetShadow(c, CGSizeZero, 0);
            CGContextSetStrokeColorWithColor(c, currentModel->strokeColor.CGColor);
        }
        CGFloat w = currentModel->linewidth;
        if (currentModel->lineStyle == PVTBrushLineStyleDashed&& !self.brushStyle.isEraser) {
            CGFloat lengths[] = {w,w};
            CGContextSetLineDash(c, 0, lengths, 2);
        } else if (currentModel->lineStyle == PVTBrushLineStyleSplit&& !self.brushStyle.isEraser) {
            CGFloat lengths[] = {5*w,w,w*2,w};
            CGContextSetLineDash(c, 0, lengths, 4);
        } else {
            CGContextSetLineDash(c, 0, 0, 0);
        }
        CGContextSetBlendMode(c, currentModel->blendMode);
        CGContextAddPath(c, currentModel->path);
        CGContextSetLineWidth(c, currentModel->linewidth);
        CGContextDrawPath(c, kCGPathStroke);
    }
    
}

- (void)recovery {
    id path = self.revokePaths.lastObject;
    if (path) {
        [[self mutableArrayValueForKey:@"paths"] addObject:path];
        [[self mutableArrayValueForKey:@"revokePaths"] removeLastObject];
    }
    [self setNeedsDisplay];
}

@end

@implementation BrushPathModel

- (instancetype)initWithLineStyle:(PVTBrushLineStyle)style strokeColor:(UIColor *)color blendMode:(CGBlendMode)mode startPoint:(CGPoint)point {
    self = [super init];
    if (self) {
        linewidth = 8;
        if (style == PVTBrushLineStyleBold) {
            linewidth = 12;
        } else if (style == PVTBrushLineStyleLight) {
            linewidth = 4;
        } else if (style == PVTBrushLineStyleNormal) {
            linewidth = 8;
        } else {
            linewidth = 4;
        }
        lineStyle = style;
        strokeColor = color;
        blendMode = mode;
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, point.x, point.y);
    }
    return self;
}

- (void)moveTo:(CGPoint)point {
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
}

- (void)dealloc {
    CGPathRelease(path);
}

@end
