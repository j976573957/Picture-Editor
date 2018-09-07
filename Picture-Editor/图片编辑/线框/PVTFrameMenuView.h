//
//  PVTFrameMenuView.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"
#import "PVTFrameStyle.h"

@interface PVTFrameMenuView : PVTToolsBaseView
{
    @public
    PVTFrameStyle *frameStyle;
}

@property (nonatomic, copy) void (^preferredStyle)(PVTFrameStyle *style);

@end
