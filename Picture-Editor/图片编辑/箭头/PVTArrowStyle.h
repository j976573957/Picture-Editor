//
//  PVTArrowStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTBaseStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PVTArrowStyle : PVTBaseStyle

@property (nonatomic, copy) NSString *headSvg; /** 头部图标 */
@property (nonatomic) CGFloat offset;  //头部
@property (nonatomic) CGFloat inOffset; //尾部
@property (nonatomic) CGFloat head;   //顶部宽度
@property (nonatomic) CGFloat tail;    //底部宽度
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *lineCap;
@property (nonatomic, copy) NSString *lineJoin;
@property (nonatomic) CGFloat lineWidth;

+ (NSArray*)defaultStyles;

@end

NS_ASSUME_NONNULL_END
