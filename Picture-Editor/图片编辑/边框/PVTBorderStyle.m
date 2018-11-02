//
//  PVTBorderStyle.m
//  Picture-Editor
//
//  Created by Mac on 2018/11/1.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBorderStyle.h"

@implementation PVTBorderStyle

+ (instancetype)borderStyleWithImage:(UIImage *)image {
    PVTBorderStyle *style = [PVTBorderStyle new];
    style.image = image;
    return style;
}

- (void)save {
    NSMutableArray *styles = [PVTBorderStyle savedBorders];
    if (!styles) {
        styles = [NSMutableArray array];
    }
    [styles insertObject:self atIndex:0];
    [PVTBorderStyle saveBorders:styles];
}

+ (NSString *)savePath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documents[0] stringByAppendingPathComponent:@"Borders"];
}

+ (NSMutableArray *)savedBorders {
    NSArray *QRCodes = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savePath]];
    return QRCodes.mutableCopy;
}

+ (void)saveBorders:(NSArray *)array {
    [NSKeyedArchiver archiveRootObject:array toFile:[self savePath]];
}

+ (NSArray *)defaultStyles {
    static NSMutableArray *styles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BorderStyle" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array) {
            PVTBorderStyle *style = [PVTBorderStyle new];
            style.image = [UIImage imageNamed:dic[@"image"]];
            style.icon = [UIImage imageNamed:dic[@"icon"]];
            [styles addObject:style];
        }
    });
    return styles;
}

@end
