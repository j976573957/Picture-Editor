//
//  PVTImageScrollView.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVTEImageView.h"
#import "PVTMosicView.h"
#import "PVTBrushView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTImageScrollView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PVTEImageView *imageView;
@property (nonatomic, strong) PVTBrushView *brushView;
@property (nonatomic, strong) PVTMosicView *mosaicView;
//@property (nonatomic, strong) PVTBorderView *borderView;

- (void)setImage:(UIImage *)image;  //传入image
- (UIImage *)image; //画完之后取image
- (UIImage *)screenshot;

@end

NS_ASSUME_NONNULL_END
