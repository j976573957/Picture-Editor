//
//  PVTMosicView.h
//  Picture-Editor
//
//  Created by Mac on 2018/10/11.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVTMosicStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTMosicView : UIView

@property (nonatomic, strong) PVTMosicStyle *mosaicStyle;
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) NSMutableArray *revokePaths;

- (void)revoke;
- (void)recovery;

@end

NS_ASSUME_NONNULL_END
