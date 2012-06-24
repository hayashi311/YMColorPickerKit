//
//  UIColor+YMColor.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "UIColor+YMColor.h"

const int kYMHexColorStringRGBLength = 6;
const int kYMHexColorStringRGBALength = 8;

@implementation UIColor (YMColor)

/////////////////////////////////////////////////////////////////////////////
//
// YMColor from UIColor
//
/////////////////////////////////////////////////////////////////////////////
#pragma mark - YMColor

- (YMRGBAColor)YMRGBAColor
{
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    YMRGBAColor rgba;
    if(CGColorGetNumberOfComponents(self.CGColor) == 2){
        rgba.r = components[0];
        rgba.g = components[0];
        rgba.b = components[0];
        rgba.a = components[1];
    }else{
        rgba.r = components[0];
        rgba.g = components[1];
        rgba.b = components[2];
        rgba.a = components[3];
    }
    return rgba;
}

- (YMHSVAColor)YMHSVAColor
{
    YMRGBAColor rgba = self.YMRGBAColor;
    return YMHSVColorFromRGBColor(rgba);
}

/////////////////////////////////////////////////////////////////////////////
//
// HexColorString(@"#FFFFFF",etc) and UIColor
//
/////////////////////////////////////////////////////////////////////////////
#pragma mark - HexColorString

+ (UIColor*)ym_colorWithHexColorString:(NSString*)hexColorString
{
    NSScanner *colorScanner = [NSScanner scannerWithString:hexColorString];
    unsigned int color;
    [colorScanner scanHexInt:&color];
    
    if (hexColorString.length == kYMHexColorStringRGBLength) {
        CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
        CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
        CGFloat b =  (color & 0x0000FF)       /255.0f;
        return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
    }else if(hexColorString.length == kYMHexColorStringRGBALength){
        CGFloat r = ((color & 0xFF000000) >> 24) /255.0f;
        CGFloat g = ((color & 0x00FF0000) >> 16) /255.0f;
        CGFloat b = ((color & 0x0000FF00) >> 8)  /255.0f;
        CGFloat a =  (color & 0x000000FF)        /255.0f;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

- (NSString*)ym_hexColorString
{
    YMRGBAColor rgba = self.YMRGBAColor;
    if (rgba.a != 1.f) {
        return [NSString stringWithFormat:@"#%08x",YMHexColorFromRGBAColor(rgba)]; 
    }
    return [NSString stringWithFormat:@"#%06x",YMHexColorFromRGBColor(rgba)];
}

- (UIColor*)ym_colorByAddingBrightness:(float)brightness
{
    float brightness_ = fminf(brightness, 1.f);
    brightness_ = fmaxf(brightness_, 0.f);
    
    YMHSVAColor hsva = self.YMHSVAColor;
    float adjustedBrightness = hsva.v + brightness_;
    adjustedBrightness = fminf(adjustedBrightness, 1.f);
    adjustedBrightness = fmaxf(adjustedBrightness, 0.f);
    return [UIColor colorWithHue:hsva.h saturation:hsva.s brightness:adjustedBrightness alpha:hsva.a];
}

@end
