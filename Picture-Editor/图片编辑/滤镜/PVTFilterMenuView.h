//
//  PVTFilterMenuView.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTToolsBaseView.h"

@interface PVTFilterMenuView : PVTToolsBaseView


@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) void (^preferredFilterID)(NSInteger filterID);

@end
