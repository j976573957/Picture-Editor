//
//  PVTBorderView.h
//  Picture-Editor
//
//  Created by Mac on 2018/11/1.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVTBorderStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTBorderView : UIImageView

@property (nonatomic, strong) PVTBorderStyle *borderStyle;

@property (nonatomic, weak) UIView *preView;

- (void)prepare2SaveState;
- (void)saveState;
- (void)restoreState:(PVTBorderView*)x superView:(UIView *)superView;


@end

NS_ASSUME_NONNULL_END
