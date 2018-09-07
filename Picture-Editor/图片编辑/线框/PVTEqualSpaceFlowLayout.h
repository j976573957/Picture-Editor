//
//  PVTEqualSpaceFlowLayout.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PVTAlignType) {
    PVTAlignTypeLeft,
    PVTAlignTypeCenter,
    PVTAlignTypeRight,
    PVTAlignTypeNatural,
};

@interface PVTEqualSpaceFlowLayout : UICollectionViewFlowLayout

//两个Cell之间的距离
@property (nonatomic, assign) CGFloat itemSpace;
/** cell的对齐方式 */
@property (nonatomic, assign) PVTAlignType cellType;
- (instancetype)initWthType:(PVTAlignType)cellType;

@end
