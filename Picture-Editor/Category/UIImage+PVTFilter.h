//
//  UIImage+PVTFilter.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PVTFilter)

- (void)filter:(NSInteger)type completion:(void (^)(UIImage *filterImage))completion;

- (UIImage *)thumbWithWidth:(CGFloat)width;

/** 高斯模糊 */
- (UIImage *)gaussianBlur:(CGFloat)blur;

@end
