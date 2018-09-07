//
//  PVTEditorViewController.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PVTImageEditMode) {
    PVTImageEditModeNone,
    PVTImageEditModeFilter,
    PVTImageEditModeFrame,
};

@interface PVTEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end
