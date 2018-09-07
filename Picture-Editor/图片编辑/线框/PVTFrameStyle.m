//
//  PVTFrameStyle.m
//  Picture-Editor
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTFrameStyle.h"


@implementation PVTFrameStyle

- (id)init
{
    if (self = [super init]) {
        self.frameType = PVTFrameTypeRect;
        self.lineWidth = 5;
        self.color = RedColor;
    }
    return self;
}



@end
