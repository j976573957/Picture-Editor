//
//  UICollectionViewCell+PVTExtra.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (PVTExtra)

@property (nonatomic, copy) void(^selectedCallBack)(BOOL selected);

@end
