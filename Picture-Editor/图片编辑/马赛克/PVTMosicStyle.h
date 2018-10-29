//
//  PVTMosicStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/11.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBaseStyle.h"

typedef NS_ENUM(NSUInteger, PVTMosaicType) {
    PVTMosaicTypePath,
    PVTMosaicTypeArc,
    PVTMosaicTypeRect,
};

NS_ASSUME_NONNULL_BEGIN

@interface PVTMosicStyle : PVTBaseStyle

@property (nonatomic) PVTMosaicType mosaicType;
@property (nonatomic, strong) NSNumber *blur;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIBezierPath *bezierPath;

@property (assign, nonatomic, getter=isEraser) BOOL eraser; //橡皮擦
@property (nonatomic, strong, readonly) UIColor *strokeColor;

+ (NSArray <PVTMosicStyle*>*)defaultTypes;
+ (NSArray <PVTMosicStyle*>*)defaultStyles;

@end

NS_ASSUME_NONNULL_END
