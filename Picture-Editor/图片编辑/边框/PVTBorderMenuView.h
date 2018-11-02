//
//  PVTBorderMenuView.h
//  Picture-Editor
//
//  Created by Mac on 2018/11/1.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"
#import "PVTBorderStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTBorderMenuView : PVTToolsBaseView

@property (nonatomic, copy) void (^preferredStyle)(PVTBorderStyle *style);

@end

NS_ASSUME_NONNULL_END
