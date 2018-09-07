//
//  PVTFilter.m
//  Picture-Editor
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PVTFilter.h"

NSString *const kGPUImageScaleFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 void main() {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     
 });

@implementation PVTFilter

@end


