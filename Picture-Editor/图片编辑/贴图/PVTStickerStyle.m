//
//  PVTStickerStyle.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTStickerStyle.h"

@implementation PVTStickerStyle

+ (instancetype)stickerWithImage:(UIImage *)image {
    PVTStickerStyle *sticker = [[PVTStickerStyle alloc] init];
    sticker.image = image;
    return sticker;
}

+ (NSArray *)defaultStyles {
    static NSMutableArray *styles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"StickerStyle" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array) {
            PVTStickerStyle *style = [PVTStickerStyle new];
            style.image = [UIImage imageNamed:dic[@"image"]];
            style.icon = [UIImage imageNamed:dic[@"icon"]];
            [styles addObject:style];
        }
    });
    return styles;
}

@end
