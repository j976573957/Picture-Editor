//
//  PVTSelectPictureViewController.h
//  Picture-Editor
//
//  Created by Mac on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PVTSelectType) {
    PVTSelectTypeSingle,
    PVTSelectTypeMultiple,
};

@interface PVTSelectPictureViewController : UICollectionViewController

@property (nonatomic, assign) PVTSelectType selectType;
/** 多选，默认 9 */
@property (nonatomic, assign) NSInteger limit;

@end
