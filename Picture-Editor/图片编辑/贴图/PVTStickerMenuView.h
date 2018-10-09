//
//  PVTStickerMenuView.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"
#import "PVTStickerStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTStickerMenuView : PVTToolsBaseView

@property (nonatomic, copy) void (^preferredStyle)(PVTStickerStyle *style);

@end

NS_ASSUME_NONNULL_END
