//
//  PVTArrowView.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTBaseElementView.h"
#import "PVTArrowStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTArrowView : PVTBaseElementView

@property (nonatomic, strong) PVTArrowStyle *arrowStyle;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat h;

@end

NS_ASSUME_NONNULL_END
