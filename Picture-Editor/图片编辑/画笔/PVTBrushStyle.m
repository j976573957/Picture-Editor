//
//  PVTBrushStyle.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/26.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBrushStyle.h"

@implementation PVTBrushStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.strokeColor = [UIColor redColor];
    }
    return self;
}

+ (NSArray <PVTBrushStyle*>*)defaultTypes {
    static NSMutableArray *styles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            PVTBrushStyle *style = [[PVTBrushStyle alloc] init];
            style.lineStyle = i;
            [styles addObject:style];
        }
    });
    return styles;
}

- (void)setLineStyle:(PVTBrushLineStyle)lineStyle {
    _lineStyle = lineStyle;
    if (lineStyle == PVTBrushLineStyleBold) {
        self.icon = [UIImage imageNamed:@"huabi_yangshi_2_icon"];
        self.name = @"粗";
    } else if (lineStyle == PVTBrushLineStyleLight) {
        self.icon = [UIImage imageNamed:@"huabi_yangshi_3_icon"];
        self.name = @"细";
    } else if (lineStyle == PVTBrushLineStyleNormal) {
        self.icon = [UIImage imageNamed:@"huabi_yangshi_1_icon"];
        self.name = @"普通";
    } else if (lineStyle == PVTBrushLineStyleDashed) {
        self.icon = [UIImage imageNamed:@"huabi_yangshi_4_icon"];
        self.name = @"虚线";
    } else if (lineStyle == PVTBrushLineStyleSplit) {
        self.icon = [UIImage imageNamed:@"huabi_yangshi_5_icon"];
        self.name = @"分割线";
    }
}


@end
