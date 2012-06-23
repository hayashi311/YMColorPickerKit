//
//  YMColor.h
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

    /////////////////////////////////////////////////////////////////////////////
    //
    // YMRGBAColor 
    //
    /////////////////////////////////////////////////////////////////////////////
#pragma mark - YMRGBAColor

    typedef struct{
        float r;
        float g;
        float b;
        float a;
    } YMRGBAColor;
    
    YMRGBAColor YMRGBAColorMake(float red,float green,float blue,float alpha);

    /////////////////////////////////////////////////////////////////////////////
    //
    // YMHSVAColor 
    //
    /////////////////////////////////////////////////////////////////////////////
#pragma mark - YMHSVAColor
    
    typedef struct{
        float h;
        float s;
        float v;
    } YMHSVAColor;
    
    YMHSVAColor YMHSVAColorMake(float hue,float saturation,float brightness,float alpha);
    
    /////////////////////////////////////////////////////////////////////////////
    //
    // Convert color 
    //
    /////////////////////////////////////////////////////////////////////////////
#pragma mark - Convert color
    
    YMHSVAColor HSVColorFromRGBColor(const YMRGBAColor);
    YMRGBAColor RGBColorFromHSVColor(const YMHSVAColor);
    
    int HexColorFromRGBColor(const YMRGBAColor*);
    
#ifdef __cplusplus
}
#endif