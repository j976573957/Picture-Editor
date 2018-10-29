//
//  PVTMosicMenuView.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/12.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"
#import "PVTMosicStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTMosicMenuView : PVTToolsBaseView

@property (nonatomic, copy) void (^preStep)(void);
@property (nonatomic, copy) void (^preferredStyle)(PVTMosicStyle *style);
@property (nonatomic, copy) void (^nextStep)(void);

@end

NS_ASSUME_NONNULL_END
