//
//  PVTStickerView.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTStickerView.h"

@implementation PVTStickerView
{
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.allowsEdgeAntialiasing = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setStickerStyle:(PVTStickerStyle *)stickerStyle {
    _stickerStyle = stickerStyle;
    _imageView.image = stickerStyle.image;
    CGSize size =  CGSizeApplyAffineTransform(stickerStyle.image.size, CGAffineTransformMakeScale(.5, .5));
    self.size = size;
    _contentView.size = self.size;
}

@end
