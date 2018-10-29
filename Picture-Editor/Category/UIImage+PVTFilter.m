//
//  UIImage+PVTFilter.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UIImage+PVTFilter.h"
#import <GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@implementation UIImage (PVTFilter)

- (void)filter:(NSInteger)type completion:(void (^)(UIImage *filterImage))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self filter:type];
        if (!image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(self);
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image);
                }
            });
        }
    });
}

- (UIImage *)filter:(NSInteger)type
{
    GPUImagePicture *stillImageSource = nil;
    //获取数据源
    stillImageSource = [[GPUImagePicture alloc] initWithImage:self];
    
    switch (type) {
        case 0:
        {
            GPUImageBeautifyFilter *passthroughFilter = [[GPUImageBeautifyFilter alloc] init];
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 1:
        {
            GPUImageFilter *passthroughFilter = nil;
            //中间突出 四周暗
            passthroughFilter = [GPUImageVignetteFilter new];
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 2:
        {
            //红
            GPUImageRGBFilter *passthroughFilter = nil;
            passthroughFilter = [GPUImageRGBFilter new];
            
            passthroughFilter.red = 0.9;
            
            passthroughFilter.green = 0.8;
            
            passthroughFilter.blue = 0.9;
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
            
        case 3:
        {
            //蓝
            GPUImageRGBFilter *passthroughFilter = [GPUImageRGBFilter new];
            
            passthroughFilter.red = 0.8;
            
            passthroughFilter.green = 0.8;
            
            passthroughFilter.blue = 0.9;
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 4:
        {
            //绿
            GPUImageRGBFilter *passthroughFilter = [GPUImageRGBFilter new];
            
            passthroughFilter.red = 0.8;
            
            passthroughFilter.green = 0.9;
            
            passthroughFilter.blue = 0.8;
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 5:
        {
            //怀旧
            GPUImageSepiaFilter *passthroughFilter = [GPUImageSepiaFilter new];
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 6:
        {
            //朦胧加暗
            GPUImageHazeFilter *passthroughFilter = [GPUImageHazeFilter new];
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 7:
        {
            //饱和
            GPUImageSaturationFilter *passthroughFilter = [GPUImageSaturationFilter new];
            
            passthroughFilter.saturation = 1.5;
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 8:
        {
            //亮度
            //创建一个亮度的滤镜
            GPUImageBrightnessFilter *passthroughFilter = [GPUImageBrightnessFilter new];
            
            passthroughFilter.brightness = 0.2;
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 9:
        {
            //曝光度
            //创建一个亮度的滤镜
            GPUImageExposureFilter *passthroughFilter = [GPUImageExposureFilter new];
            
            passthroughFilter.exposure = 0.15;
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 10:
        {
            //素描
            GPUImageSketchFilter *passthroughFilter = [GPUImageSketchFilter new];
            
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
        }
        case 11:
        {
            //卡通
            GPUImageSmoothToonFilter *passthroughFilter = [GPUImageSmoothToonFilter new];
            
            passthroughFilter.blurRadiusInPixels = 0.5;
            [passthroughFilter useNextFrameForImageCapture];
            [stillImageSource addTarget:passthroughFilter];
            [stillImageSource processImage];
            UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
            return finallImage;
            
        }
        default:
            return self;
    }
}


- (UIImage *)thumbWithWidth:(CGFloat)width
{
    if (width > self.size.width) {
        return self;
    }
    CGFloat scale = self.size.width / self.size.height;
    CGSize newImageSize = CGSizeMake(width, width / scale);
    CGRect newRect = (CGRect){{0,0},newImageSize};
    UIGraphicsBeginImageContext(newImageSize);
    //法1.
//    [self drawInRect:newRect];
    //法2.
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ref, 0, newImageSize.height);
    CGContextScaleCTM(ref, 1.0, -1.0);
    CGContextDrawImage(ref, newRect, self.CGImage);
    
    //取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)gaussianBlur:(CGFloat)blur {
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = blur;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:self];
    return blurredImage;
}


@end
