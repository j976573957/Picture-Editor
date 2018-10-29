//
//  PVTBrushStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/26.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBaseStyle.h"

typedef NS_ENUM(NSUInteger, PVTBrushLineStyle) {
    PVTBrushLineStyleNormal,
    PVTBrushLineStyleBold,   //粗
    PVTBrushLineStyleLight,  //细
    PVTBrushLineStyleDashed, //虚线
    PVTBrushLineStyleSplit,  //分割线
};

NS_ASSUME_NONNULL_BEGIN

@interface PVTBrushStyle : PVTBaseStyle


@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic) PVTBrushLineStyle lineStyle;

@property (assign, nonatomic, getter=isEraser) BOOL eraser; //橡皮擦
@property (assign, nonatomic, getter=isHighlighter) BOOL highlighter;   //荧光笔

+ (NSArray <PVTBrushStyle*>*)defaultTypes;

@end

NS_ASSUME_NONNULL_END
