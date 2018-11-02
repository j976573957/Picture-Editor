//
//  PVTImageScrollView.m
//  Picture-Editor
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTImageScrollView.h"
#import "PVTBaseElementView.h"


@implementation PVTImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.contentSize = self.bounds.size;
    _scrollView.delegate = self;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _imageView = [[PVTEImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.userInteractionEnabled = YES;
    
    _mosaicView = [[PVTMosicView alloc] initWithFrame:_imageView.bounds];
    _mosaicView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _brushView = [[PVTBrushView alloc] initWithFrame:_imageView.bounds];
    _brushView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _borderView = [[PVTBorderView alloc] initWithFrame:CGRectInset(_imageView.bounds, -.5, -.5)];
    _borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_scrollView];
    [_scrollView addSubview:_imageView];
    [_imageView addSubview:_mosaicView];
    [_imageView addSubview:_brushView];
    [_imageView addSubview:_borderView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
    tap.delaysTouchesBegan = YES;
    [self addGestureRecognizer:tap];
    
}

- (void)tapGestureEvent
{
    [self endEditing:YES];
    [PVTBaseElementView setActiveElementView:nil];
}

- (UIImage *)screenshot
{
    CGSize size = self.imageView.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    CGFloat scale = imageSize.width/size.width*self.imageView.image.scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
    if (image) {
        _scrollView.contentSize = self.scrollView.bounds.size;
        
        CGSize size = image.size;
        CGSize viewSize = self.scrollView.bounds.size;
        CGFloat standard = ScreenWidth/(ScreenHeight - 64 - 49);
        CGFloat wDivH = size.width/size.height;
        if (wDivH >= standard) {
            size = CGSizeMake(viewSize.width, viewSize.width/wDivH);
        } else {
            size = CGSizeMake(viewSize.height*wDivH, viewSize.height);
        }
        _imageView.frame = CGRectMake((viewSize.width-size.width)/2., (viewSize.height-size.height)/2., size.width, size.height);
    }
}

- (UIImage *)image {
    return self.imageView.image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale animated:NO];
}

@end
