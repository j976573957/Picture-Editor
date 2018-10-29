//
//  PVTBrushMenu.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/29.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"
#import "PVTBrushStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTBrushMenuView : PVTToolsBaseView

@property (nonatomic, copy) void (^preStep)(void);
@property (nonatomic, copy) void (^preferredStyle)(PVTBrushStyle *style);
@property (nonatomic, copy) void (^nextStep)(void);

@end

NS_ASSUME_NONNULL_END
