//
//  PVTArrowMenuView.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"
#import "PVTArrowStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTArrowMenuView : PVTToolsBaseView
{
@public
    PVTArrowStyle *arrowStyle;
}


@property (nonatomic, copy) void (^preferredStyle)(PVTArrowStyle *style);

@end

NS_ASSUME_NONNULL_END
