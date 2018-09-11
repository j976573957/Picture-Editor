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
        [_btnDelete addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDelete];
        
        //
        _btnTransition = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTransition.frame = CGRectMake(self.width-10, self.height-10, 34, 34);
        [_btnTransition setImage:[UIImage imageNamed:@"gj_bianji_xuanzhuan_icon"] forState:UIControlStateNormal];
        _btnTransition.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [_btnTransition addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
        [self addSubview:_btnTransition];
        
//        [self awakeFromNib];
//        [self initGestures];
        
    }
    return self;
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
