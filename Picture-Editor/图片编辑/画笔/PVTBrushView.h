//
//  PVTBrushView.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/26.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVTBrushStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTBrushView : UIView

@property (strong, nonatomic) PVTBrushStyle *brushStyle;
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) NSMutableArray *revokePaths;

- (void)revoke;
- (void)recovery;

@end

NS_ASSUME_NONNULL_END
