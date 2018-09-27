//
//  PVTArrowStyle.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTArrowStyle.h"

@implementation PVTArrowStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.color = RedColor;
    }
    return self;
}


+ (NSArray *)defaultStyles
{
    static NSMutableArray *styles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in array) {
            PVTArrowStyle *style = [PVTArrowStyle new];
            NSError *error;
            NSString *path = [[NSBundle mainBundle] pathForResource:dict[@"svg"] ofType:@"svg"];
            NSString *svg = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            style.headSvg = svg;
            style.icon = [UIImage imageNamed:dict[@"icon"]];
            style.offset = [dict[@"offset"] floatValue];
            style.inOffset = [dict[@"inoffset"] floatValue];
            style.tail = [dict[@"head"] floatValue];
            style.head = [dict[@"tail"] floatValue];
            style.lineCap = dict[@"lineCap"];
            style.lineJoin = dict[@"lineJoin"];
            style.lineWidth = [dict[@"lineWidth"] floatValue];
            if (!style.lineCap.length) {
                style.lineCap = @"butt";
            }
            if (!style.lineJoin.length) {
                style.lineJoin = @"miter";
            }
            if (style.lineWidth == 0) {
                style.lineWidth = 1.;
            }
            
            [styles addObject:style];
        }
    });
    return styles;
}

@end
