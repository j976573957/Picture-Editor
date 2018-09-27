//
//  UIColor+WTHexColor.h
//  wetool
//
//  Created by alas on 2017/7/11.
//  Copyright © 2017年 alas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WTHexColor)

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;

+ (NSArray *)availableColors;

@end
