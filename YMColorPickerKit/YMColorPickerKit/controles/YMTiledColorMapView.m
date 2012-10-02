//
//  YMTiledColorMapView.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMTiledColorMapView.h"
#import <QuartzCore/QuartzCore.h>
#import "HRColorCursor.h"
#import "YMCGUtil.h"

@interface YMTiledColorMapView(){
@private
    YMHSVAColor hsva_;
    __weak YMColorPickerManager* manager_;
    CALayer* colorMapLayer_;
    HRColorCursor* colorCursor_;
    float tileSize_;
    float saturationUpperLimit_;
}

@end

@implementation YMTiledColorMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        tileSize_ = 15.0f;
        saturationUpperLimit_ = 0.95f;
        
        self.backgroundColor = [UIColor blackColor];
        colorMapLayer_ = [[CALayer alloc] init];
        colorMapLayer_.frame = self.bounds;
        [self createColorMapLayer];
        [self.layer addSublayer:colorMapLayer_];
        
        UIPanGestureRecognizer* panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        colorCursor_ = [[HRColorCursor alloc] init];
        [self addSubview:colorCursor_];
        [colorCursor_ setHidden:YES];
        
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
    
    colorCursor_.color = [UIColor colorWithHue:hsva_.h saturation:hsva_.s brightness:hsva_.v alpha:1.f];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    CGPoint location  = [recognizer locationInView:self];
    
    //[self updatePopupViewPosition:location];
    /*
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [popupView_ setHidden:YES];
    }*/
}

- (void)createColorMapLayer
{
    CGSize colorMapSize = self.frame.size;
    
    void(^renderToContext)(CGContextRef,CGRect) = ^(CGContextRef context, CGRect rect) {
        
        float height;
        int pixelCountX = rect.size.width/tileSize_;
        int pixelCountY = rect.size.height/tileSize_;
        
        YMHSVAColor pixelHsv;
        YMRGBAColor pixelRgb;
        for (int j = 0; j < pixelCountY; ++j) {
            height =  tileSize_ * j + rect.origin.y;
            float pixelY = (float)j/(pixelCountY-1); // Y(彩度)は0.0f~1.0f
            for (int i = 0; i < pixelCountX; ++i) {
                float pixelX = (float)i/pixelCountX; // X(色相)は1.0f=0.0fなので0.0f~0.95fの値をとるように
                
                pixelHsv.h = pixelX;
                pixelHsv.s = 1.0f - (pixelY * saturationUpperLimit_);
                pixelHsv.v = 1.f;
                
                NSLog(@"h %f s %f v %f",pixelHsv.h,pixelHsv.s,pixelHsv.v);
                
                //RGBColorFromHSVColor(&pixelHsv, &pixelRgb);
                pixelRgb = YMRGBColorFromHSVColor(pixelHsv);
                CGContextSetRGBFillColor(context, pixelRgb.r, pixelRgb.g, pixelRgb.b, 1.0f);
                
                CGContextFillRect(context, CGRectMake(tileSize_*i+rect.origin.x, height, tileSize_-2.0f, tileSize_-2.0f));
                
                
            }
        }
        
        //CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        //CGContextFillRect(context, rect);
    };
    
    UIImage* colorMapImage = YMImageFromBlocks(colorMapSize,renderToContext);
    
    colorMapLayer_.contents = (id)colorMapImage.CGImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
