//
//  PVTMosicStyle.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/11.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTMosicStyle.h"


@implementation PVTMosicStyle

+ (NSArray *)defaultStyles {
    static NSMutableArray *styles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MosaicStyle" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array) {
            PVTMosicStyle *style = [PVTMosicStyle new];
            style.image = [UIImage imageNamed:dic[@"image"]];
            style.icon = [UIImage imageNamed:dic[@"icon"]];
            style.blur = dic[@"blur"];
            [styles addObject:style];
        }
    });
    return styles;
}

+ (NSArray <PVTMosicStyle*>*)defaultTypes {
    static NSMutableArray *styles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styles = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            PVTMosicStyle *style = [[PVTMosicStyle alloc] init];
            style.mosaicType = i;
            [styles addObject:style];
        }
    });
    return styles;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _strokeColor = [UIColor colorWithPatternImage:image];
}

- (void)setMosaicType:(PVTMosaicType)mosaicType {
    _mosaicType = mosaicType;
    if (mosaicType == PVTMosaicTypeArc) {
        self.icon = [UIImage imageNamed:@"masaike_tumo_2_icon"];
        self.name = @"椭圆";
    } else if (mosaicType == PVTMosaicTypePath) {
        self.icon = [UIImage imageNamed:@"masaike_tumo_1_icon"];
        self.name = @"涂抹";
    } else {
        self.icon = [UIImage imageNamed:@"masaike_tumo_3_icon"];
        self.name = @"方形";
    }
}

@end
