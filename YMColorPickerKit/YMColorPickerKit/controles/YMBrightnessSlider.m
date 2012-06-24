//
//  YMBrightnessSlider.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMBrightnessSlider.h"
#import "HRBrightnessCursor.h"
#import "YMColorPickerManager.h"
#import "HRCgUtil.h"

@interface YMBrightnessSlider() {
@private
    HRBrightnessCursor* cursor_;
    YMHSVAColor hsva_;
    __weak YMColorPickerManager* manager_;
}

- (void)updateCursorPosition;

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer;

@end

@implementation YMBrightnessSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        cursor_ = [[HRBrightnessCursor alloc] initWithPoint:CGPointZero];
        [self addSubview:cursor_];
        UIPanGestureRecognizer* panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGestureRecognizer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [self updateCursorPosition];
}

- (void)updateCursorPosition
{
    cursor_.center = CGPointMake((self.frame.size.width-cursor_.frame.size.width)*(1.f-hsva_.v)+cursor_.frame.size.width/2.f,
                                 self.frame.size.height/2.f);
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
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    
    float positionX = fminf(location.x, self.frame.size.width - cursor_.frame.size.width/2.f);
    positionX = fmaxf(positionX, cursor_.frame.size.width/2.f);
    
    positionX -= cursor_.frame.size.width/2.f;
    
    hsva_.v = 1.f - positionX/(self.frame.size.width - cursor_.frame.size.width);
    [self updateCursorPosition];
    
    [manager_ updateHSVAColor:hsva_];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    HRSetRoundedRectanglePath(context, rect, 3.0f);
    CGContextClip(context);
    
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t numLocations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    YMHSVAColor darkColorHSVA = hsva_;
    darkColorHSVA.v = 0.f;
    
    YMHSVAColor lightColorHSVA = hsva_;
    lightColorHSVA.v = 1.f;
    
    YMRGBAColor darkColorRGBA = YMRGBColorFromHSVColor(darkColorHSVA);
    YMRGBAColor lightColorRGBA = YMRGBColorFromHSVColor(lightColorHSVA);
    
    CGFloat gradientColor[] = {
        darkColorRGBA.r,darkColorRGBA.g,darkColorRGBA.b,1.0f,
        lightColorRGBA.r,lightColorRGBA.g,lightColorRGBA.b,1.0f,
    };
    
    gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColor,
                                                   locations, numLocations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(rect), rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // GradientとColorSpaceを開放する
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
}


@end
