//
//  PVTBaseStyle.h
//  Picture-Editor
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVTBaseStyle : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *name;

+ (NSArray <PVTBaseStyle*>*)defaultStyles;

@end
