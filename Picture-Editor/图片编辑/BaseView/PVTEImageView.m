//
//  PVTEImageView.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTEImageView.h"

@implementation PVTEImageView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (!view && [self isEnabled:self]) {
//        for (UIView *_view in self.subviews) {
//            if (CGRectContainsPoint(_view.frame, point) && [self isEnabled:_view]) {
//                view = _view;
//                break;
//            }
//        }
//    }
//    return view;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL b = [super pointInside:point withEvent:event];
    if (!b) {
        for (UIView *view in self.subviews) {
            point = [view convertPoint:point fromView:self];
            b |= [view pointInside:point withEvent:event];
        }
    }
    return b;
}

//- (BOOL)isEnabled:(UIView *)view {
//    if (!view.userInteractionEnabled || view.isHidden || view.alpha < 0.01) {
//        return NO;
//    }
//    return YES;
//}

@end
