//
//  PVTFrameStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTBaseStyle.h"

typedef NS_ENUM(NSUInteger, PVTFrameType) {
    PVTFrameTypeRect,
    PVTFrameTypeRoundRect,
    PVTFrameTypeEllipse,
    PVTFrameTypeLine,
    PVTFrameTypeFillRect
};


@interface PVTFrameStyle : PVTBaseStyle

@property (nonatomic, assign) PVTFrameType frameType;
@property (nonatomic, assign) NSInteger lineLevel;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *color;

@end
