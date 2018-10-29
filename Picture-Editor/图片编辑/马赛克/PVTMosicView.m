//
//  PVTMosicView.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/11.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTMosicView.h"

@interface MosaicPathModel : NSObject
{
@public
    CGMutablePathRef path;
    CGFloat linewidth;
    CGPoint startPoint;
    
    CGBlendMode blendMode;
    
    PVTMosaicType mosaicType;
}

- (instancetype)initWithStyle:(PVTMosicStyle*)style startPoint:(CGPoint)point;

- (void)moveTo:(CGPoint)point;
- (void)arcTo:(CGPoint)point;
- (void)rectTo:(CGPoint)point;

- (void)translateTo:(CGPoint)point;

@end

@implementation PVTMosicView
{
    MosaicPathModel *currentModel;
    BOOL pathMovable;
    BOOL movePath;
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

#pragma mark - touch event
//触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch=[touches anyObject];
    CGPoint point =  [touch locationInView:touch.view];
    
    if (pathMovable) {
        movePath = NO;
        MosaicPathModel *pathModelForMove = nil;
        for (MosaicPathModel *pathModel in self.paths) {
            if (pathModel->blendMode != kCGBlendModeClear && CGPathContainsPoint(pathModel->path, NULL, point, NO)) {
                movePath = YES;
                pathModelForMove = pathModel;
                break;
            }
        }
        if (pathModelForMove) {
            currentModel = pathModelForMove;
        }
    } else {
        currentModel = [[MosaicPathModel alloc] initWithStyle:self.mosaicStyle startPoint:point];
    }
}
//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    if (movePath) {
        CGPoint point2 = [touch previousLocationInView:touch.view];
        [currentModel translateTo:CGPointMake(point.x-point2.x, point.y-point2.y)];
    } else {
        if (_mosaicStyle.mosaicType == PVTMosaicTypePath || _mosaicStyle.eraser) {
            [currentModel moveTo:point];
        } else if (_mosaicStyle.mosaicType == PVTMosaicTypeArc) {
            [currentModel arcTo:point];
        } else if (_mosaicStyle.mosaicType == PVTMosaicTypeRect) {
            [currentModel rectTo:point];
        }
    }
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (movePath) {
        
    } else {
        [[self mutableArrayValueForKey:@"paths"] addObject:currentModel];
        [[self mutableArrayValueForKey:@"revokePaths"] removeAllObjects];
        [self setNeedsDisplay];
    }
    currentModel = nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    for (MosaicPathModel *pathModel in self.paths) {
        //        CGContextSetShadow(c, CGSizeZero, 0);
        if (pathModel->mosaicType == PVTMosaicTypePath || pathModel->blendMode == kCGBlendModeClear) {
            CGContextSetStrokeColorWithColor(c, _mosaicStyle.strokeColor.CGColor);
        } else {
            CGContextSetFillColorWithColor(c, _mosaicStyle.strokeColor.CGColor);
        }
        CGContextSetBlendMode(c, pathModel->blendMode);
        CGContextAddPath(c, pathModel->path);
        
        if (pathModel->mosaicType == PVTMosaicTypePath || pathModel->blendMode == kCGBlendModeClear) {
            CGContextSetLineWidth(c, pathModel->linewidth);
            CGContextDrawPath(c, kCGPathStroke);
        } else {
            CGContextFillPath(c);
        }
    }
    if (currentModel) {
        //        CGContextSetShadow(c, CGSizeZero, 0);
        if (currentModel->mosaicType == PVTMosaicTypePath || currentModel->blendMode == kCGBlendModeClear) {
            CGContextSetStrokeColorWithColor(c, _mosaicStyle.strokeColor.CGColor);
        } else {
            CGContextSetFillColorWithColor(c, _mosaicStyle.strokeColor.CGColor);
        }
        CGContextSetBlendMode(c, currentModel->blendMode);
        CGContextAddPath(c, currentModel->path);
        
        if (currentModel->mosaicType == PVTMosaicTypePath || currentModel->blendMode == kCGBlendModeClear) {
            CGContextSetLineWidth(c, currentModel->linewidth);
            CGContextDrawPath(c, kCGPathStroke);
        } else {
            CGContextFillPath(c);
        }
    }
}

- (void)revoke {
    id path = self.paths.lastObject;
    if (path) {
        [[self mutableArrayValueForKey:@"revokePaths"] addObject:path];
        [[self mutableArrayValueForKey:@"paths"] removeLastObject];
    }
    [self setNeedsDisplay];
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

@implementation MosaicPathModel

- (instancetype)initWithStyle:(PVTMosicStyle *)style startPoint:(CGPoint)point {
    self = [super init];
    if (self) {
        mosaicType = style.mosaicType;
        startPoint = point;
        linewidth = 20;
        blendMode = style.isEraser ? kCGBlendModeClear : kCGBlendModeNormal;
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, point.x, point.y);
    }
    return self;
}

- (CGRect)rectWithPoint:(CGPoint)p1 p2:(CGPoint)p2 {
    CGFloat w = ABS(p2.x - p1.x);
    CGFloat h = ABS(p2.y - p1.y);
    return CGRectMake(MIN(p1.x, p2.x), MIN(p1.y, p2.y), w, h);
}

#pragma mark -

- (void)moveTo:(CGPoint)point {
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
}

- (void)arcTo:(CGPoint)point {
    CGPathRelease(path);
    path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, [self rectWithPoint:startPoint p2:point]);
}

- (void)rectTo:(CGPoint)point {
    CGPathRelease(path);
    path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, [self rectWithPoint:startPoint p2:point]);
}

#pragma mark -

- (void)translateTo:(CGPoint)point {
    CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x, point.y);
    CGMutablePathRef path2 = CGPathCreateMutableCopyByTransformingPath(path, &transform);
    CGPathRelease(path);
    path = path2;
}

#pragma mark -

- (void)dealloc {
    CGPathRelease(path);
}


@end
