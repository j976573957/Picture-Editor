//
//  PVTStickerStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTBaseStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTStickerStyle : PVTBaseStyle

@property (nonatomic, strong) UIImage *image;

+ (NSArray <PVTStickerStyle*>*)defaultStyles;

@end

NS_ASSUME_NONNULL_END
