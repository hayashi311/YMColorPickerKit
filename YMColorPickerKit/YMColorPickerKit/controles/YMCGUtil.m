//
//  YMCGUtil.m
//  YMColorPickerKit
//
//  Created by 亮太 林 on 7/1/12.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMCGUtil.h"

UIImage* YMImageFromBlocks(CGSize size,void(^renderToContext)(CGContextRef,CGRect))
{
    UIImage* image;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 scale*size.width, 
                                                 scale*size.height,
                                                 8,
                                                 scale*4*size.width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, 0, scale*size.height);
    CGContextScaleCTM(context, scale, -scale);
    
    CGRect imageRect = CGRectMake(0.f,
                                  0.f, 
                                  size.width,
                                  size.height);
    
    renderToContext(context,imageRect);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return image;
}

