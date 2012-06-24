//
//  YMColorMapView.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorMapView.h"
#import <QuartzCore/QuartzCore.h>
#import "YMColor.h"
#import "YMColorPickerManager.h"

@interface YMColorMapView() {
@private
    YMHSVAColor hsva_;
    __weak YMColorPickerManager* manager_;
    CALayer* colorMapLayer_;
}

- (void)createColorMapLayer;
- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer;
@end

@implementation YMColorMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        colorMapLayer_ = [[CALayer alloc] init];
        colorMapLayer_.frame = self.bounds;
        [self createColorMapLayer];
        [self.layer addSublayer:colorMapLayer_];
        
        UIPanGestureRecognizer* panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)setManager:(__weak YMColorPickerManager*)manager
{
    manager_ = manager;
}

- (YMHSVAColor)HSVAColor
{
    return hsva_;
}

- (void)setHSVAColor:(YMHSVAColor)hsva
{
    hsva_ = hsva;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
    colorMapLayer_.opacity = hsva_.v;
    [CATransaction commit];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    CGPoint location  = [recognizer locationInView:self];
    
    location.x = fminf(location.x, self.frame.size.width);
    location.x = fmaxf(location.x, 0.f);
    
    location.y = fminf(location.y, self.frame.size.height);
    location.y = fmaxf(location.y, 0.f);
    
    hsva_.h = location.x/self.frame.size.width;
    hsva_.s = 1.f - location.y/self.frame.size.height;
    [manager_ updateHSVAColor:hsva_];
}

- (void)createColorMapLayer
{
    CGSize colorMapSize = CGSizeMake(60.f, 60.f);
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, scale*colorMapSize.width, scale*colorMapSize.height, 8, scale*4*colorMapSize.width, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, 0, scale*colorMapSize.height);
    CGContextScaleCTM(context, scale, -scale);
    
    int pixelCountX = (int)colorMapSize.width*scale;
    int pixelCountY = (int)colorMapSize.height*scale;
    float tileSize = 1.f / scale;
    float saturationUpperLimit = 1.f;
    
    YMHSVAColor pixelHSVA = YMHSVAClearColor();
    pixelHSVA.v = 1.f;
    pixelHSVA.a = 1.f;
    
    for (int j = 0; j < pixelCountY; ++j) {
        float height =  tileSize * j;
        float saturation = (float)j/(pixelCountY-1); // Y(彩度)は0.0f~1.0f
        for (int i = 0; i < pixelCountX; ++i) {
            float hue = (float)i/pixelCountX; // X(色相)は1.0f=0.0fなので0.0f~0.95fの値をとるように
            pixelHSVA.h = hue;
            pixelHSVA.s = 1.0f - (saturation * saturationUpperLimit);
            YMRGBAColor pixelRGBA = YMRGBColorFromHSVColor(pixelHSVA);
            CGContextSetRGBFillColor(context, pixelRGBA.r, pixelRGBA.g, pixelRGBA.b, 1.0f);
            CGContextFillRect(context, CGRectMake(tileSize*i, height, tileSize, tileSize));
        }
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    UIImage* uiimage = [UIImage imageWithCGImage:image];
    
    colorMapLayer_.contents = (id)uiimage.CGImage;
    
    CGImageRelease(image);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
}

/*

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(context, rect);
}
*/

@end
