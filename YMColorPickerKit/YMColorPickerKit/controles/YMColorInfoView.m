//
//  YMColorInfoView.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorInfoView.h"
#import "HRCgUtil.h"
#import "YMCGUtil.h"

@interface YMColorInfoView() {
@private
    YMHSVAColor hsva_;
    UIImage* backImage_;
}
@end

@implementation YMColorInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        hsva_ = YMHSVAClearColor();
        
        void(^renderToContext)(CGContextRef,CGRect) = ^(CGContextRef context, CGRect rect) {
            
            CGRect baseRect = rect;
            CGRect badgeRect = CGRectMake(rect.origin.x + 3.f,
                                          rect.origin.y + 3.f,
                                          rect.size.width - 6.f,
                                          rect.size.height - 6.f);
            
            CGRect shadowRect = CGRectMake(rect.origin.x - 3.f,
                                           rect.origin.y - 3.f,
                                           rect.size.width + 6.f,
                                           rect.size.height + 6.f);
            
            CGContextSaveGState(context);
            HRSetRoundedRectanglePath(context, baseRect,5.0f);
            CGContextClip(context);
            HRSetRoundedRectanglePath(context, shadowRect,7.0f);
            CGContextSetLineWidth(context, 5.5f);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(.0f, -.5f), 5.0f, [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor);
            CGContextDrawPath(context, kCGPathStroke);
            CGContextRestoreGState(context);
            
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.5f), 0.5f, [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor);
            HRSetRoundedRectanglePath(context, badgeRect,3.0f);
            CGContextDrawPath(context, kCGPathFill);
            CGContextRestoreGState(context);
            
        };
        
        backImage_ = YMImageFromBlocks(CGSizeMake(frame.size.height,
                                                  frame.size.height),
                                       renderToContext);
        
    }
    return self;
}

- (void)setManager:(__weak YMColorPickerManager*)manager
{
    
}

- (YMHSVAColor)HSVAColor
{
    return hsva_;
}

- (void)setHSVAColor:(YMHSVAColor)hsva
{
    hsva_ = hsva;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [backImage_ drawInRect:CGRectMake(0.f,
                                      0.f,
                                      rect.size.height,
                                      rect.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect colorRect = CGRectMake(3.f, 
                                  3.f,
                                  rect.size.height-6.f,
                                  rect.size.height-6.f);
    UIColor* color = [UIColor colorWithHue:hsva_.h saturation:hsva_.s brightness:hsva_.v alpha:hsva_.a];
    [color set];
    HRSetRoundedRectanglePath(context, colorRect, 3.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    /////////////////////////////////////////////////////////////////////////////
    //
    // RGBのパーセント表示
    //
    /////////////////////////////////////////////////////////////////////////////
    
    [[UIColor darkGrayColor] set];
    
    UIFont* font = [UIFont boldSystemFontOfSize:12.0f];
    float textHeight = [font lineHeight];
    float textCenter = CGRectGetMidY(colorRect) - 10.f;
    float textLeft = CGRectGetMaxX(colorRect) + 10.f;
    YMRGBAColor currentRgbColor = YMRGBColorFromHSVColor(hsva_);
    
    [[NSString stringWithFormat:@"R:%3d%%",(int)(currentRgbColor.r*100)] drawAtPoint:CGPointMake(textLeft, textCenter - textHeight) withFont:font];
    [[NSString stringWithFormat:@"G:%3d%%",(int)(currentRgbColor.g*100)] drawAtPoint:CGPointMake(textLeft, textCenter) withFont:font];
    [[NSString stringWithFormat:@"B:%3d%%",(int)(currentRgbColor.b*100)] drawAtPoint:CGPointMake(textLeft, textCenter + textHeight) withFont:font];
    
}


@end
