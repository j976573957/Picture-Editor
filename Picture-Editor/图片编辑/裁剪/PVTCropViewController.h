//
//  PVTCropViewController.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOCropViewController.h"

@interface PVTCropViewController : UIViewController

@property (nonatomic, weak) id<TOCropViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL keepCropAspectRatio;
@property (nonatomic, assign) CGSize cropAspectRatio;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) CGRect imageCropRect;

@end
