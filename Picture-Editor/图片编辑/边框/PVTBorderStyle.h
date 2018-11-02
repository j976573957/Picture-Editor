//
//  PVTBorderStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/11/1.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBaseStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTBorderStyle : PVTBaseStyle

@property (nonatomic, strong) UIImage *image;
+ (NSArray *)defaultStyles;

@end

NS_ASSUME_NONNULL_END
