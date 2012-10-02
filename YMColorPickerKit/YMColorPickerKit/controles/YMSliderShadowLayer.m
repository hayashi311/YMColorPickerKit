//
//  YMSliderShadowLayer.m
//  YMColorPickerKit
//
//  Created by 亮太 林 on 7/1/12.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMSliderShadowLayer.h"
#import "YMCGUtil.h"
#import "HRCgUtil.h"

@implementation YMSliderShadowLayer

- (id)initWithLayer:(CALayer*)layer
{
    self = [super initWithLayer:layer];
    
    if (self) {
        
        CGSize shadowSize = layer.frame.size;
        
        self.bounds = layer.bounds;
        self.position = CGPointMake(layer.bounds.size.width/2.f, layer.bounds.size.height/2.f);
        
        void(^renderToContext)(CGContextRef,CGRect) = ^(CGContextRef context, CGRect rect) {
            
            HRSetRoundedRectanglePath(context, rect, 5.0f);
            CGContextClip(context);
            CGRect shadowRect = CGRectMake(rect.origin.x-5.f,
                                           rect.origin.y-5.f,
                                           rect.size.width+10.f,
                                           rect.size.height+10.f);
            
            HRSetRoundedRectanglePath(context, shadowRect, 5.0f);
            CGContextSetLineWidth(context, 10.0f);
            CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 10.0f);
            CGContextDrawPath(context, kCGPathStroke);
        };
        
        UIImage* shadowImage = YMImageFromBlocks(shadowSize,renderToContext);
        
        self.contents = (id)shadowImage.CGImage;
    }
    
    return self;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
}

@end
