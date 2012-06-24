//
//  YMColor.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColor.h"


YMRGBAColor YMRGBAColorMake(float red,float green,float blue,float alpha)
{
    YMRGBAColor rgba;
    rgba.r = fminf(red, 1.f);
    rgba.r = fmaxf(rgba.r, 0.f);
    
    rgba.g = fminf(green, 1.f);
    rgba.g = fmaxf(rgba.g, 0.f);
    
    rgba.b = fminf(blue, 1.f);
    rgba.b = fmaxf(rgba.b, 0.f);
    
    rgba.a = fminf(alpha, 1.f);
    rgba.a = fmaxf(rgba.a, 0.f);
    
    return  rgba;
}

YMHSVAColor YMHSVAColorMake(float hue,float saturation,float brightness,float alpha)
{
    YMHSVAColor hsva;
    hsva.h = fminf(hue, 1.f);
    hsva.h = fmaxf(hsva.h, 0.f);
    
    hsva.s = fminf(saturation, 1.f);
    hsva.s = fmaxf(hsva.s, 0.f);
    
    hsva.v = fminf(brightness, 1.f);
    hsva.v = fmaxf(hsva.v, 0.f);
    
    hsva.a = fminf(alpha, 1.f);
    hsva.a = fmaxf(hsva.a, 0.f);
    
    return  hsva;
}

YMHSVAColor YMHSVColorFromRGBColor(const YMRGBAColor rgba)
{
    YMRGBAColor rgba255 = {rgba.r * 255.0f,rgba.g * 255.0f,rgba.b * 255.0f,rgba.a};
    YMHSVAColor hsva255 = {0.0f,0.0f,0.0f,rgba.a};
    YMHSVAColor hsva = {0.0f,0.0f,0.0f,rgba.a};
    
    float max = rgba255.r;
    if (max < rgba255.g) {
        max = rgba255.g;
    }
    if (max < rgba255.b) {
        max = rgba255.b;
    }
    hsva255.v = max;
    
    float min = rgba255.r;
    if (min > rgba255.g) {
        min = rgba255.g;
    }
    if (min > rgba255.b) {
        min = rgba255.b;
    }
    
    if (max == 0.0f) {
        hsva255.h = 0.0f;
        hsva255.s = 0.0f;
    }else{
        hsva255.s = 255*(max - min)/(double)max;
        int h = 0.0f;
        if(max == rgba255.r){
            h = 60 * (rgba255.g - rgba255.b) / (double)(max - min);
        }else if(max == rgba255.g){
            h = 60 * (rgba255.b - rgba255.r) / (double)(max - min) + 120;
        }else{
            h = 60 * (rgba255.r - rgba255.g) / (double)(max - min) + 240;
        }
        if(h < 0) h += 360;
        hsva255.h = (float)h;
    }
    hsva.h = hsva255.h / 360.0f;
    hsva.s = hsva255.s / 255.0f;
    hsva.v = hsva255.v / 255.0f;
    return hsva;
}

YMRGBAColor YMRGBColorFromHSVColor(const YMHSVAColor hsva)
{
    YMRGBAColor rgba = YMRGBAColorMake(0.f, 0.f, 0.f, hsva.a);
    
    if(hsva.s == 0.0f)
    {
        rgba.r = rgba.g = rgba.b = hsva.v;
        return rgba;
    }
    
    float h360 = hsva.h * 360.0f;
    int		i;
    float	f;
    float	m;
    float	n;
    float	k;
    
    i = floor(h360 /60);
    if(i < 0){
        i *= -1;
    }
    f = h360 / 60.0f - i;
    m = hsva.v * (1 - hsva.s);
    n = hsva.v * (1 - f * hsva.s);
    k = hsva.v * (1 - (1 - f) * hsva.s);
    
    switch (i) {
        case 0:{
            rgba.r = hsva.v;
            rgba.g = k;
            rgba.b = m;
            break;
        }
        case 1:{
            rgba.r = n;
            rgba.g = hsva.v;
            rgba.b = m;
            break;
        }
        case 2:{
            rgba.r = m;
            rgba.g = hsva.v;
            rgba.b = k;
            break;
        }
        case 3:{
            rgba.r = m;
            rgba.g = n;
            rgba.b = hsva.v;
            break;
        }
        case 4:{
            rgba.r = k;
            rgba.g = m;
            rgba.b = hsva.v;
            break;
        }
        case 5:{
            rgba.r = hsva.v;
            rgba.g = m;
            rgba.b = n;
            break;
        }
        default:
            break;
    }
    return rgba;
}

int YMHexColorFromRGBColor(const YMRGBAColor rgba)
{
    return (int)(rgba.r*255.0f) << 16 | (int)(rgba.g*255.0f) << 8 | (int)(rgba.b*255.0f) << 0;
}

int YMHexColorFromRGBAColor(const YMRGBAColor rgba)
{
    return (int)(rgba.r*255.0f) << 24 | (int)(rgba.g*255.0f) << 16 | (int)(rgba.b*255.0f) << 8 | (int)(rgba.a*255.0f) << 0;
}

