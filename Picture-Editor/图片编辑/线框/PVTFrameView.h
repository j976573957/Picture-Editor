//
//  PVTFrameView.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTBaseElementView.h"
#import "PVTFrameStyle.h"

@interface PVTFrameView : PVTBaseElementView

@property (nonatomic, copy) PVTFrameStyle *frameStyle;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGPoint startPoint;

@end
