//
//  UICollectionViewCell+PVTExtra.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UICollectionViewCell+PVTExtra.h"
#import <objc/runtime.h>

@implementation UICollectionViewCell (PVTExtra)

char selectedKey;

+ (void)load
{
    Method m1 = class_getInstanceMethod(self, @selector(setSelected:));
    Method m2 = class_getInstanceMethod(self, @selector(setSelected2:));
    method_exchangeImplementations(m1, m2);
}

- (void (^)(BOOL))selectedCallBack
{
    return objc_getAssociatedObject(self, &selectedKey);
}

- (void)setSelectedCallBack:(void (^)(BOOL))selected
{
    objc_setAssociatedObject(self, &selectedKey, selected, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setSelected2:(BOOL)selected
{
    [self setSelected2:selected];
    if (selected) {
        if(self.selectedCallBack){
            self.selectedCallBack(selected);
        }
    }
}

@end
