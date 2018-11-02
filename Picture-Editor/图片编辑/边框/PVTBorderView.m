//
//  PVTBorderView.m
//  Picture-Editor
//
//  Created by Mac on 2018/11/1.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "PVTBorderView.h"

@implementation PVTBorderView
{
    NSData *preData;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage *image = [aDecoder decodeObjectForKey:@"image"];
        [self setImage2:image];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.image forKey:@"image"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [self prepare2SaveState];
    [super setImage:image];
    [self saveState];
}

- (void)setImage2:(UIImage *)image {
    [super setImage:image];
}

- (void)setBorderStyle:(PVTBorderStyle *)borderStyle {
    _borderStyle = borderStyle;
    self.image = borderStyle.image;
}

- (void)prepare2SaveState {
    self->preData = [NSKeyedArchiver archivedDataWithRootObject:self];
    self.preView = self;
}

- (void)saveState {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ElementViewDidSavedNotification" object:@[self,self->preData,self.preView]];
}

- (void)restoreState:(PVTBorderView*)x superView:(UIView *)superView {
    [self setImage2:x.image];
}


@end
